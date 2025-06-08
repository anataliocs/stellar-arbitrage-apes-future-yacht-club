import {rpc} from "@stellar/stellar-sdk";
import dotenv from "dotenv";
import {getRpcServer , pollForTransactionCompletion , sign} from "./util/rpcServerFactory";
import {getDeployedContractId} from "./util/argumentProcessor";
import {Client , Contract as ArbitrageApesContract , networks} from "arbitrage-apes"

dotenv.config ();

const defaultPublicKey: string = "GA4EIXR7EWXN5SMRN36GE2BEDBYDPZ522DSTIGFGZW6KHA4NTEL6WGHM";

module.exports = (async function () {
    const publicKey: string = process.env.ARBITRAGE_APES_OWNER || defaultPublicKey;
    const rpcServer: rpc.Server = getRpcServer ();

    //@ts-ignore
    const contract = new ArbitrageApesContract (getDeployedContractId ());

    const contractClient = new Client ({
                                           allowHttp: true ,
                                           contractId: networks.testnet.contractId ,
                                           errorTypes: undefined ,
                                           networkPassphrase: networks.testnet.networkPassphrase ,
                                           publicKey: publicKey ,
                                           rpcUrl: rpcServer.serverURL ,
                                           signAuthEntry: undefined ,
                                           signTransaction: sign
                                       });

    const assembledTransaction = await contractClient
        .mint ({to: publicKey , token_id: 132} , {simulate: true , fee: 200_000});

    let signedTransaction =
        await assembledTransaction.signAndSend ();

    if (signedTransaction.sendTransactionResponse) {
        return await pollForTransactionCompletion (rpcServer , signedTransaction.sendTransactionResponse);
    }
    else {
        throw new Error ("Error while sending transaction");
    }

}) ().then (value => console.log (value))
     .catch (reason => console.log (reason))
     .finally (() => console.log ("use_contract_bindings.ts script complete \n"));
