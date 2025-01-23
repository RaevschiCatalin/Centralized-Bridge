"use client";

import { useEffect, useState } from "react";
import {  useCurrentAccount, useCurrentWallet } from "@mysten/dapp-kit";
import { ConnectButton } from "@mysten/dapp-kit";

const SuiWallet = () => {

    const currentAccount = useCurrentAccount() || {};
    const currentWallet = useCurrentWallet();


    const [balance, setBalance] = useState<string | null>(null);
    const [isLoading, setIsLoading] = useState(false);

    useEffect(() => {
        if (currentAccount) {
            // Simulate fetching balance or use actual API
            setIsLoading(true);
            setTimeout(() => {
                setBalance("100.5 SUI"); // Replace with real balance fetching logic
                setIsLoading(false);
            }, 1000);
        }
    }, [currentAccount]);
    console.log(currentAccount);
    return (
        <div className="space-y-6 max-w-xs mx-auto p-6 bg-gray-800 text-white rounded-lg shadow-xl">

            {/* Connect button */}

                <div className="flex justify-center">
                    <ConnectButton className="w-full py-3 px-5 bg-blue-500 text-white rounded-full hover:bg-blue-600 transition duration-200" />
                </div>



            {currentAccount && (
                <div className="space-y-4">
                    <div className="flex flex-col items-center">
                        <p className="text-xl font-semibold">Wallet Connected</p>
                        <p className="text-sm text-gray-400">Address:</p>
                        <p className="text-lg text-blue-300 truncate">{currentAccount.address}</p>
                    </div>

                    {/* Balance display */}
                    <div className="text-center">
                        <p className="text-sm text-gray-400">Balance:</p>
                        {isLoading ? (
                            <p className="text-xl font-semibold text-gray-500">Loading...</p>
                        ) : (
                            <p className="text-xl font-semibold text-green-400">{balance}</p>
                        )}
                    </div>

                    {/* Wallet name */}
                    <div className="text-center mt-4">
                        <p className="text-sm text-gray-400">Connected Wallet:</p>
                        <p className="text-lg text-blue-200">{currentWallet?.name || "Unknown"}</p>
                    </div>
                </div>
            )}

            {/* Message if no account is connected */}
            {!currentAccount && (
                <p className="text-center text-red-500 text-sm">Please connect your wallet to see your balance.</p>
            )}
        </div>
    );
};

export default SuiWallet;
