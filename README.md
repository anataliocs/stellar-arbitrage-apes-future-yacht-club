# Arbitrage Apes Open Zeppelin Soroban Smart Contract

- [Click here to create your contract](https://wizard.openzeppelin.com/stellar#)
- Open Zeppelin Repos:  https://github.com/OpenZeppelin/stellar-contracts
- Review the Audit Reports here:  https://github.com/OpenZeppelin/stellar-contracts/tree/main/audits

Fully Audited Open Zeppelin NFT Contracts now on ✨ [Stellar Network](https://developers.stellar.org/)
with [smart wallets](https://developers.stellar.org/docs/build/apps/smart-wallets)
powered by Stellar Dev Tools
like the **Stellar CLI**, the **Stellar Javascript SDK**, **Passkey Kit** and **Launchtube**.

Audited smart contracts add another layer of security and safety to the Soroban ecosystem which is already built 
from the ground up with a security mindset.

Built with the new Open Zeppelin Wizard ✅

## ✨ Stellar Smart Contract Arbitrage Apes Demo

Open Zeppelin based NFT `NonFungibleBurnable` for token gating access to APIs including OZ Monitor.

```json
{
  "base_uri": "www.arbitrage-apes.xyz",
  "name": "Arbitrage Ape Yacht Club",
  "symbol": "AAYC"
}

```
**Path:** `contracts/arbitrage-apes`


**Next Step:**  Choose Devcontainers or Local Setup

----

## How to start with Devcontainers
 
Read the [Github Docs](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/setting-up-your-repository/facilitating-quick-creation-and-resumption-of-codespaces)

- Option 1: Create [Github Codespace from the Github UI](https://docs.github.com/en/codespaces/developing-in-a-codespace/creating-a-codespace-for-a-repository#creating-a-codespace-for-a-repository)
- Option 2: Use a template string:  `https://codespaces.new/OWNER/REPO-NAME`
  - Replace `OWNER` with your Github name
  - Replace `REPO-NAME` with whatever you named this repo

**Create an Open in Github Codespaces Badge:**
- Option 3: Replace the fields as indicated
```markdown
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/OWNER/REPO-NAME)
```

----

## Local Environment Setup

[Local environment setup](https://developers.stellar.org/docs/build/smart-contracts/getting-started)
For support, visit our [Discord](https://discord.gg/stellardev)

**Ensure you are in your project root directory**
```bash
echo $PWD
```
Confirm your project root:
`/Users/LOCAL_USER/workspace/stellar-arbitrage-apes-YOUR-PROJECT`
`cd` to project root if not

Verify your workspace is configured correctly:
```bash
stellar --version && rustc --version && cargo version && nvm current
```
[Node/npm setup](https://code.visualstudio.com/docs/nodejs/nodejs-tutorial)

**Your project lifecycle will consist of setup, build and deploy and UI setup steps:**
1. Setup Stellar accounts and env
2. Build Contract
3. Deploy contract and setup env
4. Configure contract bindings for UI

**During active development**
Upgrading your deployed contract

**Next Step:** Setup Stellar accounts and Env

---

## STEP 1: Setup Identity and Env

- Set CLI to use testnet by default
- Generate and fund Testnet key
- Set default source account for future CLI Commands
- Store in `.env` as `ARBITRAGE_APES_OWNER`
- Set standard contract name in `.env` to be used as a CLI alias and package for contract bindings
- Set your project root

**Setup Styles**
1. `auto` config for a scripted setup
2. `manual` print out commands to execute

**Setup aliases for step 1 scripts**
- These will not persist through terminal sessions. 
```bash
alias step1_auto="./init/step1_auto.sh" && alias step1_print="./init/step1_manual.sh" && \
alias step1_verify="./init/step1_verify.sh"

```

**Auto-configuration:**
- Care was taken to make scripts portable
- Windows users will need WSL and bash
```bash
step1_auto
```

**Manual-configuration: Print out the commands to execute on your own:**
```bash
step1_print
```

**Verify your Stellar Dev Env is setup correctly:**
```bash
step1_verify
```

**Next Step:** Build Contract

----

## STEP 2: Build contract

- Update your contract
- Build contract with a standard location:  `target/wasm32v1-none/release/arbitrage_apes.wasm`
- Use release profile
- Set the ARBITRAGE_APES_WASM to the wasm path in the .env
- Set the ARBITRAGE_APES_WASM_HASH .env

**Setup aliases for step 2 scripts**
- These will not persist through terminal sessions.
```bash
alias step2_auto="./init/step2_auto.sh" && alias step2_print="./init/step2_manual.sh" && \
alias step2_verify="./init/step2_verify.sh"
```

>NOTE: cdylibs are cross-platform and create: *.so files on Linux, *.dylib files on macOS, and *.dll files on Windows.

>NOTE:  Open Zeppelin contracts use Rust 1.84 and --target=wasm32v1-none

**Auto-configuration:**
- Care was taken to make scripts portable
- Windows users will need WSL and bash
```bash
step2_auto
```

**Manual-configuration: Print out the commands to execute on your own:**
```bash
step2_print
```

**Verify your Stellar Dev Env is setup correctly:**
```bash
step2_verify
```

**Verify:**
- Check for CLI warnings
- Not the path of the generated wasm File
- Ensure all 18 functions are exported

**Next Step:** Deploy Contract

----

## STEP 3: Deploy Contract and Update Env

- Use ARBITRAGE_APES_WASM and SOURCE_ACCOUNT_CLI_NAME and ARBITRAGE_APES_CONTRACT_NAME from .env
- Use Stellar CLI to deploy contract using .env vars
- Sets contract alias to ARBITRAGE_APES_CONTRACT_NAME from .env
- Sets Deployed contract address to DEPLOYED_ARBITRAGE_APES_CONTRACT
- Sets NFT metadata in your contract

```bash
alias step3_auto="./init/step3_auto.sh" && alias step3_print="./init/step3_manual.sh" && \
alias step3_verify="./init/step3_verify.sh"
```

The following metadata will be set in your contract:
```json
{
  "base_uri": "www.stellar-arbitrage-apes.xyz",
  "name": "Stellar Arbitrage Ape Yacht Club",
  "symbol": "SAAYC"
}
```

**Auto-configuration:**
```bash
step3_auto
```

**Manual: Print out the commands to execute on your own:**
```bash
step3_print
```

**Verify your Contract is deployed correctly:**
```bash
step3_verify
```
> - TODO add stellar contract info to verify step

----

## STEP 4: Generate Contracts Bindings
- Use the DEPLOYED_ARBITRAGE_APES_CONTRACT and ARBITRAGE_APES_CONTRACT_NAME from .env
- Use Stellar CLI to generate contract bindings using .env vars
- Sets the output package to ARBITRAGE_APES_CONTRACT_NAME
- Sets Deployed contract address to DEPLOYED_ARBITRAGE_APES_CONTRACT
- Sets your launch-tube token in your .env as `ARBITRAGE_APES_LAUNCHTUBE_TOKEN`

```bash
alias step4_auto="./init/step4_auto.sh" && alias step4_print="./init/step4_manual.sh" && \
alias step4_verify="./init/step4_verify.sh"
```

**Auto-configuration:**
```bash
step4_auto
```

**Manual: Print out the commands to execute on your own:**
```bash
step4_print
```

**Verify your Contract bindings are generated and linked correctly:**
```bash
step4_verify
```

**Review**
- Your .env file with everything you need to build a dapp around your Open Zeppelin NFT Contract
- Built and deployed your contract and stored the results in `contract-address.log` and `contract-build.log`
- Deployed your contract bindings and use `npm link` which add the package `node_modules`

----

## Invoking your Deployed Contract
Now let's use the Stellar CLI to invoke your deployed contract.

### A Reward for your Hard Work: Mint your first Soroban NFT!
- The id of the deployed contract, our default source account and the public key are stored in our `.env` file
- We call the `stellar contract invoke` Stellar CLI function here with our `.env` file
- Which will invoke the `mint()` function passing in the Owner public key as the recipient
- We are passing in the token_id which we will update to be dynamically generated later on

**Execute this command:**
```bash
source .env && stellar contract invoke \
    --id $DEPLOYED_ARBITRAGE_APES_CONTRACT \
    --source $SOURCE_ACCOUNT_CLI_NAME \
    -- \
    mint \
    --to $ARBITRAGE_APES_OWNER \
	--token_id 132
```

#### Emitted Events
- The contract contains logic to emit events when important things like `mint()` function invocations occur
- Events can be used by your dapp, by indexers, by [Open Zeppelin Monitor](https://github.com/OpenZeppelin/openzeppelin-monitor)
- Events provide a summary of important data from a `mint()` function invocation for instance
- Check out the [Stellar CLI manual for more info](https://developers.stellar.org/docs/tools/cli/stellar-cli#stellar-events)
```bash
source .env && stellar events --id $DEPLOYED_ARBITRAGE_APES_CONTRACT \
--start-ledger 1206843 --output json 
```
> - TODO Capture the first minted transaction ledger to store in .env as START_LEDGER
> - TODO Store emitted events in JSON format for use in test mocking and cache pre-warm

**Default Output type(pretty):**
```
Event 0005183355511390208-0000000001 [CONTRACT]:
  Ledger:   1206844 (closed at 2025-05-28T15:12:48Z)
  Contract: CANPLB5YZIPWR764C6TUYYHF5RJPIG232O3YLKCE5KV5OBWKRGGTCAGI
  Topics:
            Symbol(ScSymbol(StringM(mint)))
            Address(Account(AccountId(PublicKeyTypeEd25519(Uint256(bc11fc3834b4c0c82ab9df57e951a5bc4546f62432e2a8dd9615c01e59de0adc)))))
  Value: U32(132)
```

**Output type(json):**
```json
{
  "type": "contract",
  "ledger": 1206844,
  "ledgerClosedAt": "2025-05-28T15:12:48Z",
  "id": "0005183355511390208-0000000001",
  "pagingToken": "0005183355511390208-0000000001",
  "contractId": "CANPLB5YZIPWR764C6TUYYHF5RJPIG232O3YLKCE5KV5OBWKRGGTCAGI",
  "topic": [
    "AAAADwAAAARtaW50",
    "AAAAEgAAAAAAAAAAvBH8ODS0wMgqud9X6VGlvEVG9iQy4qjdlhXAHlneCtw="
  ],
  "value": "AAAAAwAAAIQ="
}
```
> **TODO:**
> - TODO Provide utility helper using Stellar CLI for decoding XDR in event
> - Show how to view/decode events on Stellar lab

Later in the tutorial, we will walk through how to display events in your UI.

----

### What is an NFT?
- It's an unique digital assets with verifiable ownership
- It can represent much more then just an image as we commonly see
- In this demo, we are using the [Open Zeppelin NFT implementation](https://docs.openzeppelin.com/stellar-contracts/0.2.0/tokens/non-fungible)
- NFTs can represent many different things:
  - **Digital Access:** Access to a API, private site or forum or a set of data
  - **Physical Access:** Access to an event functioning as a unique, verifiable digital ticket
  - **Digital Status:** Digital identity as a member of a rewards program
  - **Physical Status:** Access to physical rewards like swag
  - **Digital Ownership:** Which could grant you access to a movie, game or song
  - **Physical Ownership:** Acting as a "receipt" to receive a consumer good
  - **Digital Credential:** Verifiable certificate that you successfully completed a course
  - **Physical Credential:** Grants you access to receive a physical representation of a credential

**The Real Potential of NFTs**
- Combining these various traits unlocks new features and functionality for users
- **Example:**
  - Completing a course grants you a credential but also grants you access to a developer rewards program
  - Which grants you access to in-person swag and event
  - Which can earn you digital points which then can upgrade your membership level
  - Which grants you access to special training materials online
  - And also grants you to a special Discord channel
  - And grants you access to blockchain infrastructure like Relayers, Oracles, dedicated RPC servers, indexers etc.
  - Identifies your account on-chain for special invites like sending you a NFT ticket to an event directly
  - And can be linked to other digital identities like your Github, Discord, email, Twitter etc.
  - Or even linked to other on-chain NFTs or even a contract or UI deployment for instance
  - The possibilities are endless!

**Concrete Example: Open Source Software Funding**
- Your NFT linked to your entire developer identity and history is linked to a specific github repo
- This repo is an OSS package that provides a lot of value to the community
- Other developers can buy you a coffee as a thank-you by sending a transaction to your linked account

**Next Steps:** 
- Modify your NFT Contract code and Upgrade the Contract 
- Bootstrap your UI

----

## NFT dapp Backend

We will now create a backend to provide data for your UI.

```
cd backend/arbitrage-apes-backend

```

Backend:
- Using SSE
- Moves complex code from front-end to backend
- Push HTML code to front-end

Front-end -> Single index.html file
```html
<script type="text/javascript">
    const eventSource = new EventSource('/sse');
    eventSource.onmessage = ({ data }) => {
      const message = document.createElement('li');
      message.innerText = 'New message: ' + data;
      document.body.appendChild(message);
    }
</script>
```

Backend
```
  @Sse('sse')
  sse(): Observable<MessageEvent> {
    return interval(1000).pipe(
      map((_) => ({ data: { hello: 'world' } }) as MessageEvent),
    );
  }
```

You may have CORS issues on localhost.

You can try opening Chrome in a sandbox with web security disabled:
```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome http://localhost:63342/stellar-arbitrage-apes-future-yacht-club/index.html?_ijt=q9fn6vaje10r5bcfgmcmafoo6p&_ij_reload=RELOAD_ON_SAVE --args --disable-web-security --user-data-dir="~/.chrome.dev.session/" --incognito --new-window
```


----

## Customizing your NFT contract

### Workflow

Let's update the metadata on the contract to make it truly yours.
1. Update the contract
2. Re-build the contract
3. Upgrade the deployed contract
4. Re-generate contract bindings

#### Updating the Contract

Open up the contract `contracts/arbitrage-apes/src/contract.rs`
Modify

**Execute this command:**
```bash
source .env && stellar contract invoke \
    --id $DEPLOYED_ARBITRAGE_APES_CONTRACT \
    --source $SOURCE_ACCOUNT_CLI_NAME \
    -- \
    mint \
    --to $ARBITRAGE_APES_OWNER \
	--token_id 132
```

## Opinionated Front-end Client Creation

The method of UI creation I'm using in this case is a template that is actively maintained, 500+ deployments, and full 
test suite to ensure that static analysis is followed and test generation is successful and 218 github stars
- https://nextjs-boilerplate-hadrysm.vercel.app/
- https://github.com/hadrysm/nextjs-boilerplate

If you preferred another UI framework, go ahead and build with whatever you prefer!

Generate basic UI skeleton


----


### Storing Data

How data is stored is an important consideration!

**Storage Key Definition:**

Unique key with which to store or retrieve data.

```rust

```

- [Enums in Rust](https://doc.rust-lang.org/book/ch06-01-defining-an-enum.html) define an enumeration, a limited set
  of possible values
- This `enum` defines a single possible variant of `Storage` keys of the type `Chat`
- This custom data type acts as a key to look up a stored value
- The `Chat` type is associated with a `u32`(unsigned 32-bit int)

All together, this gives us a unique, named-spaced custom data type to function as a key
to store and retrieve `ChatMessage` values from storage.

Using the Data Key in the format `Namespace::Variant(Associated value)`:

```rust

```

**Storage Value Type Definition:**

Defines the interface for storing data.

```rust

```

- [Structs in Rust](https://doc.rust-lang.org/book/ch05-01-defining-structs.html) define a type with multiple named
  associated values called **fields**
- The name of the struct, `ChatMessage` is a type that describes the purpose of the data grouping
- Each field is defined in the format `name: Type`
- This struct functions as an interface of key:value pairs that define an atomic piece of data to be stored
- Field definitions:
	- An `Address` type representing the author of the `ChatMessage`
	- A `soroban_sdk::string` type representing the message contents
	- A `u64` type representing the timestamp when the `ChatMessage` was sent

> **⚠️ Warning**
>
> A common mistake is importing the `alloc::string::String` type which will cause
> you all sorts of issues!
>
> Make sure you import the `soroban_sdk::{String}` type!

**Instanciate a `ChatMessage` instance to store:**

```rust

```

#### Storing Soroban Data using the `Env` Interface

How to store data on-chain:

```rust

```

**Storing data on-chain**

- Your function definition will need to include a reference to the `Env` type
- The [soroban_sdk::env](https://docs.rs/soroban-sdk/latest/soroban_sdk/struct.Env.html) type provides ways to interact
  with the execution enviroment
	- **TL;DR;** Contracts talk to the Stellar network via the environment interface
- The `env.storage.temporary().set` function allows for storing data on-chain with a limited lifespan
	- Data that needs to
	  be [stored permanantly](https://developers.stellar.org/docs/learn/encyclopedia/storage/persisting-data) should go
	  into `persistent()` durability
	- Check out the docs for help on choosing
	  the [right storage durability](https://developers.stellar.org/docs/learn/encyclopedia/storage/persisting-data#best-practices)
- The diamond notation `::<Storage, ChatMessage>` is an
  optional [generic](https://doc.rust-lang.org/book/ch10-01-syntax.html) for type-safety
	- Indicates the storage key will be of the type `Storage` and the stored value will be of the type `ChatMessage`
- The statement `&Storage::Chat(next_index)` defines a key to store and retrieve on-chain data
- The statement `&ChatMessage { author, message, timestamp: env.ledger().timestamp() }` defines the data to be stored

### `send()` Function Auth

**Auth**

Review line 24 in the contract, `contracts/snapchain/src/lib.rs`

**soroban_sdk::address::require_auth**

The `require_auth` statement controls access to who can invoke this function.

```rust

```

- Ensures the `Address` has authorized the current invocation(including all the invocation arguments)
- Provided by the Soroban Rust SDK
- Sensible built-in security

## Invoking your Smart Contract

Invoke your deployed contract `send()` function:

```bash
stellar contract invoke \
    --id CBUMOJAEAPLQUCWVIM6HJH5XKXW5OP7CRVOOYMJYSTZ6GFDNA72O2QW6 \
    --source alice2 \
    -- \
    send \
    --author GDCJMCMYNDZ2FV6UMSEYRMUSCX53KCG2AWPBFQ24EA2FFYBCEDMFCBCV \
    --message new-mesg-test2
```

---

## Using a Rpc Server to Look up `ChatMessage` Key Data

**Path:**  `src/stellar.ts`

`stellar.ts` provides an interface for calling a Stellar RPC server.
We will use it to manage contract storage key data.
It uses the [Stellar Javascript SDK](https://stellar.github.io/js-stellar-sdk/)

### Contract Data Storage Keys

Getting storage key index data and building objects to represent `ChatMessage` keys.

**Get Next Index**

Let's get the index sequentially, where we would store a new `ChatMessage`.

This essentially functions as the length of the array of messages.

**Example(index -> message):**

* `0` -> `ChatMessage` 1
* `1` -> `ChatMessage` 2
* `2` -> `NextIndex`

Getting next index:

`src/stellar.ts`

```typescript
async function getNextIndex(): Promise<number> {
    // Define the deployed contract on testnet
	const snapchainContract = new Contract(networks.testnet.contractId)
	// Retrieve on-chain data owned by the contract
	const { entries } = await rpc.getLedgerEntries(snapchainContract.getFootprint())
	// Find the storage entry representing the current index + 1
	// i.e. Find the index that a new ChatMessage sequentially should be stored under
	const nextIndex = entries[0].val
	.contractData().val().instance().storage()
		?.find((e) => scValToNative(e.key()) === 'INDEX');
    // If there are no current ChatMessages, return 0
	return nextIndex ? scValToNative(nextIndex.val()) : 0;
}
```

**Chat Ledger Key Array**

Create an array of storage keys(`Storage::Chat(u32)`) used to look up ChatMessage storage entries.

`src/stellar.ts`

```typescript
function createChatLedgerKeys(latestIndex: number): xdr.LedgerKey[] {
    // Create an array of LedgerKey entries to look up all ChatMessages
    return Array.from({ length: latestIndex}, (_, i) => latestIndex - i).map((c) =>
        // Create an XDR entry representing the key used to look up ChatMessage storage entries
	    xdr.LedgerKey.contractData(
            // Define the deployed contract, storage key, and storage type
            new xdr.LedgerKeyContractData({
                contract: new Address(networks.testnet.contractId).toScAddress(),
                key: nativeToScVal([
                    nativeToScVal('Chat', { type: 'symbol' }),
                    nativeToScVal(c, { type: 'u32' }),
                ]),
                durability: xdr.ContractDataDurability.temporary(),
            })
        )
    );
}
```

- [XDR](https://developers.stellar.org/docs/learn/encyclopedia/data-format/xdr) is a binary format used to represent
  on-chain externally like in a web app
- [LedgerKeyContractData](https://developers.stellar.org/docs/data/apis/rpc/api-reference/methods/getLedgerEntries) XDR
  objects are used to look up data on-chain that belongs to a contract
- A ledger key for contract data consists of 3 parts
	- The deployed contract ID
	- The storage key consisting of
		- The custom data type name. e.g. `Chat`
		- The associated value. e.g. `u32`
	- Durability:  Either temporary, persistent or instance

---

## Fetch and Display `ChatMessage` Content

`src/stellar.ts` was used to build an array of lookup keys. Now let's get the ChatMessage content
and display it in the UI.

**Path:**  `src/chitChat.ts`

`chitChat.ts` gets chat message data and displays it

### Fetch ChatMessage Contract Data

Fetch chat message data for display in the UI.

```typescript
    async function fetchMessages() {

	// Get array of ledger keys used to lookup ChatMessages
    let possibleChats = createChatLedgerKeys(this.nextIndex - 1);
    let entries: Api.LedgerEntryResult[] = []

	// RPC limits 200 keys in a single request
    if (possibleChats.length <= 200) {
        // Pass in the Array of LedgerKeys retrieving chat messages
        entries = (await rpc.getLedgerEntries(...possibleChats)).entries
    } else {
        // Paginate in chunks of 200 chat messages
        while (possibleChats.length) {
            let tempChats = possibleChats.slice(0, 200);
            possibleChats = possibleChats.slice(200)
            entries = entries.concat(entries, (await rpc.getLedgerEntries(...tempChats)).entries)
        }
    }

    // Store retreived chat messages in Record<number, ChatMessage> array for display in UI
    this.messages = {}
    entries.forEach((e) => {
        const chatIndex = scValToNative(e.key.contractData().key())[1]
        const chatMessage: ChatMessage = scValToNative(e.val.contractData().val())
        this.messages[chatIndex] = chatMessage
    })
}
```

- Lookup `ChatMessage` entries using the `getLedgerEntries` rpc call
- Paginate entries in chunks of 200
- Transform rpc server response objects into `ChatMessage` objects for display in UI

---

## Front-end Display of ChatMessages

Review the following file:
`src/chitChat.ts`

Generate HTML markup code to display formatted chat message data:

```typescript
function renderMessage({author, message, timestamp}: ChatMessage): string {
    return `
        <article class="chat-card">
            <header><nav>
                <small>${truncate(author)}</small>
                <small>${new Date(Number(timestamp) * 1_000).toLocaleString()}</small>
            </nav></header>
            <p>${message}</p>
        </article>
    `
}
```

Insert rendered markup for each chat message into the placeholder element:

```typescript
    renderMessages() {
        let placeholder = ''
        Object.entries(this.messages)
            .forEach(([_, chatMessage]) => {
                placeholder += renderMessage(chatMessage)
            })
        this.element.innerHTML = placeholder
    }
```

---

For more details on how Passkeys and Launchtube work check out the example
repo: https://github.com/kalepail/smart-stellar-demo

## 👀 Want to learn more?

Feel free to check [our documentation](https://developers.stellar.org/) or jump into
our [Discord server](https://discord.gg/stellardev).

---
