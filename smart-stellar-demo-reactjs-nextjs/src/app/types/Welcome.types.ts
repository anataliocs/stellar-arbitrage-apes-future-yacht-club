export interface ChatEvent {
    id: string;
    addr: string;
    timestamp: Date;
    txHash: string;
    msg: string;
}

export interface ZBQuery {
    id: string;
    topic: string;
    topic_raw: string;
    value: string;
    ledger_closed_at: string;
    transaction_hash: string;
}
