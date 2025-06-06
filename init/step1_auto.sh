#!/bin/bash

set -e

printf "\n Executing Step 1 of the Setup and Build Process \n"
printf "\n ------------------------- \n"

printf "\n This script is repeatable and reusable to run through this setup process again \n"
printf "\n Each execution will give you a unique configuration \n"

printf "\n ------------------------- \n"

if test -f ".env"; then
printf "\n Removing previous SOURCE_ACCOUNT_CLI_NAME and archiving to .env.old \n"
sed -i ".old" '/^SOURCE_ACCOUNT_CLI_NAME=.*$/d' .env

printf "\n Removing previous ARBITRAGE_APES_CONTRACT_NAME and archiving to .env.old \n"
sed -i ".old" '/^ARBITRAGE_APES_CONTRACT_NAME=.*$/d' .env

printf "\n Removing previous TESTNET_RPC_URL and archiving to .env.old \n"
sed -i ".old" '/^TESTNET_RPC_URL=.*$/d' .env

printf "\n Removing previous TESTNET_NETWORK_PASSPHRASE and archiving to .env.old \n"
sed -i ".old" '/^TESTNET_NETWORK_PASSPHRASE=.*$/d' .env

printf "\n Removing previous ARBITRAGE_APES_ROOT and archiving to .env.old \n"
sed -i ".old" '/^ARBITRAGE_APES_ROOT=.*$/d' .env

else
  touch .env
fi

project_root="$PWD"

default_contract_name="arbitrage-apes"

default_rpc="https://soroban-testnet.stellar.org"

default_network_passphrase='"Test SDF Network ; September 2015"'

account_suffix=$(date +%s%N)

default_source_account="arbitrage-contract-owner-admin-new-$account_suffix"

printf "\n Generated name for default_source_account: %s \n" "$default_source_account"

printf "\n Executing:  stellar network use testnet \n"
stellar network use testnet

printf "\n Executing:  stellar keys generate --global %s --network testnet --fund \n" "$default_source_account"
stellar keys generate --global $default_source_account --network testnet --fund

printf "\n Executing:  stellar keys use %s \n" "$default_source_account"
stellar keys use $default_source_account

printf "\n Executing:  stellar keys address %s \n" "$default_source_account"
stellar keys address $default_source_account

stellar keys address $default_source_account | xargs -0 -I {} echo "ARBITRAGE_APES_OWNER={}" |tee .env && source .env

printf "\n Detected project root: %s \n" "$project_root"

printf "\n Setting Project Root in .env \n Executing command: %s \n" \
    "echo 'ARBITRAGE_APES_ROOT=$project_root' >> .env"
echo "export ARBITRAGE_APES_ROOT=$project_root"
echo "ARBITRAGE_APES_ROOT=$project_root" >> .env

printf "\n Exporting %s \n" "ARBITRAGE_APES_OWNER"
echo "export ARBITRAGE_APES_OWNER=${ARBITRAGE_APES_OWNER}"

printf "\n Exporting %s \n" "SOURCE_ACCOUNT_CLI_NAME"
echo SOURCE_ACCOUNT_CLI_NAME=$default_source_account >> .env
echo "export SOURCE_ACCOUNT_CLI_NAME=$default_source_account"

printf "\n Exporting %s \n" "ARBITRAGE_APES_CONTRACT_NAME"
echo "export ARBITRAGE_APES_CONTRACT_NAME=$default_contract_name"
echo ARBITRAGE_APES_CONTRACT_NAME=$default_contract_name >> .env

printf "\n Exporting %s \n" "TESTNET_RPC_URL"
echo "export TESTNET_RPC_URL=$default_rpc"
echo TESTNET_RPC_URL=$default_rpc >> .env

printf "\n Exporting %s \n" "TESTNET_NETWORK_PASSPHRASE"
echo "export TESTNET_NETWORK_PASSPHRASE=$default_network_passphrase"
echo TESTNET_NETWORK_PASSPHRASE=$default_network_passphrase >> .env

printf "\n Step 1 of Config Complete \n"
printf "\n ------------------------- \n"

printf "\n Generated .env file: \n"
printf "\n ------------------------- \n"
cat .env
printf "\n ------------------------- \n"

printf "\n Old Config Archived in .env.old \n"

source .env
