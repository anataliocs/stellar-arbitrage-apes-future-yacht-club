#!/bin/bash

set -e

clear

test .env

printf "\n Local .env \n -- \n"
printf "\n Ensure ARBITRAGE_APES_WASM ARBITRAGE_APES_WASM_HASH are set correctly  \n"
printf "\n ------------------------- \n"
cat .env
printf "\n ------------------------- \n"

