import { Client } from 'chat-demo-sdk';

export const chat = new Client({
    rpcUrl: import.meta.env.PUBLIC_RPC_URL,
    contractId: import.meta.env.PUBLIC_CHAT_CONTRACT_ID,
    networkPassphrase: import.meta.env.PUBLIC_NETWORK_PASSPHRASE,
})