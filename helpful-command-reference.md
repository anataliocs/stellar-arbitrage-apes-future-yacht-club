**Get new launchtube token**
```text
curl https://testnet.launchtube.xyz/gen | jq '.[0]'
```

Stellar Lab(cmd+click) 🔗 https://lab.stellar.org/"

**Discord Support:**  https://discord.gg/stellardev
[Stella: AI chat bot for Stellar dev questions](https://discord.com/channels/897514728459468821/1265827786111586344)

**CLI GitHub AI Copilot**
```
gh copilot --help
```

# Stellar CLI
Stellar CLI Manual: https://developers.stellar.org/docs/tools/cli/stellar-cli
Full help docs Stellar CLI: https://github.com/stellar/soroban-examples/blob/main/FULL_HELP_DOCS.md

**Create and fund account:**
```
stellar keys generate --global alice --network testnet --fund
```

**Display public key:**
```
stellar keys address alice
```

---
# Github Codespaces
Github CLI:  https://cli.github.com/manual/

**View Codespace Info:**
Print out this info for support!

```text
gh codespace view --codespace ${CODESPACE_NAME} 
```

**Restart devcontainer:**
```text
gh codespace rebuild --codespace ${CODESPACE_NAME}
```

**Access Helpful scripts gist(We'll be actively adding to this)**
```text
gh gist view f86099edb625f61b9f012e5286abb2ee -w
```