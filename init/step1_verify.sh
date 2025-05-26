#!/bin/bash

set -e

clear

test .env

printf "\n Local .env \n -- \n"
cat .env

printf "\n Stellar ENV: \n -- \n"
stellar env

printf "\n Stellar Accounts \n -- \n"
stellar keys ls
