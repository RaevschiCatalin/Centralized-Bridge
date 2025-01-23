import {useSuiClientContext} from "@mysten/dapp-kit";


const SuiNetworkSelector = () => {
    const ctx = useSuiClientContext();

    return (
        <div>
            {Object.keys(ctx.networks).map((network) => (
                <button key={network} onClick={() => ctx.selectNetwork(network)}>
                    {`select ${network}`}
                </button>
            ))}
        </div>
    );
}

export default SuiNetworkSelector;