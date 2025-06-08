import {Keypair} from "@stellar/stellar-sdk";

const DEFAULT_CONTRACT_ID: string = "CD5WI7MYIBSNS5742RG77JQQPRYSJUJ4DNXIPWS4DU2HMOGLSQ2E55XJ";
const DEFAULT_TESTNET_SIGNER = Keypair.fromSecret ("SBMA7K5E3GGPY5K2F3B4HIRRLTV64YLFQIL4CUMSLU6NCJ6NSKLPAWHL");

export function getDeployedContractId (): string {
    if (!process.argv[2]) {
        console.error (`You must provide a contractId as a parameter \n`);
        return DEFAULT_CONTRACT_ID;
    }

    return process.argv[2];
}

export function getSourceKeypair (): Keypair {
    if (!process.argv[3]) {
        console.error (`You must provide a sourceKeypair as a parameter \n`);
        return DEFAULT_TESTNET_SIGNER;
    }

    return Keypair.fromSecret (process.argv[3]);
}
