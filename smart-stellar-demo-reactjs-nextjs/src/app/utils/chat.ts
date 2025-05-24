import { Client } from 'chat-demo-sdk';

export const chat = new Client({
    rpcUrl: process.env.NEXT_PUBLIC_RPC_URL!,
    contractId: process.env.NEXT_PUBLIC_CHAT_CONTRACT_ID!,
    networkPassphrase: process.env.NEXT_PUBLIC_NETWORK_PASSPHRASE!,
})
