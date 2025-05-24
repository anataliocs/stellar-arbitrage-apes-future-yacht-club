'use client';
import React, { useEffect, useState } from 'react';
import {useContractIdStore} from '../store/contractId';
import { ChatEvent } from '../types/Welcome.types';
import { getMessages } from "../utils/zettablocks";
import { truncate } from "../utils/base";
import { getEvents, rpc } from "../utils/rpc";
import MessageForm from "./Form";

export default function Welcome() {
    const [messages, setMessages] = useState([{
        id: "",
        addr: "",
        timestamp: new Date,
        txHash: "",
        msg: "",
    }]);

    let msgs: ChatEvent[] = [];
    let interval: NodeJS.Timeout;
    const contractId = useContractIdStore((state) => state.contractId)
    
    useEffect(() => {
        async function eventInterval() {
            await callGetMessages();

            const { sequence } = await rpc.getLatestLedger();
            await callGetEvents(sequence - 17_280); // last 24 hrs

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

    async function callGetMessages() {
        let _msgs: ChatEvent[] = await getMessages();

        _msgs = _msgs.sort(
            (a, b) => a.timestamp.getTime() - b.timestamp.getTime(),
        );

        if (_msgs.length > 0) {
            setMessages(_msgs);
        }
    }

    async function callGetEvents(
        limit: number | string,
        found: boolean = false,
    ) {
        msgs = await getEvents(msgs, limit, found);

        setMessages(messages => {
            const mergedArray = [...messages, ...msgs];
            const uniqueMap = new Map();
            const key = 'id';
              
            for (const item of mergedArray) {
                uniqueMap.set(item[key], item);
            }

            const sortedUniqueMap = Array.from(uniqueMap.values()).sort(
                (a, b) => a.timestamp.getTime() - b.timestamp.getTime(),
            );

            return sortedUniqueMap;
        });
    }

    return (
        <div className="flex flex-col min-w-full items-center my-10">
        {contractId ? (
        <div className="max-w-[350px] w-full">
            <ul>
                {messages.map((msg, i) => (
                    <li className="mb-2" key={i}>
                        <span
                            className="text-mono text-sm bg-black rounded-t-lg text-white px-3 py-1"
                        >
                            <a
                                className="underline"
                                target="_blank"
                                href={"https://stellar.expert/explorer/public/tx/" + msg.txHash}
                            >
                                    {truncate(msg.addr, 4)}
                            </a>
                            &nbsp; &nbsp;
                            <time
                                className="text-xs text-gray-400"
                            >
                                {msg.timestamp.toLocaleTimeString()}
                            </time>
                        </span>
                        <p
                            className="min-w-[220px] text-pretty break-words bg-gray-200 px-3 py-1 rounded-b-lg rounded-tr-lg border border-gray-400"
                        >
                            {msg.msg}
                        </p>
                    </li>
                ))}
            </ul>

            <MessageForm />
        </div>
    ) : (
        <h1>Login or create a new account</h1>
    )}
        </div>
    )
}
