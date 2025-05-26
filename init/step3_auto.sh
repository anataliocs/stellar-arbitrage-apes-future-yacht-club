#!/bin/bash

set -e

clear

test .env
source .env

printf "\n Executing Step 3 of the Setup and Build Process \n"
printf "\n ------------------------- \n"

if test -f ".env"; then
printf "\n Removing previous DEPLOYED_ARBITRAGE_APES_CONTRACT and archiving to .env.old \n"
sed -i ".old" '/^DEPLOYED_ARBITRAGE_APES_CONTRACT=.*$/d' .env

else
  touch .env
fi

deploy_command="stellar contract deploy --alias arbitrage-apes-contract  \
--wasm target/wasm32v1-none/release/arbitrage_apes.wasm \
--source $SOURCE_ACCOUNT_CLI_NAME \
--network testnet \
-- --owner $ARBITRAGE_APES_OWNER"

printf "\n Executing command: %s \n" "$deploy_command"

source .env && stellar contract deploy --alias arbitrage-apes-contract  \
--wasm target/wasm32v1-none/release/arbitrage_apes.wasm \
--source $SOURCE_ACCOUNT_CLI_NAME \
--network testnet \
-- --owner $ARBITRAGE_APES_OWNER |tee contract-address.log

deployed_contract=$(cat contract-address.log)

printf "\n Contract address: %s \n" "$deployed_contract"

printf "\n Exporting DEPLOYED_ARBITRAGE_APES_CONTRACT to .env var \n"
echo "DEPLOYED_ARBITRAGE_APES_CONTRACT=$deployed_contract" >> .env

# Confirmation of Success

printf "\n Step 3 of Config Complete \n"
printf "\n ------------------------- \n"

printf "\n Current .env file: \n"

printf "\n ------------------------- \n"
cat .env
printf "\n ------------------------- \n"

printf "\n Old Config Archived in .env.old \n"
