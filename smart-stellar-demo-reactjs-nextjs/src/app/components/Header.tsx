'use client';
import React, { useEffect, useState } from 'react';
import Link from 'next/link'
import { account, server } from "../utils/passkey-kit";
import {useKeyIdStore} from '../store/keyId';
import {useContractIdStore} from '../store/contractId';
import { truncate } from "../utils/base";

export default function Header() {
    const [creating, setCreating] = useState(false)

    const contractId = useContractIdStore((state) => state.contractId)
    const updateContractId = useContractIdStore((state) => state.setContractId)

    //const keyId = useKeyIdStore((state) => state.keyId)
    const updateKeyId = useKeyIdStore((state) => state.setKeyId)

    useEffect(() => {
        if (localStorage.hasOwnProperty("ssd:keyId")) {
            updateKeyId(localStorage.getItem("ssd:keyId")!)
        }

        return () => {

        };
    }, []);

    async function signUp() {
        setCreating(true);

        try {

            const { 
                keyIdBase64,
                contractId: cid,
                signedTx,
            } = await account.createWallet("Smart Stellar Demo", "Smart Stellar Demo User");

            await server.send(signedTx);

            updateKeyId(keyIdBase64);
            localStorage.setItem("ssd:keyId", keyIdBase64);

            updateContractId(cid)
        } finally {
            setCreating(false);
        }
    }

    async function login() {
        const { keyIdBase64, contractId: cid } = await account.connectWallet();

        updateKeyId(keyIdBase64)
        localStorage.setItem("ssd:keyId", keyIdBase64);

        updateContractId(cid);
    }

    async function logout() {
        updateContractId('');

        Object.keys(localStorage).forEach((key) => {
            if (key.includes("ssd:")) {
                localStorage.removeItem(key);
            }
        });

        Object.keys(sessionStorage).forEach((key) => {
            if (key.includes("ssd:")) {
                sessionStorage.removeItem(key);
            }
        });

        location.reload();
    }

    return (
        <div className="relative p-2 bg-lime-950 text-lime-500">
            <div className="flex items-center flex-wrap max-w-[1024px] mx-auto">
                <h1 className="flex text-xl">
                    <Link href="/">Smart Stellar Demo</Link>
                </h1>

                <div className="flex items-center ml-auto">
                    {contractId ? (
                        <>
                            <a
                                className="mr-2 font-mono text-sm underline"
                                href={"https://stellar.expert/explorer/public/contract/" + contractId}
                                target="_blank"
                            >
                                    {truncate(contractId, 4)}
                            </a>
                            <button
                                className="text-lime-950 bg-lime-500 px-2 py-1 ml-2"
                                onClick={logout}>
                                    Logout
                            </button>
                        </>
                    ) : (
                        <>
                            <button className="underline mr-2" onClick={login}>Login</button>
                            <button
                                className="text-lime-950 bg-lime-500 px-2 py-1 disabled:bg-gray-400"
                                onClick={signUp}
                                disabled={creating}
                            >
                                {creating ? "Creating..." : "Create New Account"}
                            </button>
                        </>
                    )}
                </div>
            </div>
        </div>    
    );
}
