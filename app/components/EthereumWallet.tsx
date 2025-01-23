"use client";

import { useState } from "react";
import { ethers } from "ethers";

const EthereumWallet = () => {
    const [account, setAccount] = useState<string | null>(null);
    const [balance, setBalance] = useState<string | null>(null);

    const connectEthereumWallet = async () => {
        if (!window.ethereum) {
            alert("MetaMask is not installed");
            return;
        }

        try {
            const provider = new ethers.BrowserProvider(window.ethereum);
            const signer = await provider.getSigner();
            const address = await signer.getAddress();
            const walletBalance = await provider.getBalance(address);

            setAccount(address);
            setBalance(ethers.formatEther(walletBalance));
        } catch (error) {
            console.error("Error connecting Ethereum wallet:", error);
            alert("Failed to connect Ethereum wallet.");
        }
    };

    return (
        <div className="space-y-4">
            <button
                onClick={connectEthereumWallet}
                className="w-full py-3 px-5 bg-highlight text-primary rounded-full hover:scale-105 hover:shadow-xl transition-transform duration-300"
            >
                {account ? "Connected to Ethereum" : "Connect Ethereum Wallet"}
            </button>

            {account && (
                <div className="text-sm text-accent">
                    <p>
                        <strong>Address:</strong> {account}
                    </p>
                    <p>
                        <strong>Balance:</strong> {balance} ETH
                    </p>
                </div>
            )}
        </div>
    );
};

export default EthereumWallet;
