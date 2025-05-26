#!/bin/bash

set -e

clear

test .env
source .env

printf "\n Executing Step 3 of the Setup and Build Process \n"
printf "\n ------------------------- \n"

if test -f ".env"; then
printf "\n Removing previous ARBITRAGE_APES_CONTRACT_BINDINGS and archiving to .env.old \n"
sed -i ".old" '/^ARBITRAGE_APES_CONTRACT_BINDINGS=.*$/d' .env

else
  touch .env
fi

generate_bindings="source .env && stellar contract bindings typescript \
--network testnet \
--id $DEPLOYED_ARBITRAGE_APES_CONTRACT \
--output-dir ./packages/$ARBITRAGE_APES_CONTRACT_NAME \
--overwrite"

printf "\n Executing command: %s \n" "$generate_bindings"

source .env && stellar contract bindings typescript \
--network testnet \
--id $DEPLOYED_ARBITRAGE_APES_CONTRACT \
--output-dir ./packages/$ARBITRAGE_APES_CONTRACT_NAME \
--overwrite

bindings_path="packages/$ARBITRAGE_APES_CONTRACT_NAME"

printf "\n Contract bindings package: %s \n" "$bindings_path"

printf "\n Exporting ARBITRAGE_APES_CONTRACT_BINDINGS to .env var \n"
echo "ARBITRAGE_APES_CONTRACT_BINDINGS=$bindings_path" >> .env

printf "\n Building npm package: %s \n" "$bindings_path"

source .env && pnpm link "$ARBITRAGE_APES_ROOT/$ARBITRAGE_APES_CONTRACT_BINDINGS"

# Confirmation of Success

printf "\n Step 4 of Config Complete \n"
printf "\n ------------------------- \n"

printf "\n Current .env file: \n"

printf "\n ------------------------- \n"
cat .env
printf "\n ------------------------- \n"

printf "\n Old Config Archived in .env.old \n"
