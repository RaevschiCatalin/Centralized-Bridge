import { useEthereumWallet } from "@/hooks/useEthereumWallet";

const Wallet = () => {
    const { account, connectWallet, disconnectWallet } = useEthereumWallet();

    return (
        <div className="p-4 bg-gray-100 rounded shadow">
            {account ? (
                <div className="flex flex-col items-center">
                    <p className="text-gray-700">Connected: {account}</p>
                    <button
                        onClick={disconnectWallet}
                        className="mt-2 px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600"
                    >
                        Disconnect
                    </button>
                </div>
            ) : (
                <button
                    onClick={connectWallet}
                    className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
                >
                    Connect Wallet
                </button>
            )}
        </div>
    );
};

export default Wallet;
