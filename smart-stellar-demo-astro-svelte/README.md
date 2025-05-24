# Stellar Network Demo: Passkey-powered Onchain Chat

Get started building on the [Stellar Network](https://developers.stellar.org/)
with [smart wallets](https://developers.stellar.org/docs/build/apps/smart-wallets) powered by Stellar dev tools
like the **Stellar CLI**, the **Stellar Javascript SDK**, **Passkey Kit** and **Launchtube**.

With **Astro** and **Svelte** on the front-end.

**📚 Highlighted Tools**

- [Stellar CLI](https://developers.stellar.org/docs/tools/cli/install-cli)
	- [Generating Bindings](https://developers.stellar.org/docs/tools/cli/stellar-cli#stellar-contract-bindings)
- [Stellar Javascript SDK](https://developers.stellar.org/docs/tools/sdks/client-sdks#javascript-sdk)
	- [Stellar RPC Server](https://stellar.github.io/js-stellar-sdk/module-rpc.Server.html)
- [Passkey Kit](https://github.com/kalepail/passkey-kit)
- [Launchtube](https://github.com/stellar/launchtube)
- [Zettablock Indexer](https://docs.zettablock.com/reference/custom-api-call)

**✨ Features**

- **Passkey Kit** for seamless biometric authentication
- **Launchtube** for transaction lifecycle management and paymaster functionality
- **Zettablock** for indexing event data
- [TypeScript bindings](https://developers.stellar.org/docs/tools/cli/stellar-cli#stellar-contract-bindings-typescript) generated with the Stellar CLI

### Passkey Kit: Simplifying UX in Web3

[Passkey Kit GitHub Repository](https://github.com/kalepail/passkey-kit)

Self-custody can be complicated for users.

**Passkey Kit** streamlines user experience (UX) in Web3 by leveraging biometric authentication for signing and
fine-grained authorization of Stellar transactions
with [Policy Signers](https://github.com/kalepail/passkey-kit/tree/next/contracts/sample-policy).

Implementing [WebAuthn](https://webauthn.io/) standards, Passkey Kit removes the complexity of Web3 on-boarding.

1. **Passwordless Login**: Streamlined onboarding. No more magic link emails, OTPs, or registration forms
2. **Biometric Signing**: Users can use their device's biometric authentication or password managers
3. **Fine-Grained Authorization**: Configured fine-grained transaction signing credentials with modular access
4. **Seamless UX**: Provide familiar login flow

### Launchtube: Managing the Transaction Lifecycle

[Launchtube GitHub Repository](https://github.com/stellar/launchtube)

Launchtube is a super cool service that abstracts away the complexity of submitting transactions.

**Smart Contract Development is Complex:**

- Determining the footprint of an operation
- [Storage durability](https://developers.stellar.org/docs/build/guides/storage/choosing-the-right-storage)
- [TTLs](https://developers.stellar.org/docs/learn/encyclopedia/storage/state-archival#ttl)
- Managing [XDR binary data](https://developers.stellar.org/docs/learn/encyclopedia/data-format/xdr)
- Considering [resource fees](https://developers.stellar.org/docs/networks/resource-limits-fees)
- Transaction building, simulation, assembly and validation

_Let Launchtube handle getting your operations onchain!_

1. **Transaction Lifecycle Management**:
	- Transaction Submission
	- Retries
	- Working around rate limits

2. **Paymaster Service**:
	- Subsidizes transaction fees

## Stellar Smart Contract Chat Demo

Secure, passkey-powered, chat message broadcasting.

Message content is persisted in emitted Soroban events upon invocation of the `send()` function.
Path: `contracts/chat-demo`

### Build and Deploy your Smart Contract

Getting your local environment setup is the first step.

Check out [Getting Started guide here](https://developers.stellar.org/docs/build/smart-contracts/getting-started).

Visit our [Discord server](https://discord.gg/stellardev) for more support.

### Deploy and Invoke Contract

Building the contract with the Stellar CLI:

```bash
stellar contract build
```

Deploy contract:

```bash
stellar contract deploy \
    --wasm target/wasm32-unknown-unknown/release/chat_demo.wasm \
    --source alice \
    --network testnet
```

**Get your Contract ID:**

```bash
🔗 https://stellar.expert/explorer/testnet/contract/CBK6E4G3DCE3OR44ZYMKV36O35LMUIGH7LRV4GIUUMA5UDNWS57MAJN3
✅ Deployed!
CBK6E4G3DCE3OR44ZYMKV36O35LMUIGH7LRV4GIUUMA5UDNWS57MAJN3
```

## The `send()` Function:

Review line 10 in the contract, `contracts/chat-demo/src/lib.rs`:

**soroban_sdk::address::require_auth**

```rust
addr.require_auth();
```

- Ensures the `Address` has authorized the current invocation(including all the invocation arguments)
- Provided by the Soroban Rust SDK(Specifically
  the [Soroban Env Common crate](https://docs.rs/crate/soroban-env-common/latest))
- Sensible built-in security

Auth on Stellar is powerful and gives you sensible security by default.

## Invoking your Smart Contract

Invoke your deployed contract `send()` function:

```bash
stellar contract invoke \
    --id CBUMOJAEAPLQUCWVIM6HJH5XKXW5OP7CRVOOYMJYSTZ6GFDNA72O2QW6 \
    --source alice2 \
    -- \
    send \
    --addr GDCJMCMYNDZ2FV6UMSEYRMUSCX53KCG2AWPBFQ24EA2FFYBCEDMFCBCV \
    --msg new-mesg-test2
```

**Example Diagnostic Event:**
When the `send()` function is invoked, it emits an event onto the Stellar network:

```rust
env.events().publish((addr.clone(), ), msg.clone());
```

The Stellar CLI picks this up for you and displays it.
_ℹ️ Why does it look like a cat walked across my Keyboard after hitting the CAPS LOCK key?_

```terminaloutput
contract_event: soroban_cli::log::event: 1: 
AAAAAQAAAAAAAAABaMckBAPXCgrVQzx0n7dV7dc/4o1c7DE4lPPjFG0H9O0AAAABAAAAAAAAAAEAAAASAAAAAAAAAADElgmYaPOi19RkiYiykhX7tQjaBZ4Sw1wgNFLgIiDYUQAAAA4AAAAQdGVzdC1tc2ctdG8tc2VuZA== 
```

This is [XDR](https://developers.stellar.org/docs/data/apis/horizon/api-reference/structure/xdr) a binary data format.

**Help Decoding XDR:**

- [Stellar Lab](https://lab.stellar.org/xdr/view?$=network$id=testnet&label=Testnet&horizonUrl=https:////horizon-testnet.stellar.org&rpcUrl=https:////testnet.rpciege.com//&passphrase=Test%20SDF%20Network%20/;%20September%202015;)
- [Stellar CLI](https://developers.stellar.org/docs/tools/cli/stellar-cli#stellar-xdr-decode)
- [rs-stellar-xdr](https://github.com/stellar/rs-stellar-xdr)

**XDR Decoded into JSON format:**

```json
{
  "in_successful_contract_call": true,
  "event": {
	"ext": "v0",
	"contract_id": "68c7240403d70a0ad5433c749fb755edd73fe28d5cec313894f3e3146d07f4ed",
	"type_": "contract",
	"body": {
	  "v0": {
		"topics": [
		  {
			"address": "GDCJMCMYNDZ2FV6UMSEYRMUSCX53KCG2AWPBFQ24EA2FFYBCEDMFCBCV"
		  }
		],
		"data": {
		  "string": "test-msg-to-send"
		}
	  }
	}
  }
}
```

## Polling for Events

**Make a Remote Procedure Call(RPC) with:**

- [Stellar CLI](https://github.com/stellar/stellar-cli)
- HTTP request (Axios or cURL)
- The [Javascript SDK](https://stellar.github.io/js-stellar-sdk/)
- Using [Stellar Lab](https://lab.stellar.org/)

**Poll for events using a `cursor` parameter:**

```bash
stellar events \
	--network testnet \
    --cursor 0002533961985163263-4294967295 \
    --id CBUMOJAEAPLQUCWVIM6HJH5XKXW5OP7CRVOOYMJYSTZ6GFDNA72O2QW6 \
    --output pretty
```

**Using a `start-ledger` parameter:**

```bash
stellar events \
	--network testnet \
    --start-ledger 589386 \
    --id CBUMOJAEAPLQUCWVIM6HJH5XKXW5OP7CRVOOYMJYSTZ6GFDNA72O2QW6 \
    --output pretty
```

**HTTP `cURL` making a `getEvents` RPC call on testnet:**

```bash
curl 'https://testnet.rpciege.com/' \
  -H 'accept: */*' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'content-type: application/json' \
-H 'origin: https://lab.stellar.org' \
--data-raw '{"jsonrpc":"2.0","id":8675309,"method":"getEvents","params":{"xdrFormat":"base64","startLedger":589386,"pagination":{"limit":10},"filters":[{"type":"contract","contractIds":["CBUMOJAEAPLQUCWVIM6HJH5XKXW5OP7CRVOOYMJYSTZ6GFDNA72O2QW6"],"topics":[]}]}}'
```

**Using Stellar Lab**
[Stellar lab getEvents request](https://lab.stellar.org/endpoints/rpc/get-events?$=network$id=testnet&label=Testnet&horizonUrl=https:////horizon-testnet.stellar.org&rpcUrl=https:////testnet.rpciege.com//&passphrase=Test%20SDF%20Network%20/;%20September%202015;&endpoints$params$startLedger=589386&limit=10&filters=%7B%22type%22:%22contract%22,%22contract_ids%22:%5B%22CBUMOJAEAPLQUCWVIM6HJH5XKXW5OP7CRVOOYMJYSTZ6GFDNA72O2QW6%22%5D,%22topics%22:%5B%22%22%5D%7D)

### `getEvents` RPC Response

JSON response
for [Get Events RPC Call](https://developers.stellar.org/docs/data/apis/rpc/api-reference/methods/getEvents):

```json
{
  "jsonrpc": "2.0",
  "id": 8675309,
  "result": {
	"events": [
	  {
		"type": "contract",
		"ledger": 589387,
		"ledgerClosedAt": "2025-04-22T20:52:41Z",
		"contractId": "CBUMOJAEAPLQUCWVIM6HJH5XKXW5OP7CRVOOYMJYSTZ6GFDNA72O2QW6",
		"id": "0002531397889695744-0000000001",
		"pagingToken": "0002531397889695744-0000000001",
		"inSuccessfulContractCall": true,
		"txHash": "86ad86ba26466e50b764cb7c0dab1082a5e1eec4e1cc82ae2bade7fbeb5d143f",
		"topic": [
		  "AAAAEgAAAAAAAAAAxJYJmGjzotfUZImIspIV+7UI2gWeEsNcIDRS4CIg2FE="
		],
		"value": "AAAADgAAABB0ZXN0LW1zZy10by1zZW5k"
	  }
	],
	"latestLedger": 589890,
	"cursor": "0002533562553204735-4294967295"
  }
}
```

**Topic Field: `ScVal` representing the Address:**
Path:  `result.events.topic`

```terminaloutput
AAAAEgAAAAAAAAAAxJYJmGjzotfUZImIspIV+7UI2gWeEsNcIDRS4CIg2FE=
```

**Decoded Event Topic: `ScVal` JSON representing an Address:**

```json
{
  "address": "GDCJMCMYNDZ2FV6UMSEYRMUSCX53KCG2AWPBFQ24EA2FFYBCEDMFCBCV"
}
```

**XDR Value Field: `ScVal` representing the message payload:**
Path:  `result.events.value`

```terminaloutput
AAAADgAAABB0ZXN0LW1zZy10by1zZW5k
```

**Decoded JSON:**

```json
{
  "string": "test-msg-to-send"
}
```

## RpcServer

Path:  `src/utils/rpc.ts`

`rpc.ts` provides an interface for calling a Stellar RPC server.
We will use it to retrieve and process emitted contract events.
It uses the [Stellar Javascript SDK](https://stellar.github.io/js-stellar-sdk/)

**Contract Event Retrieval**:

- Fetches contract events
- Filters events by contract ID, topic and validates data integrity
- Converts `Api.GetEventsResponse`s into structured `ChatEvent` objects for the front-end

**Fetch Contract Events:**

- Instantiate RPC Server
- Call Get Events RPC call

```typescript
export const rpc = new Server(import.meta.env.PUBLIC_RPC_URL, import.meta.env.PUBLIC_NETWORK_PASSPHRASE);
await rpc.getEvents()
```

**Filter Events by Contract ID:**

- Pass in contract filter
- Import deployed contract ID from env
- Set `startLedger` or `cursor` and `limit`

```typescript
await rpc.getEvents({
    filters: [
        {
            type: "contract",
            contractIds: [import.meta.env.PUBLIC_CHAT_CONTRACT_ID],
        },
    ],
    startLedger: typeof limit === "number" ? limit : undefined,
    limit: 10_000,
    cursor: typeof limit === "string" ? limit : undefined,
})
```

**Convert from GetEvent API Response to Chat Event Object:**

- Validate event type
- Get `Address` from first entry in event topic array
- Output as publicKey type `Ed25519` for `scAddressTypeAccount` type
- Or contractId for `scAddressTypeContract` type

```typescript
events.forEach((event) => {
    if (event.type !== "contract" || !event.contractId) return;

    if (msgs.findIndex(({id}) => id === event.id) === -1) {
        let addr: string | undefined;
        let topic0 = event.topic[0].address();

        switch (topic0.switch().name) {
            case "scAddressTypeAccount": {
                addr = Address.account(
                    topic0.accountId().ed25519(),
                ).toString();
                break;
            }
            case "scAddressTypeContract": {
                addr = Address.contract(
                    topic0.contractId(),
                ).toString();
                break;
            }
        }
    }
});
```

**Create ChatEvent from Event data**

- `ChatEvent` interface defined in `src/env.d.ts`
- Set fields in `ChatEvent`:
	- id as `string`
	- addr as `string`
	- timestamp as `Date`
	- txHash as `string`
	- msg as `string`

```typescript
msgs.push({
    id: event.id,
    addr,
    timestamp: new Date(event.ledgerClosedAt),
    txHash: event.txHash,
    msg: scValToNative(event.value),
});
```

### Configuration Options

| Parameter     | Type     | Description                                       | 
|---------------|----------|---------------------------------------------------|
| `contractId`  | `string` | The Stellar contract ID to filter events          | 
| `startLedger` | `number` | The ledger number to start retrieving events from |    

- `_limit`: Maximum number of events to retrieve per request (default: 1,000)
- Environment variables from `.env`:
	- `PUBLIC_RPC_URL`: The URL of the Stellar RPC server
	- `PUBLIC_NETWORK_PASSPHRASE`: The network passphrase for the target Stellar network
	- `PUBLIC_CHAT_CONTRACT_ID`: The default contract ID to filter events

## Front-End UI Code

Let's walk through how `ChatEvent`s are displayed in the UI.

### 🛠 PNPM Commands

Run from the root directory of the project:

| Command                    | Action                                       |
|:---------------------------|:---------------------------------------------|
| `pnpm install`             | Installs dependencies                        |
| `pnpm run dev`             | Starts local dev server at `localhost:4321`  |
| `pnpm run build`           | Build your production site to `./dist/`      |
| `pnpm run preview`         | Preview your build locally, before deploying |
| `pnpm run astro ...`       | Run Astro CLI commands like `astro add`      |
| `pnpm run astro -- --help` | Get help using the Astro CLI                 |

Review the following file:
`src/components/Welcome.svelte`

This component prints out the chat messages from emitted events:

- Import `getEvents` and `rpc` from `utils/rpc.ts`
- Call `getEvents()` and set ChatEvent in array `msgs: ChatEvent[]`
- Sort by Timestamp

```typescript
async function callGetEvents(
    limit: number | string,
    found: boolean = false,
) {
    msgs = await getEvents(msgs, limit, found);
    msgs = msgs.sort(
        (a, b) => a.timestamp.getTime() - b.timestamp.getTime(),
    );
}
```

**Updating the UI**

Updating the UI in responses to changes in the state.

**Loop through msgs array and display `ChatEvent` in UI:**

- Use `{#each}` svelte expression language to interate through `msgs[]` array
- https://svelte.dev/docs/svelte/each
- Print out `ChatEvent` fields embedded in styled HTML

```html
{#each msgs as event}
    <li class="mb-2"><span class="text-mono text-sm bg-black rounded-t-lg text-white px-3 py-1">
	    <a class="underline"
           target="_blank"
           href="https://stellar.expert/explorer/public/tx/{event.txHash}">
		    {truncate(event.addr, 4)}
	    </a>

	    <time class="text-xs text-gray-400"
              datetime={event.timestamp.toUTCString()}>
		    {event.timestamp.toLocaleTimeString()}
	    </time>
        {event.msg}
{/each}
```

### Sending messages

- Import `chat-demo` `Client` from `chat-demo-sdk` contract bindings
- `chat-demo-sdk bindings` were generated with Stellar CLI
	- Review `chat-demo-sdk/README.md` for more info
- Client configured in `chat.ts` with `rpcUrl`, `contractId` and `networkPassphrase` from `.env` params
- Invoke deployed contract `send()` function with bindings passing in `Address` and `msg` string
- Sign `AssembledTransaction` with `PasskeyKit` Signer passing in `keyId` and transaction to `sign()`
- This will then prompt your browser to request your fingerprint
- Use the Launchtube `PasskeyServer` configured with `rpcUrl`, `launchtubeUrl` and `launchtubeJwt`
- Await JSON response from Launchtube server

```typescript
async function send() {
    let at = await chat.send({
        addr: $contractId,
        msg,
    });
    at = await account.sign(at, {keyId: $keyId});

    await server.send(at);
}
```

## 👀 Want to learn more?

Feel free to check [our documentation](https://developers.stellar.org/) or jump into
our [Discord server](https://discord.gg/stellardev).

## Alternative indexers

- [Subquery](https://subquery.network/)
- [Goldsky](https://goldsky.com/)
- [The Graph](https://thegraph.com/)


