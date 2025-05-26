#!/bin/bash

set -e

source .env

printf "\n Executing Step 3 of the Setup and Build Process \n"
printf "\n ------------------------- \n"

if test -f ".env"; then
printf "\n Removing previous DEPLOYED_ARBITRAGE_APES_CONTRACT and archiving to .env.old \n"
sed -i ".old" '/^DEPLOYED_ARBITRAGE_APES_CONTRACT=.*$/d' .env

printf "\n Removing previous DEPLOYED_ARBITRAGE_APES_META_BASE_URI and archiving to .env.old \n"
sed -i ".old" '/^DEPLOYED_ARBITRAGE_APES_META_BASE_URI=.*$/d' .env

printf "\n Removing previous DEPLOYED_ARBITRAGE_APES_META_NAME and archiving to .env.old \n"
sed -i ".old" '/^DEPLOYED_ARBITRAGE_APES_META_NAME=.*$/d' .env

printf "\n Removing previous DEPLOYED_ARBITRAGE_APES_META_SYMBOL and archiving to .env.old \n"
sed -i ".old" '/^DEPLOYED_ARBITRAGE_APES_META_SYMBOL=.*$/d' .env

else
  touch .env
fi

default_contract_meta_base_uri="www.stellar-arbitrage-apes.xyz"
default_contract_meta_name="Stellar Arbitrage Ape Yacht Club"
default_contract_meta_symbol="SAAYC"

printf "\n Exporting DEPLOYED_ARBITRAGE_APES_META_BASE_URI to .env var \n"
echo "DEPLOYED_ARBITRAGE_APES_META_BASE_URI=$default_contract_meta_base_uri" >> .env

printf "\n Exporting DEPLOYED_ARBITRAGE_APES_META_NAME to .env var \n"
echo "DEPLOYED_ARBITRAGE_APES_META_NAME=$default_contract_meta_name" >> .env

printf "\n Exporting DEPLOYED_ARBITRAGE_APES_META_SYMBOL to .env var \n"
echo "DEPLOYED_ARBITRAGE_APES_META_SYMBOL=$default_contract_meta_symbol" >> .env

source .env

deploy_command="source .env && stellar contract deploy --alias arbitrage-apes-contract  \
--wasm target/wasm32v1-none/release/arbitrage_apes.wasm \
--source $SOURCE_ACCOUNT_CLI_NAME \
--network testnet \
-- --owner $ARBITRAGE_APES_OWNER \
-- --base_uri $DEPLOYED_ARBITRAGE_APES_META_BASE_URI \
-- --name $DEPLOYED_ARBITRAGE_APES_META_NAME \
-- --symbol $DEPLOYED_ARBITRAGE_APES_META_SYMBOL"

printf "\n Executing command: %s \n" "$deploy_command"

source .env && stellar contract deploy --alias arbitrage-apes-contract  \
--wasm target/wasm32v1-none/release/arbitrage_apes.wasm \
--source "$SOURCE_ACCOUNT_CLI_NAME" \
--network testnet \
-- --owner "$ARBITRAGE_APES_OWNER" \
-- --base_uri "$DEPLOYED_ARBITRAGE_APES_META_BASE_URI" \
-- --name "$DEPLOYED_ARBITRAGE_APES_META_NAME" \
-- --symbol "$DEPLOYED_ARBITRAGE_APES_META_SYMBOL"|tee contract-address.log

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

source .env
