#!/bin/bash

set -e

clear

generate_bindings="source .env && stellar contract bindings typescript \
--network testnet \
--id $DEPLOYED_ARBITRAGE_APES_CONTRACT \
--output-dir ./packages/$ARBITRAGE_APES_CONTRACT_NAME \
--overwrite"

printf "\n Execute command: %s \n" "$generate_bindings"

printf "\n Setup Env Vars \n --- \n"

printf "\n Execute: %s \n" "echo ARBITRAGE_APES_CONTRACT_BINDINGS=<ABSOLUTE PATH TO BINDINGS> >> .env"
printf "\n Example: %s \n" "echo ARBITRAGE_APES_CONTRACT_BINDINGS=/Users/chris.anatalio/projects/stellar-arbitrage-apes-future-yacht-club/client//Users/chris.anatalio/projects/stellar-arbitrage-apes-future-yacht-club/ >> .env"

printf "\n Execute: %s \n" "curl https://testnet.launchtube.xyz/gen | jq '.[0]' | xargs echo -n"
printf "\n Execute: %s \n" "echo ARBITRAGE_APES_LAUNCHTUBE_TOKEN=<TOKEN GOES HERE FROM PREVIOUS COMMAND> >> .env"


