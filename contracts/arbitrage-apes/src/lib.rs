// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Stellar Soroban Contracts ^0.2.0
#![no_std]

mod test;

use soroban_sdk::{
    contract, contracterror, contractimpl, symbol_short, Address, BytesN, Env, String, Symbol,
};
use stellar_non_fungible::{burnable::NonFungibleBurnable, Base, NonFungibleToken};

const OWNER: Symbol = symbol_short!("OWNER");

const VERSION: Symbol = symbol_short!("VERSION");

#[contract]
pub struct ArbitrageApeYachtClub;

#[contracterror]
#[derive(Copy, Clone, Debug, Eq, PartialEq, PartialOrd, Ord)]
#[repr(u32)]
pub enum ArbitrageApeYachtClubError {
    Unauthorized = 1,
}

#[contractimpl]
impl ArbitrageApeYachtClub {
    pub fn __constructor(e: &Env, owner: Address) {
        Base::set_metadata(
            e,
            String::from_str(e, "www.arbitrage-apes.xyz"),
            String::from_str(e, "Arbitrage Ape Yacht Club"),
            String::from_str(e, "AAYC"),
        );
        e.storage().instance().set(&OWNER, &owner);

        let mut initial_version: u32 = e.storage().instance().get(&VERSION).unwrap_or(0);
        e.storage().instance().set(&VERSION, &initial_version);
    }

    pub fn version(e: &Env) -> u32 {
        e.storage().instance().get(&VERSION).unwrap_or(0)
    }

    pub fn upgrade(e: &Env, new_wasm_hash: BytesN<32>) {
        let owner: Address = e.storage().instance().get(&OWNER).unwrap();
        owner.require_auth();
        
        let current_version = Self::version(e);
        e.storage().instance().set(&VERSION, &current_version);
        e.deployer().update_current_contract_wasm(new_wasm_hash);
    }

    pub fn mint(e: &Env, to: Address, token_id: u32) {
        let owner: Address = e
            .storage()
            .instance()
            .get(&OWNER)
            .expect("owner should be set");
        owner.require_auth();
        Base::mint(e, &to, token_id);
    }
}

#[contractimpl]
impl NonFungibleToken for ArbitrageApeYachtClub {
    type ContractType = Base;

    fn balance(e: &Env, owner: Address) -> u32 {
        Self::ContractType::balance(e, &owner)
    }

    fn owner_of(e: &Env, token_id: u32) -> Address {
        Self::ContractType::owner_of(e, token_id)
    }

    fn transfer(e: &Env, from: Address, to: Address, token_id: u32) {
        Self::ContractType::transfer(e, &from, &to, token_id);
    }

    fn transfer_from(e: &Env, spender: Address, from: Address, to: Address, token_id: u32) {
        Self::ContractType::transfer_from(e, &spender, &from, &to, token_id);
    }

    fn approve(
        e: &Env,
        approver: Address,
        approved: Address,
        token_id: u32,
        live_until_ledger: u32,
    ) {
        Self::ContractType::approve(e, &approver, &approved, token_id, live_until_ledger);
    }

    fn approve_for_all(e: &Env, owner: Address, operator: Address, live_until_ledger: u32) {
        Self::ContractType::approve_for_all(e, &owner, &operator, live_until_ledger);
    }

    fn get_approved(e: &Env, token_id: u32) -> Option<Address> {
        Self::ContractType::get_approved(e, token_id)
    }

    fn is_approved_for_all(e: &Env, owner: Address, operator: Address) -> bool {
        Self::ContractType::is_approved_for_all(e, &owner, &operator)
    }

    fn name(e: &Env) -> String {
        Self::ContractType::name(e)
    }

    fn symbol(e: &Env) -> String {
        Self::ContractType::symbol(e)
    }

    fn token_uri(e: &Env, token_id: u32) -> String {
        Self::ContractType::token_uri(e, token_id)
    }
}

//
// Extensions
//

#[contractimpl]
impl NonFungibleBurnable for ArbitrageApeYachtClub {
    fn burn(e: &Env, from: Address, token_id: u32) {
        Self::ContractType::burn(e, &from, token_id);
    }

    fn burn_from(e: &Env, spender: Address, from: Address, token_id: u32) {
        Self::ContractType::burn_from(e, &spender, &from, token_id);
    }
}
