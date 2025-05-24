# Stellar Smart Contract Demo: React & Next.js Front-end

Learn how to build a dApp front-end on the ✨ [Stellar Network](https://developers.stellar.org/)
with [smart wallets](https://developers.stellar.org/docs/build/apps/smart-wallets)
powered by Stellar Dev Tools
like the **Stellar CLI**, the **Stellar Javascript SDK**, **Passkey Kit** and **Launchtube**.

With a front-end built with **React** and **Next.js** with **Zustand** for state management.

This example builds on the contract and UI from [kalepail/smart-stellar-demo](https://github.com/kalepail/smart-stellar-demo)

**🛠️ Dev Tools**

- 💻 [Stellar CLI](https://developers.stellar.org/docs/tools/cli/install-cli)
	- Featuring: [Generating Bindings](https://developers.stellar.org/docs/tools/cli/stellar-cli#stellar-contract-bindings)
- ⚙️ [Stellar Javascript SDK](https://developers.stellar.org/docs/tools/sdks/client-sdks#javascript-sdk)
	- Featuring: [Stellar RPC Server](https://stellar.github.io/js-stellar-sdk/module-rpc.Server.html)
- 🔐 [Passkey Kit](https://github.com/kalepail/passkey-kit) - Seamless authentication
- 🚀 [Launchtube](https://github.com/stellar/launchtube) - Transaction submission and paymaster functionality

---

### 🔐 Passkey Kit: Simplifying UX

[Passkey Kit GitHub Repository](https://github.com/kalepail/passkey-kit)

Self-custody is too complicated for users.

**Passkey Kit** streamlines user experience leveraging biometric authentication for signing and
fine-grained authorization of Stellar transactions
with [Policy Signers](https://github.com/kalepail/passkey-kit/tree/next/contracts/sample-policy).

---

### 🚀 Launchtube: Get your Operation On-Chain

[Launchtube GitHub Repository](https://github.com/stellar/launchtube)

Launchtube is a super cool service that abstracts away the complexity of
submitting transactions.

1. **Transaction Lifecycle Management**:
	- Transaction Submission
	- Retries
	- Working around rate limits

2. **Paymaster Service**:
	- Pays transaction fees

---

## ✨ Stellar Smart Contract React & Next.js Demo

Secure, passkey-powered, chat messages.

## Polling for Events

**Make a Remote Procedure Call(RPC) with:**

- [Stellar CLI](https://github.com/stellar/stellar-cli)
- Using [Stellar Lab](https://lab.stellar.org/)

**Using a `start-ledger` parameter:**

```bash
stellar events \
	--network testnet \
    --start-ledger 589386 \
    --id CBUMOJAEAPLQUCWVIM6HJH5XKXW5OP7CRVOOYMJYSTZ6GFDNA72O2QW6 \
    --output pretty
```

**Using Stellar Lab**
[Stellar lab getEvents request](https://lab.stellar.org/endpoints/rpc/get-events?$=network$id=testnet&label=Testnet&horizonUrl=https:////horizon-testnet.stellar.org&rpcUrl=https:////testnet.rpciege.com//&passphrase=Test%20SDF%20Network%20/;%20September%202015;&endpoints$params$startLedger=589386&limit=10&filters=%7B%22type%22:%22contract%22,%22contract_ids%22:%5B%22CBUMOJAEAPLQUCWVIM6HJH5XKXW5OP7CRVOOYMJYSTZ6GFDNA72O2QW6%22%5D,%22topics%22:%5B%22%22%5D%7D)

### Understanding the `getEvents()` RPC Response

JSON response for [Get Events RPC Call](https://developers.stellar.org/docs/data/apis/rpc/api-reference/methods/getEvents):

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

## Rpc Server - Retrieve and Process Contract Events

Path:  `src/app/utils/rpc.ts`
Uses the [Stellar Javascript SDK](https://stellar.github.io/js-stellar-sdk/)

**Contract Event Retrieval**:

- Fetches contract events
- Filters events by contract ID, topic and validates data integrity
- Converts `Api.GetEventsResponse` into structured `ChatEvent` objects
- ChatEvent type defined in `src/app/types/Utils.types.ts`

**Fetch Contract Events:**

- Instantiate RPC Server

```typescript
export const rpc = new Server(process.env.NEXT_PUBLIC_RPC_URL!);
```

- Call Get Events RPC call

```typescript
export async function getEvents(msgs: ChatEvent[], limit: number | string, found: boolean = false) {
    await rpc.getEvents ({});
}
```

**Filter Events by Contract ID:**

Get events for deployed contract using `contract` filter.

- Pass in contract `filter`s array `filters: []`
- Import deployed contract ID from env `process.env.NEXT_PUBLIC_CHAT_CONTRACT_ID!`
- Set `startLedger` or `cursor`
- Set`limit` or max returned values

```typescript
await rpc.getEvents(
    {
		// Set events filters
		filters: [
            // Filter for contract events of deployed contract
			{
				type: "contract",
				contractIds: [process.env.NEXT_PUBLIC_CHAT_CONTRACT_ID!],
			},
		],
		// Ledger # to start return events from
		startLedger: typeof limit === "number" ? limit : undefined,
		// Max number of returned entries
		limit: 10_000,
		// Cursor to start looking at events from
		cursor: typeof limit === "string" ? limit : undefined,
	}
)
```

**Convert from GetEvent API Response to Chat Event Object:**
 
_Take raw RPC GetEvent responses, validate and convert data for local UI usage._ 

- Validate event type is `contract` and `contractId` is present
- Get `Address` from first entry in event topic array `event.topic[0].address()`
- Output as publicKey type `Ed25519` for `scAddressTypeAccount` type
- Or contractId for `scAddressTypeContract` type

```typescript
// Loop through events return by `getEvents()` rpc call
events.forEach((event) => {
    // Verify event type and contractId
	if (event.type !== "contract" || !event.contractId) return;

	if (msgs.findIndex(({ id }) => id === event.id) === -1) {
		let addr: string | undefined;
        // Get Address from first entry in event topic array
		const topic0 = event.topic[0].address();

		switch (topic0.switch().name) {
            // Return ed25519 accountId string 
			case "scAddressTypeAccount": {
				addr = Address.account(
						topic0.accountId().ed25519(),
				).toString();
				break;
			}
            // Return contractId address string
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

**Create `ChatEvent` from RPC Contract Event data**

_Take extracted fields from raw getEvents() response and create Chat Event._

- `ChatEvent` interface defined in `src/app/types/Utils.types.ts`
- Set fields in `ChatEvent`:
	- id as `string`
	- addr as `string`
	- timestamp as `Date`
	- txHash as `string`
	- msg as `string`

```typescript
// Add to msgs array
msgs.push(
    // Create `ChatEvent` from extracted data from event
    {
    	id: event.id,
    	addr,
    	timestamp: new Date(event.ledgerClosedAt),
    	txHash: event.txHash,
    	msg: scValToNative(event.value),
	} as ChatEvent
);
```

### Configuration Options

- `_limit`: Maximum number of events to retrieve per request (default: 1,000)
- Environment variables from `.env`:
	- `NEXT_PUBLIC_RPC_URL`: The URL of the Stellar RPC server
	- `NEXT_PUBLIC_NETWORK_PASSPHRASE`: The network passphrase for the target Stellar network
	- `NEXT_PUBLIC_CHAT_CONTRACT_ID`: The default contract ID to filter events
    - `NEXT_PUBLIC_CHAT_CONTRACT_START_LEDGER` : Stat ledger for RPC call

## Front-End UI Code

Running the next.js/React project with `pnpm`

### 🛠 PNPM Commands

Run from the root directory of the project:

| Command                    | Action                                       |
|:---------------------------|:---------------------------------------------|
| `pnpm install`             | Installs dependencies                        |
| `pnpm dev`                 | Starts local dev server at `localhost:3000`  |
 
Now let's review the 3 React components `Form`, `Header` and `Welcome`.

- `src/app/components/Form.tsx` - Used to submit Chat messages
- `src/app/components/Header.tsx` - Used to login with Passkeys
- `src/app/components/Welcome.tsx` - Used to display Chat messages

---

### React Component Header.tsx

Facilitates creation of passkey accounts with Passkey's kit.

Review the following file:
`src/app/components/Header.tsx`

```typescript
async function signUp() {
    // Set icon
	setCreating(true);

	try {
		// PasskeyKit initialized in src/app/utils/passkey-kit.ts used to create smart wallet
		const {
			keyIdBase64,
			contractId: cid,
			signedTx,
		} = await account.createWallet("Smart Stellar Demo", "Smart Stellar Demo User");

        // Launchtube server initialized in src/app/utils/passkey-kit.ts
		await server.send(signedTx);

        // Store passkey keyId in local storage
		updateKeyId(keyIdBase64);
		localStorage.setItem("ssd:keyId", keyIdBase64);

		updateContractId(cid)
	} finally {
		setCreating(false);
	}
}
```

---

### React Component Welcome.tsx

Let's walk through how `ChatEvent`s are displayed in the UI.

Review the following file:
`src/app/components/Welcome.tsx`

This component prints out the chat messages stored in state:

- Setup and configure state management
- Import `getEvents` and `rpc` from `src/app/utils/rpc.ts`
- Setup `useEffect()` React hook to schedule state update event
- Use `rpc.getLatestLedger()` to create 24 lookback period
- Call `getEvents()` rpc function 
- Merge chat messages into existing array: `mergedArray = [...messages, ...msgs]`
- De-duplicate messages using map with unique keys
- Sort messages by Timestamp
- Set messages in `zustand` state `setMessages(messages => {})`

**Configure State**

Messages are stored in state as an array in `zustand`:
```typescript
	// Setup and configure state management
    const [messages, setMessages] = useState([{
	id: "",
	addr: "",
	timestamp: new Date,
	txHash: "",
	msg: "",
}]);
```

**Set React Hook: useEffect()**

 - Use React Hook to trigger call to rpc server
 - https://react.dev/reference/react/useEffect
 - Sync chat message data displayed in UI with emitted contract events

```typescript jsx
// Setup React hook
useEffect(() => {
	async function eventInterval() {

        // Determine ledger sequence for 24 hour lookback period
		const { sequence } = await rpc.getLatestLedger();
		await callGetEvents(sequence - 17_280); // last 24 hrs

		// Setup interval for updating state with rpc getEvents() call
		interval = setInterval(async () => {
			const { sequence } = await rpc.getLatestLedger();
			await callGetEvents(sequence - 17_280); // last 24 hrs
			console.log('timer');
		}, 12_000); // 12_000 = 5 times per minute
	}
	eventInterval();

	return () => {
		if (interval) clearInterval(interval);
	};
}, []);
```

**Update State with Sorted Unique Map of Messages**

- Get Events
- Merge chat & de-dupe messages
- Sort by Timestamp then set messages state

```typescript jsx
// Function to update state with rpc getEvents() call
async function callGetEvents(
		limit: number | string,
		found: boolean = false,
) {
    // Call getEvents() rpc function
	msgs = await getEvents(msgs, limit, found);

    // Update zustand state with sorted, unique map of messages
	setMessages(messages => {
		const mergedArray = [...messages, ...msgs];
		const uniqueMap = new Map();
		const key = 'id';

		for (const item of mergedArray) {
			uniqueMap.set(item[key], item);
		}

        // Sort messages by timestamp
		const sortedUniqueMap = Array.from(uniqueMap.values()).sort(
				(a, b) => a.timestamp.getTime() - b.timestamp.getTime(),
		);

		return sortedUniqueMap;
	});
}
```

**Updating the UI**

Updating the UI in response to changes in the state.

**Loop through msgs array and display `ChatEvent` in UI:**

- Use React JSX expression language
- Use `messages.map` to iterate over messages stored in state
- Print out `ChatEvent` message fields embedded in styled HTML
- Each message is enclosed in a unordered list elements `<li>`

```typescript jsx
<ul>
	{messages.map((msg, i) => (
	<li className="mb-2" key={i}>
		<span className="text-mono text-sm bg-black rounded-t-lg text-white px-3 py-1">
			
			<a className="underline"
			   target="_blank"
			   href={"https://stellar.expert/explorer/public/tx/" + msg.txHash}>
				{truncate(msg.addr, 4)}
            </a>
			
			<time className="text-xs text-gray-400">
				{msg.timestamp.toLocaleTimeString()}
            </time>
        </span>
		<p className="min-w-[220px] text-pretty break-words bg-gray-200 px-3 py-1 rounded-b-lg rounded-tr-lg border border-gray-400">
			{msg.msg}
		</p>
	</li>
	))}
</ul>
```

### React Component Form.tsx

Let's walk through how the `MessageForm` component is used to send messages

Review the following file:
`src/app/components/Form.tsx`

- `src/app/utils/chat.ts` configures `Client` from `chat-demo-sdk` contract bindings
- `chat-demo-sdk` bindings were generated with Stellar CLI
	- Review `chat-demo-sdk/README.md` for more info
- Client configured in `chat.ts` with `rpcUrl`, `contractId` and `networkPassphrase` from `.env` params
- Invoke deployed contract `chat.send()` function, passing in `addr` and `msg` string
- Sign `AssembledTransaction` with `PasskeyKit` Signer passing in `keyId` and transaction to `sign()` function
- This will then prompt your browser to request your fingerprint
- Use the Launchtube `PasskeyServer` configured with `rpcUrl`, `launchtubeUrl` and `launchtubeJwt`
- Await JSON response from Launchtube server

```typescript jsx
// Define onSubmit action for React Form
async function onSubmit(event: FormEvent<HTMLFormElement>) {
    
    // Get form data from React FormEvent data
	let msg = formData.get('msg') as string;
	const formKeyId = formData.get('kid') as string;
	const formContractId = formData.get('cid') as string;

    // Assemble chat.send() contract function invocation with client contract bindings
    let at = await chat.send(
        {
			addr: formContractId,
			msg,
		});

    	// Sign assembled transaction with Passkey Kit
		at = await account.sign(at, { keyId: formKeyId });

        // Send transaction with Launchtube
		await server.send(at);
}
```

---

For more details on how Passkeys and Launchtube work check out the example repo: https://github.com/kalepail/smart-stellar-demo

## 👀 Want to learn more?

Feel free to check [our documentation](https://developers.stellar.org/) or jump into
our [Discord server](https://discord.gg/stellardev).

---
