#!/bin/bash

set -e

clear

printf "\n This script is repeatedable and reusable to run through this setup process again \n"
printf "\n Each execution will give you a unique configuration \n"

if test -f "../.env"; then
  rm ../.env
else
  touch ../.env
fi

default_contract_name="arbitrage-apes"

account_suffix=$(date +%s%N)

default_source_account="arbitrage-contract-owner-admin-new-$account_suffix"

printf "\n Generated name for default_source_account: %s \n" "$default_source_account"

printf "\n Deploying contract to testnet \n"

printf "\n Executing:  stellar network use testnet \n"
stellar network use testnet

printf "\n Executing:  stellar keys generate --global %s --network testnet --fund \n" "$default_source_account"
stellar keys generate --global $default_source_account --network testnet --fund

printf "\n Executing:  stellar keys use %s \n" "$default_source_account"
stellar keys use $default_source_account

printf "\n Executing:  stellar keys address %s \n" "$default_source_account"
stellar keys address $default_source_account

printf "\n Executing:  stellar keys address %s \n" "$default_source_account"
stellar keys address $default_source_account | xargs -0 -I {} echo "ARBITRAGE_APES_OWNER={}" |tee .env && source .env

printf "\n Exporting .env vars \n"
echo "export ARBITRAGE_APES_OWNER=${ARBITRAGE_APES_OWNER}" && \
echo SOURCE_ACCOUNT_CLI_NAME=$default_source_account >> .env && echo "export
SOURCE_ACCOUNT_CLI_NAME=$default_source_account" && \
echo "export ARBITRAGE_APES_CONTRACT_NAME=$default_contract_name" && echo \
ARBITRAGE_APES_CONTRACT_NAME=$default_contract_name >> .env
