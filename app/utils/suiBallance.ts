

import { SuiClient, getFullnodeUrl } from '@mysten/sui/client';
import { MIST_PER_SUI } from '@mysten/sui/utils';

export const fetchSuiBalance = async (address: string) => {
    try {
        const suiClient = new SuiClient({ url: getFullnodeUrl('devnet') });
        const result = await suiClient.getBalance({ owner: address });

        const balanceInSUI = Number(result.totalBalance) / Number(MIST_PER_SUI);
        return balanceInSUI.toFixed(2);
    } catch (error) {
        console.error("Error fetching SUI balance:", error);
        throw new Error("Failed to fetch balance");
    }
};
