#![cfg(test)]

use super::*;
use soroban_sdk::{testutils::{Address as _, EnvTestConfig}, Address, Env, String};

#[test]
fn test() {
    let mut env = Env::default();
    env.set_config(EnvTestConfig { capture_snapshot_at_drop: false });
    env.mock_all_auths();

    let contract_address = env.register(Contract, ());
    let client = ContractClient::new(&env, &contract_address);

    let author0 = Address::generate(&env);
    let author1 = Address::generate(&env);
    let author2 = Address::generate(&env);
    let msg0 = String::from_str(&env, "Dear Sir or Madam");
    let msg1 = String::from_str(&env, "We have been trying to reach you about your car's extended warranty");
    let msg2 = String::from_str(&env, "straight to voicemail");

    env.as_contract(&contract_address, || {
        assert!(env.storage().instance().get::<_, u32>(&INDEX).is_none());
    });
    client.send(&author0, &msg0);
    env.as_contract(&contract_address, || {
        assert_eq!(env.storage().instance().get::<_, u32>(&INDEX).unwrap(), 1);
        assert_eq!(env.storage().temporary().get::<_, ChatMessage>(&Storage::Chat(0)).unwrap().message, msg0);
    });

    client.send(&author1, &msg1);
    env.as_contract(&contract_address, || {
        assert_eq!(env.storage().instance().get::<_, u32>(&INDEX).unwrap(), 2);
        assert_eq!(env.storage().temporary().get::<_, ChatMessage>(&Storage::Chat(1)).unwrap().message, msg1);
    });
    client.send(&author2, &msg2);
    env.as_contract(&contract_address, || {
        assert_eq!(env.storage().instance().get::<_, u32>(&INDEX).unwrap(), 3);
        assert_eq!(env.storage().temporary().get::<_, ChatMessage>(&Storage::Chat(2)).unwrap().message, msg2);
    });
}
