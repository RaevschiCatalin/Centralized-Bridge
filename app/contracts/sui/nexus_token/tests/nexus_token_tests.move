module 0x1::nexus_token_tests {

    use sui::coin::{Coin, TreasuryCap, mint, split, burn};
    use sui::tx_context::TxContext;
    use sui::move_stdlib::address;

    public struct NexusToken has copy, drop, store {}


    public fun mint_token(ctx: &mut TxContext, amount: u64): Coin<NexusToken> {

        let cap: &mut TreasuryCap<NexusToken> = borrow_global_mut<TreasuryCap<NexusToken>>(address::address_of::<NexusToken>());


        let coin = mint(cap, amount, ctx);

        return coin;
    }


    public fun burn_token(ctx: &mut TxContext, coin: Coin<NexusToken>) {

        let cap: &mut TreasuryCap<NexusToken> = borrow_global_mut<TreasuryCap<NexusToken>>(address::address_of::<NexusToken>());
        burn(cap, coin, ctx);
    }


    public fun split_coin(ctx: &mut TxContext, coin: Coin<NexusToken>, amount: u64): Coin<NexusToken> {

        let coin_a = split(coin, amount, ctx);

        return coin_a;
    }


    public fun test_mint(ctx: &mut TxContext, amount: u64): Coin<NexusToken> {

        let cap: &mut TreasuryCap<NexusToken> = borrow_global_mut<TreasuryCap<NexusToken>>(address::address_of::<NexusToken>());


        let coin = mint(cap, amount, ctx);

        return coin;
    }


    public fun test_burn_and_split(ctx: &mut TxContext, coin: Coin<NexusToken>, split_amount: u64): Coin<NexusToken> {

        burn_token(ctx, coin);


        let new_coin = split_coin(ctx, coin, split_amount);

        return new_coin;
    }
}
