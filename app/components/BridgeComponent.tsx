const BridgeComponent = () => {
    return (
        <div className="space-y-6">
            <div className="flex justify-center items-center space-x-4">
                <input
                    type="text"
                    placeholder="Amount"
                    className="p-3 rounded-md border border-gray-700 bg-secondary-light text-black w-64"
                />
                <select className="p-3 rounded-md border border-gray-700 bg-secondary-light text-black">
                    <option>Ethereum → Sui</option>
                    <option>Sui → Ethereum</option>
                </select>
            </div>
            <button className="px-8 py-3 bg-highlight text-primary font-semibold rounded-lg hover:scale-105 transition-transform">
                Bridge Tokens
            </button>
        </div>
    );
};

export default BridgeComponent;
