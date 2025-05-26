#!/bin/bash

set -e

printf "\n Remove previously deployed contract"
printf "\n Execute command: %s \n" "sed -i '.env.old' '/^DEPLOYED_ARBITRAGE_APES_CONTRACT=.*/d' .env"

deploy_command="stellar contract deploy --alias arbitrage-apes-contract  \
--wasm target/wasm32v1-none/release/arbitrage_apes.wasm \
--source $SOURCE_ACCOUNT_CLI_NAME \
--network testnet \
-- --owner $ARBITRAGE_APES_OWNER"

printf "\n Execute command: %s \n" "$deploy_command"

printf "\n Setup Env Vars \n --- \n"

printf "\n Execute: %s \n" "echo DEPLOYED_ARBITRAGE_APES_CONTRACT={} >> .env" \
" && source .env && echo 'export SOURCE_ACCOUNT_CLI_NAME=arbitrage-contract-owner-admin'"

printf "\n Execute: %s \n" "echo DEPLOYED_ARBITRAGE_APES_CONTRACT={} >> .env" \
" && source .env && echo 'export SOURCE_ACCOUNT_CLI_NAME=arbitrage-contract-owner-admin'"

printf "\n Execute: %s \n" "echo 'export DEPLOYED_ARBITRAGE_APES_CONTRACT=<new contract deploy hash>'""
