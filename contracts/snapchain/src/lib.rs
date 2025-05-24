// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Stellar Soroban Contracts ^0.2.0
#![no_std]

use soroban_sdk::{
    Address, contract, contracterror, contractimpl, Env, panic_with_error, String, Symbol,
    symbol_short
};
use stellar_non_fungible::{
    Base, Base::mint, burnable::NonFungibleBurnable, NonFungibleToken
};
use stellar_pausable::{self as pausable, Pausable};
use stellar_pausable_macros::when_not_paused;
use stellar_upgradeable::UpgradeableInternal;
use stellar_upgradeable_macros::Upgradeable;

const OWNER: Symbol = symbol_short!("OWNER");

#[derive(Upgradeable)]
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
        Base::set_metadata(e, String::from_str(e, "www.mytoken.com"), String::from_str(e, "Arbitrage Ape Yacht Club"), String::from_str(e, "AAYC"));
        e.storage().instance().set(&OWNER, &owner);
    }

    #[when_not_paused]
    pub fn mint(e: &Env, to: Address, token_id: u32) {
        let owner: Address = e.storage().instance().get(&OWNER).expect("owner should be set");
        owner.require_auth();
        Base::mint(e, &to, token_id);
    }
}

#[contractimpl]
impl NonFungibleToken for ArbitrageApeYachtClub {
    type ContractType = Base;

    fn owner_of(e: &Env, token_id: u32) -> Address {
        Self::ContractType::owner_of(e, token_id)
    }

    #[when_not_paused]
    fn transfer(e: &Env, from: Address, to: Address, token_id: u32) {
        Self::ContractType::transfer(e, &from, &to, token_id);
    }

    #[when_not_paused]
    fn transfer_from(e: &Env, spender: Address, from: Address, to: Address, token_id: u32) {
        Self::ContractType::transfer_from(e, &spender, &from, &to, token_id);
    }

    fn balance(e: &Env, owner: Address) -> u32 {
        Self::ContractType::balance(e, &owner)
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
    #[when_not_paused]
    fn burn(e: &Env, from: Address, token_id: u32) {
        Self::ContractType::burn(e, &from, token_id);
    }

    #[when_not_paused]
    fn burn_from(e: &Env, spender: Address, from: Address, token_id: u32) {
        Self::ContractType::burn_from(e, &spender, &from, token_id);
    }
}

//
// Utils
//

impl UpgradeableInternal for ArbitrageApeYachtClub {
    fn _require_auth(e: &Env, operator: &Address) {
        let owner: Address = e.storage().instance().get(&OWNER).expect("owner should be set");
        if owner != *operator {
            panic_with_error!(e, ArbitrageApeYachtClubError::Unauthorized);
        }
        operator.require_auth();
    }
}

#[contractimpl]
impl Pausable for ArbitrageApeYachtClub {
    fn paused(e: &Env) -> bool {
        pausable::paused(e)
    }

    fn pause(e: &Env, caller: Address) {
        let owner: Address = e.storage().instance().get(&OWNER).expect("owner should be set");
        if owner != caller {
            panic_with_error!(e, ArbitrageApeYachtClubError::Unauthorized);
        }
        pausable::pause(e, &caller);
    }

    fn unpause(e: &Env, caller: Address) {
        let owner: Address = e.storage().instance().get(&OWNER).expect("owner should be set");
        if owner != caller {
            panic_with_error!(e, ArbitrageApeYachtClubError::Unauthorized);
        }
        pausable::unpause(e, &caller);
    }
}
