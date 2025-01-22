"use client";
import { useState } from "react";
const { ethers } = require("ethers");

export const useEthereumWallet = () => {
    const [account, setAccount] = useState<string | null>(null);
    const [provider, setProvider] = useState<ethers.providers.Web3Provider | null>(null);

    const connectWallet = async () => {
        if (typeof window === "undefined") {
            console.error("This function must run in the browser.");
            return;
        }

        console.log("window.ethereum:", window.ethereum);
        console.log("window.ethereum methods:", Object.keys(window.ethereum));

        if (typeof window.ethereum === "undefined") {
            alert("MetaMask is not installed. Please install it and try again.");
            return;
        }

        try {
            const web3Provider = new ethers.providers.JsonRpcProvider("https://sepolia.infura.io/v3/ba0264bd03b041038e387e3c2033c199");
            const accounts = await web3Provider.request({ method: "eth_requestAccounts" });

            setAccount(accounts[0]);
            setProvider(web3Provider);
        } catch (error) {
            console.error("Failed to connect wallet:", error);
        }
    };


    const disconnectWallet = () => {
        setAccount(null);
        setProvider(null);
    };

    return { account, provider, connectWallet, disconnectWallet };
};
