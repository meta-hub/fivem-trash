Config = {
  -- min interact radius
  InteractRadius = 2.0,

  -- control to press to interact with trash
  InteractControl = 38,

  -- string to display when player is near trash
  -- e.g: "Press [E] to search the bin." when near prop_bin_08a.
  HelpStr = 'Press ~INPUT_PICKUP~ to search the %s.',

  -- construct loot tables here
  LootTables = {
    bin_loot = {
      {
        name    = "lockpick",       -- name of item or account
        min     = 1,                -- min possible to find
        max     = 5,                -- max possible to find
        chance  = 20                -- chance of finding this
      },
      {
        type    = "account",
        name    = "black_money",
        min     = 1,
        max     = 500,
        chance  = 50
      }
    },
    beach_bin_loot = {
      {
        name    = "heroin",         -- name of item or account
        min     = 1,                -- min possible to find
        max     = 1,                -- max possible to find
        chance  = 5                 -- chance of finding this
      }
    },
    dumpster = {
      {
        name    = "weapon_smg",     -- name of item or account
        min     = 1,                -- min possible to find
        max     = 1,                -- max possible to find
        chance  = 5                 -- chance of finding this
      }
    },
  },

  -- bin groups. assign these to your models to pre-define labels and loot tables.
  Groups = {
    bin = {
      label = "bin",
      lootTables = {
        'bin_loot',
      }
    },
    beach_bin = {
      label = "bin",
      lootTables = {
        'bin_loot',
        'beach_bin_loot'
      }
    },
    dumpster = {
      label = "dumpster",
      lootTables = {
        'bin_loot',
        'dumpster_loot'
      }
    }
  },

  -- put your models and associated group here.
  Models = {
    prop_bin_01a        = "bin",
    prop_bin_02a        = "bin",
    prop_bin_03a        = "bin",
    prop_bin_04a        = "bin",
    prop_bin_05a        = "bin",
    prop_bin_06a        = "bin",
    prop_bin_07a        = "bin",
    prop_bin_07b        = "bin",
    prop_bin_07c        = "bin",
    prop_bin_07d        = "bin",
    prop_bin_08a        = "bin",
    prop_bin_09a        = "bin",
    prop_bin_10a       = "bin",
    prop_bin_10b       = "bin",
    prop_bin_11a       = "bin",
    prop_bin_11b       = "bin",
    prop_bin_12a       = "bin",
    prop_bin_13a       = "dumpster",
    prop_bin_14a       = "dumpster",
    prop_bin_14b       = "dumpster",
    prop_bin_beach_01a  = "beach_bin",
    prop_bin_beach_01d  = "beach_bin",
    prop_bin_delpiero   = "bin",
    prop_bin_delpiero_b = "bin",
  }
}
