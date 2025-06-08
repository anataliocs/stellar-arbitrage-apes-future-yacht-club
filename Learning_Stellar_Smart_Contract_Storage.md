**NOTE:  THIS DOC IS A WIP**
Please send me any feedback you may have.

# Learning Stellar Smart Contract Storage from an On-Chain Point System

This developer journey will walk you through the intricacies of Stellar smart contract storage and also give you some
great practical knowledge about implementing your own contracts. We will take a low-level approach to really examine
some fundamental concepts.

The tutorial is structured in a way that follows the trials and tribulations of a new developer, named **SammyB**, as
they make mistakes and learn lessons about Stellar smart contract storage.

This tutorial is designed for new Stellar developers that have gotten past the basics and intermediate developers as
well\! If you are totally [new to the Stellar ecosystem check out this primer video](http://restorePersistentData.ts).

While Stellar smart contract storage can seem pretty complicated at first, it offers a huge amount of opportunity for
optimization\! So a little bit of work up front, will go a long way down the line for your protocol\!

Storage on Stellar smart contracts has a learning curve but is built to scale and be sustainable well into the future\!

Follow along with [the code here](https://github.com/anataliocs/happy-points-system).

---

# Lesson 1:  Point System Smart Contract

We want to keep track of how many points each user has.

**Assumptions**

* Point balance can’t go negative
* The total is constrained by the [integer type](https://doc.rust-lang.org/book/ch03-02-data-types.html#integer-types) (
  Without [Overflowing](https://doc.rust-lang.org/book/ch03-02-data-types.html#integer-overflow))
* It’s a commonly accessed variable

The writer of this contract, **SammyB**, picks an `u128` unsigned integer to store point balances.

Points balances need to be associated with a specific Stellar Account (Learn more
about [Stellar Accounts](https://developers.stellar.org/docs/learn/fundamentals/stellar-data-structures/accounts) or
in [video format](https://www.youtube.com/watch?v=Lxg61mH-P6o&list=PLmr3tp_7-7GiyTrRhKjlznmWe7AqFPq6i&index=22)).

## How does Stellar Smart Contract Storage Work Internally?

Stellar smart contracts have the concept of
an [execution environment](https://developers.stellar.org/docs/learn/encyclopedia/contract-development/environment-concepts).

The `Env` object provides access to the host environment that each contract invocation interacts with to access smart
contract storage.

It’s an interface that defines how to interact with the following:

* Host Objects
* Functions

Host Objects can be in the form of various data structures such as:

* Vectors
* Maps
* Binary blobs

When you deploy a smart contract, it’s compiled to WASM bytecode and then runs in
the [WebAssembly](https://webassembly.org/) (WASM) virtual machine (VM).

When a smart contract is invoked, a Guest Environment(executing in the WASM VM) is created, from which, it can access
Host Objects with a unique key consisting of:

1. Contract ID(`scAddress`)
2. Contract Durability(`ContractDataDurability`)
3. A unique chosen key(`scVal`)

### TL;DR;

Basically, it’s just a super fancy decentralized key/value pair distributed storage system that can hold virtually any
type of object or data on the Stellar Network\!

---

## Interacting with the Host Environment

The [Soroban Rust SDK](https://docs.rs/soroban-sdk/latest/soroban_sdk/) contains a member named `Env`. You can import it
in your contract like this:

```rust
use soroban_sdk::{Env};
```

The `env.storage()` function gives
you [access to data in the currently executing contract](https://docs.rs/soroban-sdk/22.0.5/soroban_sdk/struct.Env.html#method.storage).

There are 3 types of storage:

* [Temporary](https://developers.stellar.org/docs/build/guides/storage/use-temporary)
* [Instance](https://developers.stellar.org/docs/build/guides/storage/use-instance)
* [Persistent](https://developers.stellar.org/docs/build/guides/storage/use-persistent)

**SammyB** decides to use `instance storage`. Learn more about the basics
of [contract storage here](https://developers.stellar.org/docs/build/smart-contracts/example-contracts/storage).

*Here is the Contract code with some added context.*

*
*Contract:  [https://github.com/anataliocs/happy-points-system/blob/main/contracts/points/src/lib.rs\#L9](https://github.com/anataliocs/happy-points-system/blob/main/contracts/points/src/lib.rs#L9)
**

```rust
// Prevents loading of standard library to keep the memory footprint light
#![no_std]
use soroban_sdk::{Address, contract, contractimpl, contracttype, Env};

// This is a Attribute Procedural Macro that attaches a bunch of attributes, traits and // more  
#[contract]
pub struct HappyPointsSystem;

// Another Attribute Procedural Macro 
#[contractimpl]
impl HappyPointsSystem {

    pub fn set_balance(env: &Env, amount: u128, addr: Address) {
	 // We use a Variable DataKey enum as the key to store the point balance
        let key = DataKey::Balance(addr);
	 // Then we store the key/value pair in instance storage
        env.storage().instance().set::<DataKey, u128>(&key, &amount);
    }

    pub fn get_balance(env: &Env, addr: Address) -> u128 {
        let key = DataKey::Balance(addr);

	 //In Rust, the tail expression will implicitly return it's value
        env.storage().instance().get::<DataKey, u128>(&key).unwrap_or(0)
    }
}

// The Clone trait means this  cannot be 'implicitly copied'
#[derive(Clone)]
// Another Attribute Procedural Macro
#[contracttype]
pub enum DataKey {
    Balance(Address),
}
```

**Several things to note here:**

* A lot of the boilerplate code is abstracted away
  in [Attribute Procedural Macros](https://doc.rust-lang.org/reference/procedural-macros.html#attribute-macros)
* They function similar to Annotations in other languages/frameworks
* A enumerated type named `DataKey` is used as the key to store and lookup data

---

# Lesson 1: When NOT to Use Instance Storage

*Instance storage has many pros & cons you should consider.*

**SammyB didn’t realize the following about instance storage:**

Instance storage is a small, limited-size map attached to the contract instance. The total size of all keys and values
is limited by the ledger entry size limit which is currently 128 KiB(
That [ledger entry size limit value](https://developers.stellar.org/docs/networks/resource-limits-fees) may change in
the future).

**What happened?**

* A Stellar Address is 32 bytes and the Unsigned Integer type used is 128 bits
* There’s 8 bits in a byte and 1024 bytes in a Kilobyte right? Currently, instance storage is constrained to 131,072
  bytes(Closer to 100KiB serialized data in reality)
* Once the contract got to \~900-1000 addresses, it blew up leading to contract failure

**What else could go wrong?**

All data stored in `instance()` storage is retrieved from the ledger EVERY time a contract is invoked. This can be
inefficient if there is unnecessary data stored in there.

Using variable DataKeys for instance data can also be problematic.

**What SHOULD be stored in Instance Storage?**

ONLY Global data that is shared among all users of the contract such as the contract admin. Also, instance storage is
slightly cheaper than persistent storage even though they have the same durability.

---

# Lesson 2:  Using Persistent Storage

Next, **SammyB** tries persistent storage.

The code is similar but uses `persistent()` instead of `instance()`

```rust
    pub fn set_balance_persistent(env: &Env, amount: u128, addr: Address) {
        let key = DataKey::Balance(addr);
        env.storage().persistent().set::<DataKey, u128>(&key, &amount);
    }

    pub fn get_balance_persistent(env: &Env, addr: Address) -> u128 {
        let key = DataKey::Balance(addr);
        env.storage().persistent().get::<DataKey, u128>(&key).unwrap_or(0)
    }
```

## Persistent Storage Characteristics

It is used for storing data on the network over an indefinitely long time period. Learn more
about [persistent storage here](https://developers.stellar.org/docs/build/guides/storage/use-persistent).

**Key Points**

* Most expensive
* Data is archived when TTL expires
* Number of keys is unlimited

Persistent storage is the “default” for most use-cases. Instance and Temporary storage are only useful in specific
use-cases.

**What should be stored in Persistent**

* User balances
* Token metadata
* Voting and governance decisions
* Basically everything that isn’t global or ephemeral

## How much does it cost?

Both instance storage and persistent storage have the same durability.

Using the unit testing method to estimate relative fees, persistent storage is slightly more expensive than instance
storage.

Learn more about [fees on the resource page](https://developers.stellar.org/docs/networks/resource-limits-fees).

```
INSTANCE STORAGE
total_fee: 31439
PERSISTENT STORAGE
total_fee: 38268
```

You can calculate this yourself in a unit test using:

```rust
let total_fee = &env.cost_estimate().fee().total;
```

Be sure to run your tests with the flag `cargo test -- --nocapture` to ensure the logs are printed to your console.

---

# Lesson 3:  Persistent Does not Mean Forever

Persistent storage is the choice for storing data for an indefinite amount of time. But not without a bit of extra work.

**SammyB didn’t understand the concept of Time-to-Live(TTL):**

Everything was fine for a while and then one day his data suddenly was no longer available on-chain. Data has to pay
rent to continue to live on-chain past a certain point.

**What happened?**

* Blockchain data cannot grow unbounded forever
* A huge memory footprint makes validators more expensive and difficult to run as well as slower
* Stellar is currently the only blockchain to have solved this ticking timebomb of State Bloat with their
  novel [state archival strategy](https://developers.stellar.org/docs/learn/encyclopedia/storage/state-archival)
* `ContractData` has a `liveUntilLedger` field stored in its `LedgerEntry`
* Stellar ledger time is about \~5s currently and once that ledger \# is reached, the data is archived if persistent or
  instance durability(or deleted if temporary durability)

### How do I get my data back?

**There are two operations to consider:**

* [ExtendFootprintTTLOp](https://stellar.github.io/js-stellar-sdk/Operation.html#.extendFootprintTtl) \- Extends the
  liveUntilLedger to a later ledger number
* [RestoreFootprintOp](https://stellar.github.io/js-stellar-sdk/Operation.html#.restoreFootprint) \- Will restore
  archived entries

**General Process of performing these operations:**

* Identify the ledger entries from a Stellar RPC server
* Prepare the ExtendFootprintTTLOp or RestoreFootprintOp operation
* Submit the transaction
* Perform this operation regularly on actively used storage entries

### Minimum Initial TTL \- Included Rent

Persisting data initially will give your data
an [initial default TTL which is set by the current resource limits here](https://developers.stellar.org/docs/networks/resource-limits-fees).

**Currently the minimum initial TTL is:**

* \~120 days for persistent and instance storage
* \~1 day for temporary storage

When creating data you also have the option to extend that initial minimum TTL by up to \~6 months. If the TTL lapses,
the data will be archived if it’s persistent or instance storage and deleted if it’s temporary.

Your contract instance itself is also stored with persistent durability and has a TTL that needs to be extended. If TTL
lapses the contract itself will need to be restored\!

Instance storage and your contract instance share a TTL. Calling the `extend_ttl()` method can be used to extend the TTL
of all instance storage entries, as well as the contract instance itself.

**Here is an example:**

```
env.storage().instance().extend_ttl(50, 100);
```

**NOTE:**  Temporary storage is gone FOREVER if the TTL lapses and cannot be restored.

Learn more about the process
of [unarchiving data and extending TTLs here](https://developers.stellar.org/docs/learn/encyclopedia/storage/state-archival#examples).

### Paying Rent to Live On-Chain

Blockspace isn’t free. The Stellar Network is a public good shared by all the members of its community.

Users must pay a small fee to keep their data active on-chain.

This is the process of paying rent, or extending the TTL to keep your data live.

Let’s take a look at the cost of rent for persistent and instance storage using the unit testing method:

```t
INSTANCE STORAGE
persistent_entry_rent: 12663
total_fee: 31439
persistent_rent_ledger_bytes: 376740
write bytes: 196
Instance TTL: 4095

PERSISTENT STORAGE
persistent_entry_rent: 13849
total_fee: 38268
persistent_rent_ledger_bytes: 589680
write bytes: 144
Persistent TTL: 4095
```

Rent is higher for persistent storage since it has a separate TTL that must be extended in addition to the contract
instance TTL.

### Extending the TTL during the Initial Persistence Operation \- Pre-Paying Rent upon Move-In

You can extend the TTL when saving data on-chain if you want a longer initial TTL than minimum.

Let’s take a look at the cost of rent for persistent and instance storage with an initial extended TTL to 10,000 ledgers
using the unit testing method:

```
INSTANCE STORAGE EXTENDED TTL
persistent_entry_rent: 31385
total_fee: 56514
persistent_rent_ledger_bytes: 1841180
write bytes: 196
Instance Extended TTL: 10000

PERSISTENCE STORAGE EXTENDED TTL
persistent_entry_rent: 44846
total_fee: 75629
persistent_rent_ledger_bytes: 2361180
write bytes: 144
Persistent TTL: 4095
Persistent Extended TTL: 10000
```

**Remember:**

* Persistent storage, the contract instance and code must be extended separately since they have separate TTLs
* When instance storage is extended, it extends both the instance storage and the contract instance

Learn more
about [unit testing TTL extensions here](https://developers.stellar.org/docs/build/guides/archival/test-ttl-extension)\!

---

# Lesson 4: Using Persistent Storage with Extended TTL

Now, **SammyB** tries persistent storage with an extended initial TTL.

Here is the updated `setBalance()` code:

```rust
    pub fn set_persistent_extended(env: &Env, amount: u128, addr: Address) {
        let key = DataKey::Balance(addr);
        env.storage().persistent().set::<DataKey, u128>(&key, &amount);

    	 /// Extend the persistent entry TTL to 10,000 ledgers, when its
    	 /// TTL is smaller than 4095 ledgers
        env.storage().persistent().extend_ttl(&key, 4095, 10000);

 // Extend TTL of all Instance entries, as well 
 // as the contract instance itself
        env.storage().instance().extend_ttl(4095, 10000);
    }
```

**Things to note in Stellar smart contracts:**

* Persistence storage entries are extended individually by passing in their key
* Instance storage and the contract instance are extended together, but their thresholds are evaluated separately

**Using the following unit test we can check if this TTL extension operation is successful:**

```rust
#[test]
fn set_persistent_extended() {
    const EXPECTED_VALUE: &u128 = &123;
    let env = Env::default();
    let contract_id = env.register(PointSystem, ());
    let client = PointSystemClient::new(&env, &contract_id);

    let user_1 = Address::generate(&env);
    client.set_persistent_extended(EXPECTED_VALUE, &user_1);

    env.as_contract(&contract_id, || {
        let key = DataKey::Balance(user_1);
        let ttl = env.storage().persistent().get_ttl(&key);
        assert_eq!(&ttl, &10000);
    });
}
```

Remember to run your tests with the flag `cargo test -- --nocapture` to ensure the logs are printed to your console.

---

# Lesson 5:  No Grace Period on Paying Rent

If the TTL lapses on either the contract instance, instance storage or important persistent storage, some or all of your
data will be unavailable on-chain until it is restored.

## COMING SOON:  Automatic Restoration of Archived Data

*New features slated for Protocol 23 release.*

**There is a series of Core Advancement Proposals planned to improve the core Stellar Protocol listed here:**

* [CAP-0066 CAP-0066 Soroban In-memory Read Resource](https://github.com/stellar/stellar-protocol/blob/master/core/cap-0066.md)
* [CAP-0057 State Archival Persistent Entry Eviction](https://github.com/stellar/stellar-protocol/blob/master/core/cap-0057.md)
* [CAP-0062 Soroban Live State Prioritization](https://github.com/stellar/stellar-protocol/blob/master/core/cap-0062.md)

**Collectively they will have the following effect:**

* Safe automatic entry restoration of archived persistent entries
* Any archived key present in the footprint is automatically restored
* Automatic restoration via InvokeHostFunctionOp
* Increased limits and throughput
* Greatly increased read limits for Soroban data

*Until, then, explicit restore operations will be required for archived data.*

## Actively Extending TTL in Smart Contract Logic

Extending the TTL of active data is cheaper than restoring it from cold storage. This is the preferred option for any
actively accessed persistent storage entries. Otherwise, it will get archived and will have to be restored.

**Some Best Practices we will walk through:**

* Extend the TTL of any shared state touched by an invocation
* Subsidize shared state TTL extension fees by manually submitting extend operations

### If Data gets Accessed, extend it\!

If data gets accessed, it's a good idea to extend the TTL on that persistent storage entry.

**Let’s take a look at how we could do that:**

```rust
    pub fn get_balance(env: &Env, addr: Address) -> u128 {
        let key = DataKey::Balance(addr);
        let balance = env.storage().persistent().get::<DataKey, u128>(&key).unwrap_or(0);
        Self::extend_ttl(env, key);

        balance
    }

    fn extend_ttl(env: &Env, key: DataKey) {
        env.storage().persistent().extend_ttl(&key, 4095, 10000);
    }
```

**In this example:**

* *Assumption:  If a user invokes a function to read a specific piece of data at a key, it’s data that is active and
  should be extended*
* When the `get_balance()` function is invoked
* The persistent storage entry for that key has its TTL extended by calling the `Self::extend_ttl()` function before
  returning the balance

With this pattern, any actively accessed persistent storage data will get its TTL extended and stay active for users\!

### Manually submitting extended operations \- Good Housekeeping

It’s also a good idea to actively extend TTLs of data you know will get accessed.

**Here is a snippet of code demonstrating extending instance storage on testnet:**

```javascript
    const data = new SorobanDataBuilder().setResourceFee(200_000).setReadOnly([instance]).build();
const transaction = new TransactionBuilder(account, {
  fee,
  networkPassphrase: Networks.TESTNET,
}).setSorobanData(data).addOperation(
    Operation.extendFootprintTtl({
      extendTo: 10_000,
    }),
).setTimeout(20).build();
```

Check out this article for more details
on [extending TTL with the Stellar Javascript SDK](https://developers.stellar.org/docs/build/guides/conventions/extending-wasm-ttl).

We will go into a much more detailed example about how to execute this operation in the next section\!

---

# Lesson 6:  Persistent Storage with Active TTL Extensions

Let’s look at how we can actively extend TTL for persistent and instance data using the Stellar Javascript SDK.

*NOTE:  There is no access control for TTL extension operations. Any user may invoke `ExtendFootprintTTLOp` on any
LedgerEntry.*

**So SammyB is now:**

* Using persistent storage with an extended initial TTL
* Actively extending the TTL when data is accessed
* Actively extending the TTL of data that they know is important
* Using the Javascript SDK to extend TTL for a persistent storage ledger entry

## Active TTL Extension for Persistent Storage by Key using the Stellar CLI

Since our persistent storage entry uses a variable DataKey, `Balance(Address)` in the token contract, we’ll need to
provide the key in a base64-encoded XDR form.

We can do this with the Stellar CLI.

The Ledger Key will be in the following JSON format:

```json
{
  "contract_data": {
    "contract": "CBRS2MTQ42YB767ZWXAJBPJAZUVEH2WOVJUTNSQRNQHUSRAUFC3NWMEN",
    "key": {
      "vec": [
        {
          "symbol": "Balance"
        },
        {
          "address": "GANUUSIQOCQOGQRV5KR7CO64SATSFLLPRRWX5XDKXYFZ7Y4XWTEALQOX"
        }
      ]
    },
    "durability": "persistent"
  }
}
```

If you save the above JSON as a file named `ledgerkey.json`.

You can encode this with the Stellar CLI using the following command:

```
stellar xdr encode --type LedgerKey --input json --output single-base64 ledgerkey.json
```

Which will output the following XDR value:

```
AAAABgAAAAFjLTJw5rAf+/m1wJC9IM0qQ+rOqmk2yhFsD0lEFCi22wAAABAAAAABAAAAAgAAAA8AAAAHQmFsYW5jZQAAAAASAAAAAAAAAAAbSkkQcKDjQjXqo/E73JAnIq1vjG1+3Gq+C5/jl7TIBQAAAAE=
```

Then use the Stellar CLI passing in the XDR value above as a parameter for `–key-xdr`

**Extend TTL of persistent storage by 10,000 ledgers:**

```
stellar contract extend \
    --source S... \
    --network testnet \
    --id C... \
    --key-xdr AAAABgAAAAFjLTJw5rAf+/m1wJC9IM0qQ+rOqmk2yhFsD0lEFCi22wAAABAAAAABAAAAAgAAAA8AAAAHQmFsYW5jZQAAAAASAAAAAAAAAAAbSkkQcKDjQjXqo/E73JAnIq1vjG1+3Gq+C5/jl7TIBQAAAAE= \
    --ledgers-to-extend 10000 \
    --durability persistent
```

## Active TTL Extension using the Stellar Javascript SDK

You can follow along with a live code example of using
the [Stellar Javascript SDK to perform a extendFootprintTtl operation here](https://github.com/anataliocs/happy-points-system/blob/main/scripts/extendPersistentTtl.ts).

We can also use the Javascript SDK. The persistent storage DataKey, `DataKey::Balance(addr)` is represented as a vector
with 2 values, the symbol `“Balance”` and an `Address`.

```javascript
const accountId = Keypair.fromPublicKey("GANUUSIQOCQOGQRV5KR7CO64SATSFLLPRRWX5XDKXYFZ7Y4XWTEALQOX").xdrAccountId();

// Persistent DataKey XDR value
const dataKey = xdr.ScVal.scvVec([
  xdr.ScVal.scvSymbol("Balance"), xdr.ScVal.scvAddress(xdr.ScAddress.scAddressTypeAccount(accountId))
]);
```

### Defining the Read-Only Footprint for the Transaction

Then we define the entries in the read-only set of the footprint for the operation to include this persistent data entry
using a `SorobanDataBuilder()`. We defined the `dataKey` variable in the previous code block.

```javascript
    // Get the contract instance
const contract = new Contract("C...");

// Set footprint to persistent storage ledger entry
const persistentData = contract.getFootprint().contractData().key(dataKey);
const persistentDataLedgerEntry = await rpcServer.getContractData(contract, persistentData, rpc.Durability.Persistent);

// Set Soroban data read-only footprint
const sorobanData = new SorobanDataBuilder().setResourceFee(200_000).
    setReadOnly([persistentDataLedgerEntry.key]).
    build();
```

### Building, Simulating, Assembling and Sending the Transaction

Then we build a transaction, passing in our sorobanData with the persistent storage entry in the read-only footprint and
add in a `extendFootprintTtl` operation which will update the `liveUntilLedger` of the persistent storage ledger entries
we included by key.

Check out this page
for [more info on extendFootprintTtl](https://github.com/kommitters/stellar_sdk/blob/main/docs/examples/soroban/extend_footprint_ttl.md).

Then we simulate, assemble and send the transaction using a rpcSever instance.

```javascript
    let account = await rpcServer.getAccount(getSourceKeypair().publicKey());

// Build Transaction with extendFootprintTtl operation
const transaction = new TransactionBuilder(account, {fee, networkPassphrase,}).setSorobanData(sorobanData).addOperation(
    Operation.extendFootprintTtl({
      extendTo: 200000
    }),
).setTimeout(30).build();

// Simulate, assemble and send transaction
const ttlSimResponse: rpc.Api.SimulateTransactionResponse =
    await rpcServer.simulateTransaction(transaction);
const assembledTransaction =
    rpc.assembleTransaction(transaction, ttlSimResponse).build();
const result =
    await rpcServer.sendTransaction(assembledTransaction);
```

### Reviewing the Results of the Successful Operation

Upon successful execution we can decode the OperationMeta XDR on [https://lab.stellar.org/](https://lab.stellar.org/) or
using the Stellar CLI.

We can see that the `live_until_ledger_seq` was increased from `3825757` to `3845786` in this example.

```
OperationMeta XDR: 
AAAAAgAAAAMADOmyAAAACQ105ApUOopEQuL9hMdJJzeOqY6cQCvCURx9n6i1KIntADpgXQAAAAAAAAABAAzpzwAAAAkNdOQKVDqKRELi/YTHSSc3jqmOnEArwlEcfZ+otSiJ7QA6rpoAAAAA 
```

```json

{
  "changes": [
    {
      "state": {
        "last_modified_ledger_seq": 846258,
        "data": {
          "ttl": {
            "key_hash": "0d74e40a543a8a4442e2fd84c74927378ea98e9c402bc2511c7d9fa8b52889ed",
            "live_until_ledger_seq": 3825757
          }
        },
        "ext": "v0"
      }
    },
    {
      "updated": {
        "last_modified_ledger_seq": 846287,
        "data": {
          "ttl": {
            "key_hash": "0d74e40a543a8a4442e2fd84c74927378ea98e9c402bc2511c7d9fa8b52889ed",
            "live_until_ledger_seq": 3845786
          }
        },
        "ext": "v0"
      }
    }
  ]
}
```

We can also take a look at decoded `TransactionResult` XDR and see that the `extend_footprint_ttl` operation was
successful.

```
TransactionResult XDR: 
AAAAAAAApFIAAAAAAAAAAQAAAAAAAAAZAAAAAAAAAAA=

{
  "fee_charged": 42066,
  "result": {
    "tx_success": [
      {
        "op_inner": {
          "extend_footprint_ttl": "success"
        }
      }
    ]
  },
  "ext": "v0"
}
```

Check out this repo for a live code example of using
the [Stellar Javascript SDK to perform a extendFootprintTtl operation here](https://github.com/anataliocs/happy-points-system/blob/main/scripts/extendPersistentTtl.ts)
that you can run locally.

---

# Lesson 7:  Paying Rent to Extend TTL is Easier and Cheaper than Restoring Archived Data

Actively extending the TTL of data is a much better practice than discovering data has been archived and then having to
recover it. But it’s not the end of the world if you have to restore data.

Let’s demonstrate the approach with the Stellar Javascript SDK. Let’s say we have to restore a piece of persistent
storage that uses the same `DataKey` as before.

```javascript
    // Create our DataKey with a [Symbol,Address] vector
let dataKey = xdr.ScVal.scvVec([
  xdr.ScVal.scvSymbol("Balance"),
  xdr.ScVal.scvAddress(xdr.ScAddress.scAddressTypeAccount
  (persistentStorageAccountId))]);

// This LedgerKey will be added to the footprint of our transaction
const contract = new Contract(getDeployedContractId());

let ledgerKeyContractData = new xdr.LedgerKeyContractData({
  durability: xdr.ContractDataDurability.persistent(),
  contract: xdr.ScAddress.scAddressTypeContract(contract.address().toBuffer()),
  key: dataKey
});
let ledgerKeyXdr = xdr.LedgerKey.contractData(ledgerKeyContractData);
```

We add this key to our restoration footprint in our transaction, then we execute a `RestoreFootprintOp` operation that
will restore our archived data\! We might as well extend the TTL while we’re at it as well.

Learn more about
this [restoration process here](https://developers.stellar.org/docs/build/guides/archival/create-restoration-footprint-js).

### Restoring Archived Persistent Data

```javascript
    // Set the LedgerKey in the Read/Write section of the Soroban data
const sorobanData = new SorobanDataBuilder().setResourceFee(200_000).setReadWrite([ledgerKeyXdr]).build();

// Then we will simulate, assemble and submit the restoreFootprint() operation 
let assembledTransaction =
    await getAssembledSignedTransaction(sorobanData, rpcServer,
        Operation.restoreFootprint({}));
const result =
    await rpcServer.sendTransaction(assembledTransaction);
```

The archived persistent storage entry linked to that LedgerKey will then be restored after the operation completes. You
can review
a [full example of this process here](https://github.com/anataliocs/happy-points-system/blob/main/scripts/restorePersistentData.ts)
in the file `restorePersistentData.ts`\!

After submitting the `RestoreFootprintOp` operation, we can poll for success, print the results to console and finally
extend the TTL for good measure.

```javascript
        // Periodically pool for operation success
return await pollForTransactionCompletion(rpcServer, result).then(async res => {
  // Then if the restore operation is successful, extend the TTL
  if (res === "SUCCESS") {
    // Create an operation to extend the data's TTL
    const extendTTLSorobanData = new SorobanDataBuilder().setResourceFee(200_000)
        // Please note extending TTL footprint is ReadOnly
        // While restoring uses the Read/Write footprint
        .setReadOnly([ledgerKeyXdr]).build();

    // Then simulate, assemble and submit the transaction
    await getAssembledSignedTransaction(extendTTLSorobanData, rpcServer,
        Operation.extendFootprintTtl({
          extendTo: 2000,
        }));
  }
});
```

One final note, if the contract instance was expired, you would not be able to perform this restoration operation until
the contract instance is restored.

Check out
the [docs to learn more about state archival.](https://developers.stellar.org/docs/learn/encyclopedia/storage/state-archival#example-my-data-is-archived)

---

## Restoring a Contract Instance and Instance Storage

Remember that a Contract instance itself and data in instance storage are actually technically persisted with persistent
durability. A deployed contract instance itself can actually be archived\!

Let’s review how to restore a contract instance and the associated instance storage that has been archived.

First get the contract footprint which functions as a LedgerKey for the contract instance and storage. Then be sure to
set it in the Read/Write footprint of the transaction

```javascript
    const contract = new Contract(getDeployedContractId());
const instance = contract.getFootprint();

// Set the Soroban data and create an operation to restore the contract instance
const sorobanData = new SorobanDataBuilder().setResourceFee(200_000).setReadWrite([instance]).build();
```

Then, we’ll add a restoreFootprint operation to the transaction, simulate, assemble and submit the transaction and
finally on success, we’ll extend the TTL of the contract instance.

```javascript
    let assembledTransaction =
    await getAssembledSignedTransaction(sorobanData, rpcServer,
        Operation.restoreFootprint({}));
const result =
    await rpcServer.sendTransaction(assembledTransaction);

return await pollForTransactionCompletion(rpcServer, result).then(async res => {
  if (res === "SUCCESS") {
    // Create an operation to extend the contract instance TTL
    const extendTTLSorobanData = new SorobanDataBuilder().setResourceFee(200_000).setReadOnly([instance]).build();

    await getAssembledSignedTransaction(extendTTLSorobanData, rpcServer,
        Operation.extendFootprintTtl({
          extendTo: 200,
        }));
  }
});
```

There are many more examples and more detailed in
the [attached Github repo](https://github.com/anataliocs/happy-points-system).

Check out the docs
for [further reading on contract storage](https://developers.stellar.org/docs/learn/encyclopedia/storage).

---

# Summary of What we Learned

**Smart Contract Storage Internals**

* Stellar smart contract storage entries are stored in the Host Environment as Host Objects
    * These CONTRACT\_DATA ledger entries are keyed by
        * Contract ID
        * Storage durability type
        * `ScVal` key

**Instance Storage**

* Limited-size(\~128KiB) map attached to the contract instance
* Shares TTL with contract instance
* Persistent durability
* Instance storage is retrieved EVERY time a contract is invoked
* Used for global shared data
* Slightly cheaper than persistent storage
* Extending TTL of contract data and contract instance occurs in the same operation but threshold are evaluated
  separately
* `ContractData` and `ContractCode` each have a `liveUntilLedger` field stored in its `LedgerEntry`

**Persistent Storage**

* General purpose, long-term storage
* Most expensive
* Persistent durability
* Separate TTL for each entry
* If contract instance is archived, instance must be restored before persistent storage can be accessed
* `ContractData` has a `liveUntilLedger` field stored in its `LedgerEntry`
* When `liveUntilLedger` ledger \# is reached, data is archived

**Time-to-Live and State Archival**

* Data cannot grow unbounded forever
    * Bigger memory footprint makes network more expensive/difficult/slower
    * Stellar is currently the only blockchain to have solved this with their novel state archival strategy
* Stellar ledger time is about \~5s currently
* When `liveUntilLedger` ledger \# is reached
    * Persistent and instance storage is archived
    * Temporary storage is deleted
* Two operations defined for extending TTL and restoring archived data
    * **ExtendFootprintTTLOp** \- Extends the liveUntilLedger
    * **RestoreFootprintOp** \- Restore archived entries
* Storage has an initial default TTL set by current resource limits
* Currently the minimum initial TTL is:
    * \~120 days for persistent and instance storage
    * \~1 day for temporary storage
* Can extend beyond minimum TTL by up to \~6 months set by current resource limits
* Contract instance is stored with persistent durability and has a TTL that needs to be extended
* Instance storage and your contract instance share a TTL
* Storage entry TTL can be extended:
    * In a smart contract invocation
    * With an external client call such as the Stellar Javascript SDK using a Stellar RPC server
* There is no access control for TTL extension operations
    * Any user may invoke ExtendFootprintTTLOp on any LedgerEntry

**Restoring Archived Data**

* `RestoreFootprintOp` operation restores archived data
    * Restores the archived entries specified in the `readWrite` footprint
    * The `read-only` set of the footprint must be empty
* Only persistent and instance entries can be restored
* Restored data will be granted minimum initial TTL
* Restoring a contract instance will restore the contract data
* If contract instance is archived, it must be restored before persistent data can be restored

# ---

# Future Proof

Stellar is the only blockchain currently that has addressed the problem of boundless state bloat. We have 5 billion
people online, and we create more and more data everyday. Every large organization with millions of users addresses the
cost of growing storage needs in a multitude of ways.

All modern, scalable, distributed databases implemented TTL in some form or another. For example, here
is [MongoDB’s implementation](https://www.mongodb.com/docs/manual/core/index-ttl/). All cloud platforms
offer [data archiving solutions such as AWS Glacier](https://aws.amazon.com/s3/storage-classes/glacier/).

So why isn’t any other blockchain addressing the issues of rapidly growing storage footprints. Well it’s a difficult
problem. However, with a public blockchain network, the cost of this growing burden will be felt by all the validators
and the entire community and it’s only gonna get worse.

That’s why you can rest assured that building on Stellar is future-proofing your project to be able to scale and grow
long into the future. The Stellar is purpose-built for its mission of driving forward to a more financially sustainable
and inclusive future for everyone around the world.

[image1]: <data:image/png;base64,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>