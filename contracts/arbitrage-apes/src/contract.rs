// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Stellar Soroban Contracts ^0.2.0

use stellar_default_impl_macro::default_impl;
use soroban_sdk::{contract, contracterror, contractimpl, panic_with_error, symbol_short, Address, BytesN, Env, String, Symbol};
use stellar_non_fungible::{
	burnable::NonFungibleBurnable, Base, NonFungibleToken
};
use stellar_ownable::{get_owner, set_owner, Ownable};
use stellar_ownable_macro::only_owner;
use stellar_upgradeable::UpgradeableInternal;
use stellar_upgradeable_macros::Upgradeable;

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
		set_owner(e, &owner);
		Base::set_metadata(
			e,
			String::from_str(e, "www.stellar-arbitrage-apes.xyz"),
			String::from_str(e, "Stellar Arbitrage Ape Yacht Club"),
			String::from_str(e, "SAAYC"),
		);
	}

	#[only_owner]
	pub fn mint(e: &Env, to: Address, token_id: u32) {
		Base::mint(e, &to, token_id);
	}
}

impl UpgradeableInternal for ArbitrageApeYachtClub {
	fn _require_auth(e: &Env, operator: &Address) {
		operator.require_auth();
		let owner = get_owner(e).expect("owner should be set");
		if *operator != owner {
			panic_with_error!(e, ArbitrageApeYachtClubError::Unauthorized)
		}
	}
}

#[default_impl]
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

#[default_impl]
#[contractimpl]
impl NonFungibleBurnable for ArbitrageApeYachtClub {
	fn burn(e: &Env, from: Address, token_id: u32) {
		Self::ContractType::burn(e, &from, token_id);
	}

	fn burn_from(e: &Env, spender: Address, from: Address, token_id: u32) {
		Self::ContractType::burn_from(e, &spender, &from, token_id);
	}
}

#[default_impl]
#[contractimpl]
impl Ownable for ArbitrageApeYachtClub {}
