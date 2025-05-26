#!/bin/bash

set -e

test .env

printf "\n Local .env \n -- \n"
printf "\n Ensure DEPLOYED_ARBITRAGE_APES_CONTRACT DEPLOYED_ARBITRAGE_APES_CONTRACT DEPLOYED_ARBITRAGE_APES_META_NAME DEPLOYED_ARBITRAGE_APES_META_SYMBOL are set correctly  \n"
printf "\n ------------------------- \n"
cat .env
printf "\n ------------------------- \n"

