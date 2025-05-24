"use client";
import { PasskeyKit, PasskeyServer } from "passkey-kit";

export const account = new PasskeyKit({
    rpcUrl: process.env.NEXT_PUBLIC_RPC_URL!,
    networkPassphrase: process.env.NEXT_PUBLIC_NETWORK_PASSPHRASE!,
    walletWasmHash: process.env.NEXT_PUBLIC_WALLET_WASM_HASH!,
    timeoutInSeconds: 30,
});

export const server = new PasskeyServer({
    rpcUrl: process.env.PUBLIC_RPC_URL,
    launchtubeUrl: process.env.NEXT_PUBLIC_LAUNCHTUBE_URL,
    launchtubeJwt: process.env.NEXT_PUBLIC_LAUNCHTUBE_JWT,
});