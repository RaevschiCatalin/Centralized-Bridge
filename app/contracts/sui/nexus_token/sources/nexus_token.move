module nexus_token::nexus_token {
    use sui::coin::{Coin, TreasuryCap, mint as sui_mint, burn as sui_burn, split};
    // use sui::transfer;


    public struct NexusToken has key, store {
        id: sui::object::UID,
    }
    /// /// /// /// /// /// /// /// ///
    ///   Mint tokens and transfer  ///
    /// /// /// /// /// /// /// /// ///
    public fun mint_token(
        cap: &mut TreasuryCap<NexusToken>,
        recipient: address,
        amount: u64,
        ctx: &mut TxContext
    ) {
        let coins = sui_mint(cap, amount, ctx);
        transfer::public_transfer(coins, recipient);
    }
    ///  /// /// /// /// ///
    ///   Burn tokens   ///
    /// /// /// /// /// ///
    public fun burn_token(
        cap: &mut TreasuryCap<NexusToken>,
        coin: Coin<NexusToken>
    ) {
        sui_burn(cap, coin);
    }
    /// ///  /// ///  /// ///
    /// Burn part token  ///
    /// /// /// /// /// ///
    public fun burn_partial(
        cap: &mut TreasuryCap<NexusToken>,
        coin: &mut Coin<NexusToken>,
        amount: u64,
        ctx: &mut TxContext
    ) {
        let burned = split(coin, amount, ctx);
        sui_burn(cap, burned);
    }
}
