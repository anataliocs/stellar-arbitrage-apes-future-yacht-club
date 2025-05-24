#![no_std]
use soroban_sdk::{contract, contractimpl, contracttype, symbol_short, Address, Env, String, Symbol};

#[contracttype]
pub enum Storage {
    Chat(u32) // : ChatMessage
}

#[contracttype]
pub struct ChatMessage {
    author: Address,
    message: String,
    timestamp: u64,
}

const INDEX: Symbol = symbol_short!("INDEX");

#[contract]
pub struct Contract;

#[contractimpl]
impl Contract {
    pub fn send(env: Env, author: Address, message: String) {
        author.require_auth();

        let mut next_index: u32 = env.storage().instance().get(&INDEX).unwrap_or(0);

        env.storage().temporary().set(&Storage::Chat(next_index), &ChatMessage {
            author,
            message,
            timestamp: env.ledger().timestamp(),
        });

        next_index += 1;
        env.storage().instance().set(&INDEX, &next_index);
    }
}

mod test;
