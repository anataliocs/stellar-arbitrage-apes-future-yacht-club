import React, { FormEvent, useState } from 'react';
import {useKeyIdStore} from '../store/keyId';
import {useContractIdStore} from '../store/contractId';
import { chat } from "../utils/chat";
import { account, server } from "../utils/passkey-kit";

let sending = false;

export default function MessageForm() {
    const [msg, setMsg] = useState("");

    async function onSubmit(event: FormEvent<HTMLFormElement>) {
        event.preventDefault()
     
        const formData = new FormData(event.currentTarget)   
        let msg = formData.get('msg') as string;
        const formKeyId = formData.get('kid') as string;
        const formContractId = formData.get('cid') as string;
    
        if (!formContractId || !formKeyId) return {
            addr: '',
            msg: '',
        };
    
        try {
            sending = true;

            let at = await chat.send({
                addr: formContractId,
                msg,
            });

            at = await account.sign(at, { keyId: formKeyId });

            await server.send(at);

            msg = "";
        } catch (error) {
            console.error("An error occurred:", error);
        } finally {
            sending = false;
        }

        setMsg("");    
        return {
            addr: formData.get('addr') as string,
            msg: formData.get('msg') as string,
        }
      }

    const keyId = useKeyIdStore((state) => state.keyId)
    const contractId = useContractIdStore((state) => state.contractId)

    return (
        <form className="flex flex-col mt-5" onSubmit={onSubmit}>
            <textarea
                className="border px-3 py-1 mb-2 border-gray-400 rounded-lg"
                rows={4}
                name="msg"
                id="msg"
                placeholder="Type your message..."
                value={msg}
                onChange={(e) => setMsg(e.target.value)}
            ></textarea>
            <input type='hidden' id="kid" name="kid" value={keyId} />
            <input type='hidden' id="cid" name="cid" value={contractId} />
            <div className="flex items-center ml-auto">
                <button
                    className="bg-black text-white px-2 py-1 text-sm font-mono disabled:bg-gray-400"
                    type="submit"
                    disabled={sending}
                >
                    Send{sending ? "ing..." : ""}
                </button>
            </div>
        </form>
    )
}
