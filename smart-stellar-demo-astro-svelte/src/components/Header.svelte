<script lang="ts">
    import { onMount } from "svelte";
    import { keyId } from "../store/keyId";
    import { contractId } from "../store/contractId";
    import { account, server } from "../utils/passkey-kit";
    import { truncate } from "../utils/base";

    let creating = false;

    onMount(async () => {
        if (localStorage.hasOwnProperty("ssd:keyId")) {
            keyId.set(localStorage.getItem("ssd:keyId")!);
        }
    });

    keyId.subscribe(async (value) => {
        if (value) {
            const { contractId: cid } = await account.connectWallet({
                keyId: value,
            });

            contractId.set(cid);
        }
    });

    async function login() {
        const { keyIdBase64, contractId: cid } = await account.connectWallet();

        keyId.set(keyIdBase64);
        localStorage.setItem("ssd:keyId", keyIdBase64);

        contractId.set(cid);
    }

    async function signUp() {
        creating = true;

        try {
            const {
                keyIdBase64,
                contractId: cid,
                signedTx,
            } = await account.createWallet("Smart Stellar Demo", "Smart Stellar Demo User");

            await server.send(signedTx);

            keyId.set(keyIdBase64);
            localStorage.setItem("ssd:keyId", keyIdBase64);

            contractId.set(cid);
        } finally {
            creating = false;
        }
    }

    function logout() {
        keyId.set(null);
        contractId.set(null);

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
</script>

<header class="relative p-2 bg-lime-950 text-lime-500">
    <div class="flex items-center flex-wrap max-w-[1024px] mx-auto">
        <h1 class="flex text-xl">
            <a href="/"><strong>Smart Stellar Demo</strong></a>
        </h1>

        <div class="flex items-center ml-auto">
            {#if $contractId}
                <a
                    class="mr-2 font-mono text-sm underline"
                    href="https://stellar.expert/explorer/public/contract/{$contractId}"
                    target="_blank">{truncate($contractId, 4)}</a
                >
                <button
                    class="text-lime-950 bg-lime-500 px-2 py-1 ml-2"
                    on:click={logout}>Logout</button
                >
            {:else}
                <button class="underline mr-2" on:click={login}>Login</button>
                <button
                    class="text-lime-950 bg-lime-500 px-2 py-1 disabled:bg-gray-400"
                    on:click={signUp}
                    disabled={creating}
                    >{creating ? "Creating..." : "Create New Account"}</button
                >
            {/if}
        </div>
    </div>
</header>