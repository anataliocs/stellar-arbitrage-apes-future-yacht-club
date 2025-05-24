#!/bin/zsh
set -e

clear

echo "Snapchain Vanilla JS chosen!"

if [ -d smart-stellar-demo-reactjs-nextjs ] ; then
 rm -rf smart-stellar-demo-reactjs-nextjs
fi

if [ -d smart-stellar-demo-astro-svelte ] ; then
 rm -rf smart-stellar-demo-astro-svelte
fi

if [ -d snapchain-vanillajs ] ; then
cp "${CODESPACE_VSCODE_FOLDER}"/snapchain-vanillajs/.env.example "${CODESPACE_VSCODE_FOLDER}/.env.base"   
cp -R "${CODESPACE_VSCODE_FOLDER}"/snapchain-vanillajs/* "${CODESPACE_VSCODE_FOLDER}"
rm -rf snapchain-vanillajs
rm -rf scripts
rm choose-front-end-framework.md
fi

echo "Now open the README and follow the steps"
echo ""
echo "Start client"
echo "pnpm install"
echo "pnpm dev"
echo ""
echo "Make port 5173 public"
echo "gh codespace ports visibility --codespace ${CODESPACE_NAME} 80:public 5173:public 3000:public 8080:public"

echo "Setting Launchtube token for testnet:"
echo "Replace {LT_JWT_PLACEHOLDER} with Launchtube LT JWT TOKEN"
launchtube_token=$(curl https://testnet.launchtube.xyz/gen | jq '.[0]') \
 && sed "s/{LT_JWT_PLACEHOLDER}/${launchtube_token}/g" .env.base > .env





