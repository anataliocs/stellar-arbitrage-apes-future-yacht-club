import { scValToNative, xdr } from "@stellar/stellar-sdk/minimal";

export function getMessages() {
    return fetch(import.meta.env.PUBLIC_ZETTA_BLOCK_API_URL, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "X-API-KEY": import.meta.env.PUBLIC_ZETTA_BLOCK_API_KEY,
        },
        body: JSON.stringify({
            query: `
                query MyQuery {
                    records {
                        id
                        topic
                        value
                        ledger_closed_at
                        transaction_hash
                    }
                }
            `,
        }),
    })
        .then(async (res) => {
            if (res.ok) {
                return res.json();
            } else {
                throw await res.json();
            }
        })
        .then(({ data: { records } }: any) => {
            return records.map((record: any) => {
                return {
                    id: record.id,
                    addr: scValToNative(
                        xdr.ScVal.fromXDR(record.topic, "base64"),
                    ),
                    timestamp: new Date(record.ledger_closed_at), // 2024-12-17 22:19:36.000000 UTC
                    txHash: record.transaction_hash,
                    msg: record.value,
                };
            });
        });
}