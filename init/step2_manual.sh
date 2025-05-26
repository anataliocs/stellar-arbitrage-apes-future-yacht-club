#!/bin/bash

set -e

printf "\n Execute: %s  \n" "stellar contract build --verbose --profile release"

printf "\n Execute: %s  \n" "echo 'ARBITRAGE_APES_WASM=<COPY BUILD WASM HERE>' >> .env"

printf "\n Execute: %s  \n" "stellar contract build --verbose --profile release" "echo 'ARBITRAGE_APES_WASM=<COPY
BUILD WASM HERE>' >> .env"

printf "\n Excute: %s \n" "echo 'ARBITRAGE_APES_WASM_HASH=$wasm_hash' >> .env"
