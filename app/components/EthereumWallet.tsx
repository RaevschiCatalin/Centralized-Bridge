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

    const disconnectEthereumWallet = () => {
        setAccount(null);
        setBalance(null);
        alert("Disconnected from Ethereum Wallet");
    };

    return (
        <div className="space-y-6 text-center">

            <h1 className="text-3xl font-bold text-highlight">Ethereum Wallet</h1>

            {!account && (
                <button
                    onClick={connectEthereumWallet}
                    className="w-full py-3 px-5 bg-highlight text-primary rounded-full hover:scale-105 hover:shadow-xl transition-transform duration-300"
                >
                    Connect Ethereum Wallet
                </button>
            )}

            {account && (
                <div className="space-y-4">
                    <div className="text-sm text-accent">
                        <p>
                            <strong className="text-white">Address:</strong>{" "}
                            <span className="text-accent">{account}</span>
                        </p>
                        <p>
                            <strong className="text-accent">Balance:</strong>{" "}
                            <span className="text-white">{balance}</span>
                            <span className="text-yellow-400"> ETH</span>
                        </p>
                    </div>

                    {/* Disconnect Button */}
                    <button
                        onClick={disconnectEthereumWallet}
                        className="w-full py-3 px-5 bg-red-500 text-white rounded-full hover:scale-105 hover:shadow-xl transition-transform duration-300"
                    >
                        Disconnect Wallet
                    </button>
                </div>
            )}
        </div>
    );
};

export default EthereumWallet;
