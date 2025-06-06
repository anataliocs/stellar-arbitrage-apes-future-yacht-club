#!/bin/bash

set -e

test .env

printf "\n Local .env \n -- \n"
printf "\n Ensure ARBITRAGE_APES_ROOT ARBITRAGE_APES_OWNER SOURCE_ACCOUNT_CLI_NAME and ARBITRAGE_APES_CONTRACT_NAME TESTNET_RPC_URL TESTNET_NETWORK_PASSPHRASE are set correctly  \n"
printf "\n ------------------------- \n"
cat .env
printf "\n ------------------------- \n"

printf "\n Stellar ENV: \n -- \n"
printf "\n Ensure your SOURCE_ACCOUNT_CLI_NAME is listed as STELLAR_ACCOUNT and STELLAR_NETWORK is set to testnet \n"
printf "\n ------------------------- \n"
stellar env
printf "\n ------------------------- \n"

printf "\n Stellar Accounts \n -- \n"
printf "\n Ensure your SOURCE_ACCOUNT_CLI_NAME is created \n"
printf "\n ------------------------- \n"
stellar keys ls
printf "\n ------------------------- \n"
