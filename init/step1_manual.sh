#!/bin/bash

set -e

default_source_account="arbitrage-contract-owner-admin-new"

printf "\n To Deploy contract to testnet \n --- \n"

printf "\n Execute:  stellar network use testnet \n"

printf "\n Execute:  stellar keys generate --global %s --network testnet --fund \n" "$default_source_account"

printf "\n Execute:  stellar keys use %s \n" "$default_source_account"

printf "\n Execute:  stellar keys address %s \n" "$default_source_account"

printf "\n Execute: echo 'ARBITRAGE_APES_OWNER=%s' |tee .env && source .env" "<Enter the owner public key here>"

printf "\n Execute: echo export ARBITRAGE_APES_OWNER=%s \n " "<Enter the owner public key here>"

printf "\n Setup Env Vars \n --- \n"

printf "\n Execute: %s %s \n" "echo SOURCE_ACCOUNT_CLI_NAME=arbitrage-contract-owner-admin >>" \
".env && echo 'export SOURCE_ACCOUNT_CLI_NAME=arbitrage-contract-owner-admin'"

printf "\n %s %s' \n" "echo 'export ARBITRAGE_APES_CONTRACT_NAME=arbitrage-apes'" "&& echo ARBITRAGE_APES_CONTRACT_NAME=arbitrage-apes >> .env"


