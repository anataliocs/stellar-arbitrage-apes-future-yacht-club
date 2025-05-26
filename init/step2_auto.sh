#!/bin/bash

set -e

clear

printf "\n Executing Step 2 of the Setup and Build Process \n"
printf "\n ------------------------- \n"

if test -f ".env"; then
printf "\n Removing previous ARBITRAGE_APES_WASM and archiving to .env.old \n"
sed -i ".old" '/^ARBITRAGE_APES_WASM=.*$/d' .env

printf "\n Removing previous ARBITRAGE_APES_WASM_HASH and archiving to .env.old \n"
sed -i ".old" '/^ARBITRAGE_APES_WASM_HASH=.*$/d' .env

else
  touch .env
fi

printf "\n Building contract for testnet \n"

printf "\n Executing: %s  \n" "stellar contract build --verbose --profile release"

# Print to terminal output AND capture to log file
stellar contract build --verbose --profile release 2>&1 |tee contract-build.log

build_wasm=$(grep -iF 'Wasm File:' contract-build.log | sed 's/Wasm File\:[[:space:]]//g' | xargs echo -n)

printf "\n Contract WASM path: %s \n" "$build_wasm"

printf "\n Exporting ARBITRAGE_APES_WASM to .env var \n"
echo "ARBITRAGE_APES_WASM=$build_wasm" >> .env

wasm_hash=$(grep -iF 'Wasm Hash:' contract-build.log | sed 's/Wasm Hash\:[[:space:]]//g' | xargs echo -n)

printf "\n Contract WASM hash: %s \n" "$wasm_hash"

printf "\n Exporting ARBITRAGE_APES_WASM_HASH to .env var \n"
echo "ARBITRAGE_APES_WASM_HASH=$wasm_hash" >> .env

# Confirmation of Success

printf "\n Step 2 of Config Complete \n"
printf "\n ------------------------- \n"

printf "\n Current .env file: \n"

printf "\n ------------------------- \n"
cat .env
printf "\n ------------------------- \n"

printf "\n Old Config Archived in .env.old \n"

