# Arbitrage Apes Open Zeppelin Soroban Smart Contract

- [Click here to create your contract](https://wizard.openzeppelin.com/stellar#)
- Open Zeppelin Repos:  https://github.com/OpenZeppelin/stellar-contracts
- Review the Audit Reports here:  https://github.com/OpenZeppelin/stellar-contracts/tree/main/audits

Fully Audited Open Zeppelin NFT Contracts now on ✨ [Stellar Network](https://developers.stellar.org/)
with [smart wallets](https://developers.stellar.org/docs/build/apps/smart-wallets)
powered by Stellar Dev Tools
like the **Stellar CLI** and the **Stellar Javascript SDK**

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


**Next Step:** Choose Devcontainers or Local Setup

----

## How to start with Devcontainers
 
Read the [GitHub Docs](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/setting-up-your-repository/facilitating-quick-creation-and-resumption-of-codespaces)

- Option 1: Create [GitHub Codespace from the GitHub UI](https://docs.github.com/en/codespaces/developing-in-a-codespace/creating-a-codespace-for-a-repository#creating-a-codespace-for-a-repository)
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
- Set the default source account for future CLI Commands
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

> pnpm link vs file protocol:  
> https://pnpm.io/cli/link#whats-the-difference-between-pnpm-link-and-using-the-file-protocol

We have included `packages` in our include statement in `tsconfig.json`
```json
{
  "include": [
    "src",
    "packages"
  ]
}
```

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
- Your `.env` file with everything you need to build a dapp around your Open Zeppelin NFT Contract
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
```terminaloutput
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

## Invoking your Contract with the Javascript SDK

We showed you how to use the Stellar CLI to invoke your contract, now let's do it with the
[Javascript SDK](https://stellar.github.io/js-stellar-sdk/).

**Parameters:**
- contract_id (optional) - Deployed contract ID
- SOURCE_KEYPAIR (optional)

Execute:
```bash
pnpx tsx use_contract_bindings.ts [contract_id] [SOURCE_KEYPAIR]
```

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

## NFT dapp Backend - Micro Indexer

We will now create a backend to provide data for your UI.  We will take a flexible approach to building a dapp
backend giving your working examples of various way to supply data to your client front-end.

[Indexers](https://developers.stellar.org/docs/data/indexers) extract and transform raw blockchain data and present the data in a format
that is more easily consumable by a front-end client.

Indexers are generally provided as 3rd-party services.  The following nest.js service is a `micro-indexer` primarily built to consume
contract events emitted by your contract and presents them to your front-end client in a streaming event-driven format.

**Available Formats:**
- ✅ Server Sent Events -> https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events
  - http://localhost:3000/api/stellar/mock/event/sse/
- Websocket -> TODO
- GraphQL -> TODO
- JSON REST API -> TODO

**Mock Data vs Testnet:**
- Mock data streams allow you to quickly iterate on your front-end UI without having to stage actually data on-chain.  This data will be generated according to the schema to ensure it works with live testnet data.
- Testnet data streams will include the ability to invoke the `mint()` function to generate testnet data

**Run locally**
https://github.com/anataliocs/arbitrage-apes-backend
```
git clone git@github.com:anataliocs/arbitrage-apes-backend.git
```

**Choose a Testnet RPC Provider**
- https://developers.stellar.org/docs/data/apis/api-providers#publicly-accessible-apis
```dotenv
STELLAR_RPC_SERVER_URL=https://soroban-testnet.stellar.org
```

**Start locally:**
```bash
pnpm start:dev
```

**Backend:**
- Using SSE
- Moves complex code from front-end to backend
- Push JSON, HTML code, or React components or fragments to your front-end client

**Front-end -> Single HTML file**
- Check out `mock-sse.html` or `mock-sse-by-contractid.html` for a working example
- Requires running `arbitrage-apes-backend` micro-indexer on port `3000`

**Backend SSE Example**
- This example uses RxJS to generate a stream of MessageEvents pushed to a front-end client
- Example stream URL: http://localhost:3000/api/stellar/mock/event/sse/CC6GBNMVYR4SVUDWTIP7KTMGBQF22OJQFTBXHGZKE3LLJPBGIYXIIOL4
```
  @Sse('sse/:contractId')
  sse_by_contract_id(
    @Param('contractId') contractId: string,
  ): Observable<MessageEvent> {
    return interval(1000).pipe(
      map(
        this.stellarMockEventService.transformMessageEventWithContract(
          contractId,
        ),
      ),
    );
  }
```

**CORS**
CORS is setup on the server to allow for http://localhost:63342/ and http://localhost:63343/ you will have to add this CORS config.

- Last Resort: You can try opening Chrome in a sandbox with web security disabled:
- This approach is NOT recommended 
```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome http://localhost:63342/stellar-arbitrage-apes-future-yacht-club/index.html?_ijt=q9fn6vaje10r5bcfgmcmafoo6p&_ij_reload=RELOAD_ON_SAVE \
--args --disable-web-security --user-data-dir="~/.chrome.dev.session/" --incognito --new-window
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
TODO
```

## Opinionated Front-end Client Creation

The method of UI creation is a template that is actively maintained, 500+ deployments, and full 
test suite + static analysis with app generation test. 218 github stars.
- https://nextjs-boilerplate-hadrysm.vercel.app/
- https://github.com/hadrysm/nextjs-boilerplate

- Generates Next.js boilerplate basic UI

----

## Storing Data

How data is stored is an important consideration!

Learn more about Stellar Smart Contract Storage in the following file:
`Learning_Stellar_Smart_Contract_Storage.md`

**Storage Key Definition:**

Unique key with which to store or retrieve data.

```
TODO - Update this section
```

- [Enums in Rust](https://doc.rust-lang.org/book/ch06-01-defining-an-enum.html) define an enumeration, a limited set
  of possible values
- This `enum` defines a single possible variant of `Storage` keys
- This custom data type acts as a key to look up a stored value

All together, this gives us a unique, named-spaced custom data type to function as a key
to store and retrieve values from storage.

Using the Data Key in the format `Namespace::Variant(Associated value)`:

```
TODO
```

**Storage Value Type Definition:**

Define the interface for storing data.

```
TODO
```

- [Structs in Rust](https://doc.rust-lang.org/book/ch05-01-defining-structs.html) define a type with multiple named
  associated values called **fields**
- The name of the struct is a type that describes the purpose of the data grouping
- Each field is defined in the format `name: Type`
- This struct functions as an interface of key:value pairs that define an atomic piece of data to be stored

> **⚠️ Warning**
>
> A common mistake is importing the `alloc::string::String` type which will cause
> you all sorts of issues!
>
> Make sure you import the `soroban_sdk::{String}` type!

----

#### Storing Soroban Data using the `Env` Interface

How to store data on-chain:

```
TODO
```

**Storing data on-chain**

- Your function definition will need to include a reference to the `Env` type
- The [soroban_sdk::env](https://docs.rs/soroban-sdk/latest/soroban_sdk/struct.Env.html) type provides ways to interact
  with the execution environment
	- **TL;DR;** Contracts talk to the Stellar network via the environment interface
- The `env.storage.temporary().set` function allows for storing data on-chain with a limited lifespan
	- Data that needs to
	  be [stored permanantly](https://developers.stellar.org/docs/learn/encyclopedia/storage/persisting-data) should go
	  into `persistent()` durability
	- Check out the docs for help on choosing
	  the [right storage durability](https://developers.stellar.org/docs/learn/encyclopedia/storage/persisting-data#best-practices)

---

## Contract Source Validation

Build verification

TODO - `.github/workflows/release.yml`

- https://stellar.expert/explorer/public/contract/validation
- [Contract Source Validation SEP #1573](https://github.com/orgs/stellar/discussions/1573)
- https://lab.stellar.org/smart-contracts/contract-explorer


----

## 👀 Want to learn more?

Feel free to check [our documentation](https://developers.stellar.org/) or jump into
our [Discord server](https://discord.gg/stellardev).

---
