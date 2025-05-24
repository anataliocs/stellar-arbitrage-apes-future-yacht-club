#![cfg(test)]

use std::println;
extern crate std;

use soroban_sdk::{
    testutils::{Address as _, EnvTestConfig, Events as _},
    Address, Env, IntoVal, String,
};

use crate::{Contract, ContractClient};

#[test]
fn test() {
    let mut env = Env::default();

    env.set_config(EnvTestConfig {
        capture_snapshot_at_drop: false,
    });

    env.mock_all_auths();

    let contract_id = env.register(Contract, ());
    let client = ContractClient::new(&env, &contract_id);

    let addr = Address::generate(&env);

    let msg1 = String::from_str(&env, "Hello World!");
    let msg2 = String::from_str(&env, "Goodnight Moon!");

    client.send(&addr, &msg1);
    client.send(&addr, &msg2);

    for event in env.events().all() {
        println!("{:?}", event.0);

        for topic in event.1 {
            let t: Address = topic.into_val(&env);
            println!("{:?}", t);
        }

        let msg: String = event.2.into_val(&env);
        println!("{:?}", msg);
    }
}
