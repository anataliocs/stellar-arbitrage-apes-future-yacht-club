<script lang="ts">
    import { contractId } from "../store/contractId";
    import { truncate } from "../utils/base";
    import { onDestroy, onMount } from "svelte";
    import { keyId } from "../store/keyId";
    import { chat } from "../utils/chat";
    import { account, server } from "../utils/passkey-kit";
    import { getMessages } from "../utils/zettablocks";
    import { getEvents, rpc } from "../utils/rpc";

    let interval: NodeJS.Timeout;

    let msg: string = "";
    let msgs: ChatEvent[] = [];

    let sending: boolean = false;

    onMount(async () => {
        await callGetMessages();

        const { sequence } = await rpc.getLatestLedger();
        await callGetEvents(sequence - 17_280); // last 24 hrs

        interval = setInterval(async () => {
            const { sequence } = await rpc.getLatestLedger();
            await callGetEvents(sequence - 17_280); // last 24 hrs
        }, 12_000); // 5 times per minute
    });

    onDestroy(() => {
        if (interval) clearInterval(interval);
    });

    async function callGetMessages() {
        msgs = await getMessages();
        msgs = msgs.sort(
            (a, b) => a.timestamp.getTime() - b.timestamp.getTime(),
        );
    }

    async function callGetEvents(
        limit: number | string,
        found: boolean = false,
    ) {
        msgs = await getEvents(msgs, limit, found);
        msgs = msgs.sort(
            (a, b) => a.timestamp.getTime() - b.timestamp.getTime(),
        );
    }

    async function send() {
        if (!$contractId || !$keyId) return;

        try {
            sending = true;

            let at = await chat.send({
                addr: $contractId,
                msg,
            });

            at = await account.sign(at, { keyId: $keyId });

            await server.send(at);

            msg = "";
        } finally {
            sending = false;
        }
    }
</script>

<div class="flex flex-col min-w-full items-center my-10">
    {#if $contractId}
        <div class="max-w-[350px] w-full">
            <ul>
                {#each msgs as event}
                    <li class="mb-2">
                        <span
                            class="text-mono text-sm bg-black rounded-t-lg text-white px-3 py-1"
                        >
                            <a
                                class="underline"
                                target="_blank"
                                href="https://stellar.expert/explorer/public/tx/{event.txHash}"
                                >{truncate(event.addr, 4)}</a
                            >
                            &nbsp; &nbsp;
                            <time
                                class="text-xs text-gray-400"
                                datetime={event.timestamp.toUTCString()}
                            >
                                {event.timestamp.toLocaleTimeString()}
                            </time>
                        </span>
                        <p
                            class="min-w-[220px] text-pretty break-words bg-gray-200 px-3 py-1 rounded-b-lg rounded-tr-lg border border-gray-400"
                        >
                            {event.msg}
                        </p>
                    </li>
                {/each}
            </ul>

            <form class="flex flex-col mt-5" on:submit|preventDefault={send}>
                <textarea
                    class="border px-3 py-1 mb-2 border-gray-400 rounded-lg"
                    rows="4"
                    name="msg"
                    id="msg"
                    placeholder="Type your message..."
                    bind:value={msg}
                ></textarea>

                <div class="flex items-center ml-auto">
                    <button
                        class="bg-black text-white px-2 py-1 text-sm font-mono disabled:bg-gray-400"
                        type="submit"
                        disabled={sending}>Send{sending ? "ing..." : ""}</button
                    >
                </div>
            </form>
        </div>
    {:else}
        <h1>Login or create a new account</h1>
    {/if}
</div>
