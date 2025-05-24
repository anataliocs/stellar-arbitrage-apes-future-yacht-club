#!/bin/zsh
set -e

clear

echo "Stellar Demo Astro Svelte Chosen!"

if [ -d smart-stellar-demo-reactjs-nextjs ] ; then
 rm -rf smart-stellar-demo-reactjs-nextjs
fi

if [ -d snapchain-vanillajs  ] ; then
 rm -rf snapchain-vanillajs
fi

if [ -d smart-stellar-demo-astro-svelte ] ; then
cp "${CODESPACE_VSCODE_FOLDER}"/smart-stellar-demo-astro-svelte/.env.development "${CODESPACE_VSCODE_FOLDER}/.env"   
cp -R "${CODESPACE_VSCODE_FOLDER}"/smart-stellar-demo-astro-svelte/* "${CODESPACE_VSCODE_FOLDER}"
rm -rf smart-stellar-demo-astro-svelte
rm -rf scripts
rm choose-front-end-framework.md
fi

echo "Now open the README and follow the steps"
echo "Start client"
echo "pnpm install"
echo "pnpm dev"
echo ""
echo "Make port 5173 public"
echo "gh codespace ports visibility --codespace ${CODESPACE_NAME} 80:public 5173:public 3000:public 8080:public"




