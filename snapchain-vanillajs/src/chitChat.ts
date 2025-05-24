import { scrollToBottom } from "./utils";
import { account, server } from "./passkeys";
import { Client as SnapchainClient, networks, type ChatMessage } from "snapchain_sdk";
import { Api } from "@stellar/stellar-sdk/rpc";
import { createChatLedgerKeys, getNextIndex, rpc, stellarExpertLink } from "./stellar";
import { scValToNative } from "@stellar/stellar-sdk";

const snapchain = new SnapchainClient({
    rpcUrl: import.meta.env.VITE_RPC_URL,
    contractId: networks.testnet.contractId,
    networkPassphrase: import.meta.env.VITE_NETWORK_PASSPHRASE,
});

export class ChatLog {
    element: HTMLDivElement;
    nextIndex: number | undefined;
    messages: Record<number, ChatMessage> = {};

    constructor(element: HTMLDivElement) {
        this.element = element
        this.refreshChatHistory()
            .then(scrollToBottom)
    }

    renderMessages() {
        if (!Object.keys(this.messages).length) {
            this.element.innerHTML = `<p>No messages to display...</p>`
            return
        }

        let messageElements = Object.entries(this.messages)
            .map(([_, chatMessage]) => renderMessage(chatMessage))
        this.element.replaceChildren(...messageElements)
    }

    async sendMessage(message: string, author: string, keyId: string) {
        if (!account.wallet?.options) {
            account.connectWallet({ keyId, })
        }

        let at = await snapchain.send({
            author,
            message,
        })

        let tx = await account.sign(at.built!, { keyId })
        await server.send(tx)

        this.refreshChatHistory()
    }

    async fetchMessages() {
        if (!this.nextIndex || this.nextIndex === 0) {
            console.error('no chats yet')
            return
        }

        let possibleChats = createChatLedgerKeys(this.nextIndex - 1);
        // const { entries } = await rpc.getLedgerEntries(...possibleChats)
        let entries: Api.LedgerEntryResult[] = []

        if (possibleChats.length <= 200) {
            // not too many chats, make a single request
            entries = (await rpc.getLedgerEntries(...possibleChats)).entries
        } else {
            // more than 200 chat history, do some iterating
            while (possibleChats.length) {
                let tempChats = possibleChats.slice(0, 200);
                possibleChats = possibleChats.slice(200)
                entries = entries.concat(entries, (await rpc.getLedgerEntries(...tempChats)).entries)
            }
        }

        this.messages = {}
        entries.forEach((e) => {
            const chatIndex = scValToNative(e.key.contractData().key())[1]
            const chatMessage: ChatMessage = scValToNative(e.val.contractData().val())
            this.messages[chatIndex] = chatMessage
        })
    }

    async refreshChatHistory() {
        this.nextIndex = await getNextIndex()
        await this.fetchMessages()
        this.renderMessages()
    }
}

function renderMessage({author, message, timestamp}: ChatMessage): HTMLElement {
    // create the main chunks of a message card
    const article = document.createElement('article')
    article.classList.add('chat-card')
    const header = document.createElement('header')
    const nav = document.createElement('nav')

    // fill in the "header" of the message card
    const smallAuthor = document.createElement('small')
    const authorLink = stellarExpertLink(author)
    smallAuthor.append(authorLink)
    const smallTimestamp = document.createElement('small')
    smallTimestamp.textContent = new Date(Number(timestamp) * 1_000).toLocaleString()

    // create he message paragraph element
    const messageP = document.createElement('p')
    messageP.textContent = message

    // TODO: Add some kind of "save message" button that will extend the ledger entry's TTL

    // assemble the card
    nav.append(smallAuthor, smallTimestamp)
    header.append(nav)
    article.append(header)
    article.append(messageP)

    // return the constructed message card
    return article
}
