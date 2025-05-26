#!/bin/bash

set -e

clear

test .env
source .env

printf "\n Executing Step 4 of the Setup and Build Process \n"
printf "\n ------------------------- \n"

if test -f ".env"; then
printf "\n Removing previous ARBITRAGE_APES_CONTRACT_BINDINGS and archiving to .env.old \n"
sed -i ".old" '/^ARBITRAGE_APES_CONTRACT_BINDINGS=.*$/d' .env

printf "\n Removing previous ARBITRAGE_APES_LAUNCHTUBE_TOKEN and archiving to .env.old \n"
sed -i ".old" '/^ARBITRAGE_APES_LAUNCHTUBE_TOKEN=.*$/d' .env

printf "\n Removing previous ARBITRAGE_APES_CLIENT_ROOT and archiving to .env.old \n"
sed -i ".old" '/^ARBITRAGE_APES_CLIENT_ROOT=.*$/d' .env

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

printf "\n Building and linking npm package using absolute path: %s \n" "$ARBITRAGE_APES_ROOT/$ARBITRAGE_APES_CONTRACT_BINDINGS"

source .env && pnpm link "$ARBITRAGE_APES_ROOT/$ARBITRAGE_APES_CONTRACT_BINDINGS" && pnpm install

printf "\n Generate and set Launchtube Token \n"
launchtube_token=$(curl https://testnet.launchtube.xyz/gen | jq '.[0]' | xargs echo -n)
echo "ARBITRAGE_APES_LAUNCHTUBE_TOKEN=$launchtube_token" >> .env

printf "\n Launchtube Token: %s \n" "$launchtube_token"

printf "\n Set client directory \n"
client_directory="$ARBITRAGE_APES_ROOT/client/apps/$ARBITRAGE_APES_ROOT/"
echo "ARBITRAGE_APES_CLIENT_ROOT=$client_directory" >> .env

printf "\n Contract bindings are typescript definitions you can use to interact with your contract \n"
printf "\n ------------------------- \n"

printf "\n ------------------------- \n"
cat $ARBITRAGE_APES_CONTRACT_BINDINGS/src/index.ts
printf "\n ------------------------- \n"


# Confirmation of Success

printf "\n Step 4 of Config Complete \n"
printf "\n ------------------------- \n"

printf "\n Current .env file: \n"

printf "\n ------------------------- \n"
cat .env
printf "\n ------------------------- \n"

printf "\n Old Config Archived in .env.old \n"
