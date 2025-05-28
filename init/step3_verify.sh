#!/bin/bash

set -e

test .env

printf "\n Local .env \n -- \n"
printf "\n Ensure DEPLOYED_ARBITRAGE_APES_CONTRACT are set correctly  \n"
printf "\n ------------------------- \n"
cat .env
printf "\n ------------------------- \n"

