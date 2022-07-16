module my_first_package::sword {
    use sui::id::VersionedID;
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    struct Sword has key, store {
      id: VersionedID,
      magic: u64,
      strength: u64,
    }
    public fun magic(self: &Sword): u64 {
      self.magic
    }

    public fun strength(self: &Sword): u64 {
      self.strength
    }

    public fun get_properties(self: &Sword) : (u64, u64) {
      (self.magic, self.strength)
    }

    public entry fun transfer(object: Sword, recipient: address) {
      transfer::transfer(object, recipient)
    }

    fun new(strength: u64, magic: u64, ctx: &mut TxContext): Sword{
      Sword {
        id: tx_context::new_id(ctx),
        magic,
        strength,
      }
    }

    public fun create(strength: u64, magic: u64, ctx: &mut TxContext) {
      let new_sword = new(magic, strength, ctx);
      transfer::transfer(new_sword, tx_context::sender(ctx));
    }
  }