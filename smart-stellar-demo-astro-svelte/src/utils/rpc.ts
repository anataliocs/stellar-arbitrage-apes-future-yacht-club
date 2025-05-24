import { Address, scValToNative } from "@stellar/stellar-sdk/minimal";
import { Server } from "@stellar/stellar-sdk/minimal/rpc";

export const rpc = new Server(import.meta.env.PUBLIC_RPC_URL, import.meta.env.PUBLIC_NETWORK_PASSPHRASE);

export async function getEvents(msgs: ChatEvent[], limit: number | string, found: boolean = false) {
    await rpc
        .getEvents({
            filters: [
                {
                    type: "contract",
                    contractIds: [import.meta.env.PUBLIC_CHAT_CONTRACT_ID],
                },
            ],
            startLedger: typeof limit === "number" ? limit : undefined,
            limit: 10_000,
            cursor: typeof limit === "string" ? limit : undefined,
        })
        .then(async ({ events, cursor }) => {
            if (events.length === 0) {
                if (limit === cursor || found) return;
                return getEvents(msgs, cursor);
            }

            events.forEach((event) => {
                if (event.type !== "contract" || !event.contractId) return;

                if (msgs.findIndex(({ id }) => id === event.id) === -1) {
                    let addr: string | undefined;
                    let topic0 = event.topic[0].address();

                    switch (topic0.switch().name) {
                        case "scAddressTypeAccount": {
                            addr = Address.account(
                                topic0.accountId().ed25519(),
                            ).toString();
                            break;
                        }
                        case "scAddressTypeContract": {
                            addr = Address.contract(
                                topic0.contractId(),
                            ).toString();
                            break;
                        }
                    }

                    msgs.push({
                        id: event.id,
                        addr,
                        timestamp: new Date(event.ledgerClosedAt),
                        txHash: event.txHash,
                        msg: scValToNative(event.value),
                    });
                }
            });

            return getEvents(msgs, cursor, true);
        });

    return msgs;
}