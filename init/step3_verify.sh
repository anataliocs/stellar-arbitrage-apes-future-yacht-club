#!/bin/bash

set -e

clear

test .env

printf "\n Local .env \n -- \n"
printf "\n Ensure DEPLOYED_ARBITRAGE_APES_CONTRACT is set correctly  \n"
printf "\n ------------------------- \n"
cat .env
printf "\n ------------------------- \n"

