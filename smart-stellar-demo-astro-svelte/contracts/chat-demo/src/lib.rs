#![no_std]
use soroban_sdk::{contract, contractimpl, Address, Env, String};

#[contract]
pub struct Contract;

#[contractimpl]
impl Contract {
    pub fn send(env: Env, addr: Address, msg: String) {
        addr.require_auth();

        env.events().publish((addr.clone(),), msg.clone());
    }
}

mod test;
