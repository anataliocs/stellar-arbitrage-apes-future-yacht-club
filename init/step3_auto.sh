#!/bin/bash

set -e

clear

test .env
source .env

printf "\n Removing previously deployed contract backed up in .env.old \n"
sed -i ".env.old" '/^DEPLOYED_ARBITRAGE_APES_CONTRACT=.*$/d' .env

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
-- --owner $ARBITRAGE_APES_OWNER |tee contract-address.log | xargs -0 -I {} echo "DEPLOYED_ARBITRAGE_APES_CONTRACT={}" \
 |tee .env && source .env && \
echo "export DEPLOYED_ARBITRAGE_APES_CONTRACT=${DEPLOYED_ARBITRAGE_APES_CONTRACT}"
