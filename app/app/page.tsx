"use client";

import EthereumWallet from "@/components/EthereumWallet";
import SuiWallet from "@/components/SuiWallet";
import BridgeComponent from "@/components/BridgeComponent";

export default function AuthPage() {
    return (
        <div className="min-h-screen flex flex-col items-center justify-center bg-primary text-text space-y-12">

            <div className="p-12 space-y-8 text-center bg-secondary rounded-lg shadow-xl max-w-fit">
                <h1 className="text-4xl font-bold text-yellow-400">
                    Authenticate Your Wallet
                </h1>
                <p className="text-md text-accent">
                    Select your wallet to connect to the decentralized world.
                </p>

                <div className="flex space-x-10 justify-center">
                    <div className="w-fit p-6 bg-secondary-light rounded-lg shadow-lg">
                        <EthereumWallet />
                    </div>
                    <div className="w-fit p-6 bg-secondary-light rounded-lg shadow-lg">
                        <SuiWallet />
                    </div>
                </div>
            </div>

            <div className="p-12 bg-secondary rounded-lg shadow-xl max-w-4xl w-full text-center">
                <h2 className="text-3xl font-semibold text-highlight mb-6">
                    Bridge Your Tokens
                </h2>
                <p className="text-accent mb-8">
                    Transfer tokens seamlessly between Ethereum and Sui networks.
                </p>
                <BridgeComponent />
            </div>
        </div>
    );
}
