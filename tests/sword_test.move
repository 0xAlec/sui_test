#[test_only]
module my_first_package::sword_tests {
  use sui::test_scenario;
  use my_first_package::sword::{Self as Sword, Sword};

  #[test]
    fun test_create() {
      let owner = @0xCAFE;
      // Create a sword owned by @0xCAFE with 10 magic and 15 strength
      let scenario = &mut test_scenario::begin(&owner);
      {
        let ctx = test_scenario::ctx(scenario);
        Sword::create(10, 15, ctx);
      };
      // Check ownership belongs to @0xCAFE
      test_scenario::next_tx(scenario, &owner);
      {
        assert!(test_scenario::can_take_owned<Sword>(scenario),0);
      };
      // Check properties of sword (expected: magic 10, strength 10)
      test_scenario::next_tx(scenario, &owner);
      {
        let sword = test_scenario::take_owned<Sword>(scenario);
        let (magic, strength) = Sword::get_properties(&sword);
        assert!(magic == 10 && strength == 15, 0);
        test_scenario::return_owned(scenario, sword);
      }
    }

    #[test]
    fun test_transfer(){
      let owner = @0xCAFE;
      // Creates a sword and transfers it to @0xCAFE
      let scenario = &mut test_scenario::begin(&owner);
      {
        let ctx = test_scenario::ctx(scenario);
        Sword::create(10, 10, ctx);
      };
      // Transfers @0xCAFE's sword to @0x2
      let new_owner = @0x2;
      test_scenario::next_tx(scenario, &owner);
      {
        let object = test_scenario::take_owned<Sword>(scenario);
        Sword::transfer(object, new_owner);
      };
      // Test @0xCAFE does not own the sword anymore
      test_scenario::next_tx(scenario, &owner);
      {
        assert!(!test_scenario::can_take_owned<Sword>(scenario),0);
      };
      // Test @0x2 now owns the sword
      test_scenario::next_tx(scenario, &new_owner);
      {
        assert!(test_scenario::can_take_owned<Sword>(scenario),0);
      }
    }
}