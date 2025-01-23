"use client";

import EthereumWallet from "@/components/EthereumWallet";
import SuiWallet from "@/components/SuiWallet";

export default function AuthPage() {
  return (
      <div className="min-h-screen flex items-center justify-center bg-primary text-text">
        <div className="p-8 space-y-6 text-center bg-secondary rounded-lg shadow-xl max-w-md">
          <h1 className="text-2xl font-semibold text-highlight">
            Authenticate Your Wallet
          </h1>
          <p className="text-sm text-accent">
            Select your wallet to connect to the decentralized world.
          </p>
          <EthereumWallet />
          <SuiWallet />
        </div>
      </div>
  );
}
