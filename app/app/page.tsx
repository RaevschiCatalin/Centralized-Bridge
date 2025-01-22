"use client";
// import { useState } from "react";
// import { connectEthereumWallet} from "@/lib/wallet";

import EthereumWallet from "@/components/EthereumWallet";

export default function AuthPage() {
  // const [wallet, setWallet] = useState<string | null>(null);

  // const handleEthereumConnect = async () => {
  //   try {
  //     const signer = await connectEthereumWallet();
  //     const address = await signer.getAddress();
  //     setWallet(`Connected to Ethereum: ${address}`);
  //   } catch (error) {
  //     alert(error.message);
  //   }
  // };

  // const handleSuiConnect = async () => {
  //   try {
  //     const wallet = await connectSuiWallet();
  //     setWallet("Connected to Sui Wallet");
  //   } catch (error) {
  //     alert(error.message);
  //   }
  // };

  return (
      <div className="min-h-screen flex items-center justify-center bg-primary text-text">
        <div className="p-8 space-y-6 text-center bg-secondary rounded-lg shadow-xl max-w-md">
          <h1 className="text-2xl font-semibold text-highlight">
            Authenticate Your Wallet
          </h1>
          <p className="text-sm text-accent">
            Select your wallet to connect to the decentralized world.
          </p>
          <button
              // onClick={handleEthereumConnect}
              className="w-full py-3 px-5 bg-highlight text-primary rounded-lg hover:bg-accent transition duration-300"
          >
            Connect Ethereum Wallet
          </button>
          <button
              // onClick={handleSuiConnect}
              className="w-full py-3 px-5 bg-accent text-primary rounded-lg hover:bg-highlight transition duration-300"
          >
            Connect Sui Wallet
          </button>

      <EthereumWallet />
        </div>
      </div>
  );
}
