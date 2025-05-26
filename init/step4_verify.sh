#!/bin/bash

set -e

test .env

printf "\n Local .env \n -- \n"
printf "\n Ensure ARBITRAGE_APES_CONTRACT_BINDINGS ARBITRAGE_APES_LAUNCHTUBE_TOKEN is set correctly  \n"
printf "\n ------------------------- \n"
cat .env
printf "\n ------------------------- \n"
