import {Networks , Operation , rpc , TransactionBuilder , xdr} from "@stellar/stellar-sdk";
import {
    type WalletError
} from "@stellar/stellar-sdk/contract";
import {Api} from "@stellar/stellar-sdk/rpc";
import dotenv from "dotenv";
import {getSourceKeypair} from "./argumentProcessor";
import GetTransactionResponse = Api.GetTransactionResponse;
import SendTransactionResponse = Api.SendTransactionResponse;

export const NETWORK_PASSPHRASE = Networks.TESTNET;
export const fee = "200100"; // Base fee plus resource fee

export async function getAssembledSignedTransaction (sorobanData: xdr.SorobanTransactionData ,
                                                     rpcServer: rpc.Server ,
                                                     operation: xdr.Operation<Operation.ExtendFootprintTTL> |
                                                                xdr.Operation<Operation.RestoreFootprint> |
                                                                xdr.Operation<Operation.InvokeHostFunction>) {

    let account =
        await rpcServer.getAccount (getSourceKeypair ().publicKey ());

    const transaction =
        new TransactionBuilder (account , {
            fee ,
            networkPassphrase: NETWORK_PASSPHRASE ,
        })
            .setSorobanData (sorobanData)
            .addOperation (
                operation ,
            )
            .setTimeout (30)
            .build ();

    // Simulate and assemble transaction
    const ttlSimResponse: rpc.Api.SimulateTransactionResponse =
        await rpcServer.simulateTransaction (transaction);
    const assembledTransaction =
        rpc.assembleTransaction (transaction , ttlSimResponse)
           .build ();

    // Sign assembled transaction
    assembledTransaction.sign (getSourceKeypair ());
    return assembledTransaction;
}

export function getRpcServer (): rpc.Server {
    dotenv.config ();
    let defaultRpcUrl: string = "https://soroban-testnet.stellar.org";
    const RPC_SERVER_URL: string = process.env.RPC_SERVER_URL || defaultRpcUrl;
    console.log ("Using RPC Server URL: " + RPC_SERVER_URL);

    const rpcServer = new rpc.Server (RPC_SERVER_URL , {
        allowHttp: true ,
        timeout: 30 ,
    });

    rpcServer.getHealth ()
             .then (rpcServer => {
                 console.log ("RPC Server Status:" + rpcServer.status);
             });

    return rpcServer;
}

export type Signed = {
                         signedTxXdr: string;
                         signerAddress?: string | undefined;
                     } & {
                         error?: WalletError | undefined;
                     };

export async function sign (
    xdr: string ,
    options?: {}
): Promise<Signed> {

    console.log (xdr);
    console.log (options);
    //TODO default signer

    return new Promise<Signed> ((resolve) => {
        console.log (resolve);
    });
}

export async function pollForTransactionCompletion (rpcServer: rpc.Server ,
                                                    result: SendTransactionResponse) {

    return rpcServer.pollTransaction (result.hash , {
        attempts: 10 ,
        sleepStrategy: rpc.LinearSleepStrategy
    }).then ((finalStatus: GetTransactionResponse) => {
                 if (finalStatus && finalStatus.status) {

                     switch (finalStatus.status) {
                         case rpc.Api.GetTransactionStatus.FAILED:
                             console.log (finalStatus.status);
                             break;
                         case rpc.Api.GetTransactionStatus.NOT_FOUND:
                             console.log ("Waiting... " , finalStatus.txHash , " " , finalStatus.status);
                             break;
                         case rpc.Api.GetTransactionStatus.SUCCESS: {

                             if (finalStatus.resultMetaXdr && finalStatus.resultMetaXdr.v3 () && finalStatus.resultMetaXdr.v3 ().operations ()
                                 && finalStatus.resultMetaXdr.v3 ().operations ().at (0) &&
                                 finalStatus.resultMetaXdr.v3 ().operations ().at (0)) {
                                 console.log ("\n Operation Meta: \n" ,
                                              finalStatus
                                                  .resultMetaXdr.v3 ().operations ().at (0) , "\n");
                             }

                             console.log ("Result: \n" ,
                                          finalStatus.resultXdr.toXDR ("base64") , "\n");

                             return finalStatus.status;
                         }
                     }
                 }
                 else {
                     throw new Error ("GetTransactionResponse status not defined");
                 }
             }
    ).catch (reason => console.log (reason));
}