import { useEffect, useState } from "react";
import { useCurrentAccount, ConnectButton, useDisconnectWallet } from "@mysten/dapp-kit";
import { fetchSuiBalance } from "../utils/suiBallance";

interface SuiAccount {
  address: string;
  label?: string;
}

const SuiWallet = () => {
  const currentAccount = useCurrentAccount() as SuiAccount | null;
  const { mutate: disconnect } = useDisconnectWallet();

  const [balance, setBalance] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    if (currentAccount?.address) {
      setIsLoading(true);
      const getBalance = async () => {
        try {
          const balanceInSUI = await fetchSuiBalance(currentAccount.address);
          setBalance(balanceInSUI);
        } catch (error) {
          setBalance("Error fetching balance");
        } finally {
          setIsLoading(false);
        }
      };

      getBalance();
    }
  }, [currentAccount?.address]);

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-semibold text-highlight">Sui Wallet</h1>
      {!currentAccount?.address && (
        <div className="flex justify-center">
          <ConnectButton
            className="w-full py-3 px-5 bg-highlight text-primary rounded-full hover:scale-105 hover:shadow-xl transition-transform duration-300"
          >
            {currentAccount?.address ? "Connected to Sui" : "Connect Sui Wallet"}
          </ConnectButton>
        </div>
      )}

      {currentAccount?.address && (
        <div className="text-center space-y-4">
          <div className="text-sm text-white">
            <strong>Address:</strong>
            <span className="ml-2 text-accent">{currentAccount.address}</span>
          </div>

          <div className="text-sm text-gray-400">
            <strong className="text-accent">Balance:</strong>
            <span className="ml-2 text-white">{isLoading ? "Loading..." : balance}</span>
            <span className="text-green-400 ml-1">SUI</span>
          </div>

          <div className="mt-3 text-sm text-gray-400">
            <strong className="text-white">Label:</strong>
            <span className="ml-2 text-accent">{currentAccount.label || "Unknown"}</span>
          </div>

          <button
            onClick={() => disconnect()}
            className="w-full py-3 px-5 bg-red-500 text-white rounded-full hover:scale-105 hover:shadow-xl transition-transform duration-300"
          >
            Disconnect Wallet
          </button>
        </div>
      )}
    </div>
  );
};

export default SuiWallet;