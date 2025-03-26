# {{{1 Setup
from json import dump

fishes = list()
multiple = {
    "name": "Omophagic Piscivore",
    "description": "Your body has not evolved to digest cooked food or any vegetables or land-based animals. You can only eat raw fish or living fish from a bucket.",
    "type": "origins:multiple",
    "restrict": {
        "type": "origins:prevent_item_use",
        "item_condition": {
            "type": "origins:and",
            "conditions": [
                {
                    "type": "origins:food"
                },
                {
                    "inverted": True,
                    "type": "origins:ingredient",
                    "ingredient": {
                        "tag": "mermaid_origin:bait"
                    }
                }
            ]
        }
    }
}


def allow_eating_item(id):
    fishes.append(id)


def add_edible_item(item, /, hunger, saturation, meat, food_component={}, props={}):
    allow_eating_item(item)
    multiple[item.split(":")[-1]] = {
        "type": "apugli:edible_item",
        "item_condition": {
            "type": "origins:ingredient",
            "ingredient": {"item": item},
        },
        "food_component": {
            "hunger": hunger,
            "saturation": saturation,
            "meat": meat,
            **food_component,
        },
        **props,
    }


# 1 - hunger, 2 - poison, 3 - static_charges, 4 - bleeding, 5 - ender_flu, 6 - nausea, 7 - luck
def add_edible_bucket(bucket, fish, /, hunger, saturation, meat, effect=None):
    if effect is None:
        effect = (
            {
                "chance": 1,
                "effect": {
                    "effect": "farmersdelight:comfort",
                    "amplifier": 0,
                    "duration": 3600,
                },
            }
            if hunger < 10
            else {
                "chance": 1,
                "effect": {
                    "effect": "farmersdelight:nourishment",
                    "amplifier": 0,
                    "duration": 4200,
                },
            }
        )

    add_edible_item(
        bucket,
        hunger,
        saturation,
        meat,
        {
            "effect": effect,
        },
        {
            "use_action": "drink",
            "sound": "item.bucket.fill_fish",
            "return_stack": {"item": "minecraft:water_bucket"},
        }
    )


# {{{1 Definitions
allow_eating_item("#forge:raw_fishes")
allow_eating_item("minecraft:pufferfish")
allow_eating_item("aquaculture:fish_fillet_raw")
allow_eating_item("aquaculture:sushi")
allow_eating_item("#aquaculturedelight:fish_rolls")
allow_eating_item("oceansdelight:fugu_roll")
allow_eating_item("oceansdelight:elder_guardian_roll")
allow_eating_item("oceansdelight:guardian_tail")
allow_eating_item("oceansdelight:tentacles")
allow_eating_item("oceansdelight:cut_tentacles")
allow_eating_item("oceansdelight:tentacle_on_a_stick")
allow_eating_item("oceansdelight:elder_guardian_slice")
allow_eating_item("oceansdelight:elder_guardian_slab")
allow_eating_item("alexsmobs:blobfish")
allow_eating_item("alexsmobs:flying_fish")
allow_eating_item("alexsmobs:raw_catfish")
allow_eating_item("alexsmobs:lobster_tail")
allow_eating_item("alexsmobs:cosmic_cod")
add_edible_item("aquaculture:worm", 3, 0.7, True)
add_edible_item(
    "aquaculture:leech",
    4,
    0.4,
    True,
    {
        "effect": {
            "chance": 0.8,
            "effect": {"effect": "minecraft:hunger", "amplifier": 0, "duration": 400},
        }
    },
)
add_edible_item("aquaculture:minnow", 6, 1, True)

add_edible_bucket("minecraft:cod_bucket", "minecraft:cod", 6, 0.7, True)
add_edible_bucket("minecraft:salmon_bucket", "minecraft:salmon", 7, 0.7, True)
add_edible_bucket(
    "minecraft:pufferfish_bucket",
    "minecraft:pufferfish",
    6,
    0.4,
    True,
    {
        "chance": 1,
        "effect": {"effect": "minecraft:poison", "amplifier": 1, "duration": 600},
    },
)
add_edible_bucket(
    "minecraft:tropical_fish_bucket", "minecraft:tropical_fish", 6, 0.7, True
)

add_edible_bucket(
    "aquaculture:atlantic_cod_bucket", "aquaculture:atlantic_cod", 10, 1, True
)
add_edible_bucket("aquaculture:blackfish_bucket", "aquaculture:blackfish", 6, 0.7, True)
add_edible_bucket(
    "aquaculture:pacific_halibut_bucket", "aquaculture:pacific_halibut", 14, 1, True
)
add_edible_bucket(
    "aquaculture:atlantic_halibut_bucket", "aquaculture:atlantic_halibut", 14, 1, True
)
add_edible_bucket(
    "aquaculture:atlantic_herring_bucket", "aquaculture:atlantic_herring", 6, 0.7, True
)
add_edible_bucket(
    "aquaculture:pink_salmon_bucket", "aquaculture:pink_salmon", 6, 0.7, True
)
add_edible_bucket("aquaculture:pollock_bucket", "aquaculture:pollock", 6, 0.7, True)
add_edible_bucket(
    "aquaculture:rainbow_trout_bucket", "aquaculture:rainbow_trout", 6, 0.7, True
)
add_edible_bucket("aquaculture:bayad_bucket", "aquaculture:bayad", 8, 0.7, True)
add_edible_bucket("aquaculture:boulti_bucket", "aquaculture:boulti", 6, 0.7, True)
add_edible_bucket("aquaculture:capitaine_bucket", "aquaculture:capitaine", 14, 1, True)
add_edible_bucket(
    "aquaculture:synodontis_bucket", "aquaculture:synodontis", 6, 0.7, True
)
add_edible_bucket(
    "aquaculture:smallmouth_bass_bucket", "aquaculture:smallmouth_bass", 6, 0.7, True
)
add_edible_bucket("aquaculture:bluegill_bucket", "aquaculture:bluegill", 6, 0.7, True)
add_edible_bucket(
    "aquaculture:brown_trout_bucket", "aquaculture:brown_trout", 6, 0.7, True
)
add_edible_bucket("aquaculture:carp_bucket", "aquaculture:carp", 6, 0.7, True)
add_edible_bucket("aquaculture:catfish_bucket", "aquaculture:catfish", 10, 1, True)
add_edible_bucket("aquaculture:gar_bucket", "aquaculture:gar", 8, 0.7, True)
add_edible_bucket("aquaculture:minnow_bucket", "aquaculture:minnow", 10, 1, True, 7)
add_edible_bucket(
    "aquaculture:muskellunge_bucket", "aquaculture:muskellunge", 7, 0.7, True
)
add_edible_bucket("aquaculture:perch_bucket", "aquaculture:perch", 6, 0.7, True)
add_edible_bucket("aquaculture:arapaima_bucket", "aquaculture:arapaima", 10, 12, True)
add_edible_bucket("aquaculture:piranha_bucket", "aquaculture:piranha", 6, 0.7, True)
add_edible_bucket("aquaculture:tambaqui_bucket", "aquaculture:tambaqui", 7, 0.7, True)
add_edible_bucket(
    "aquaculture:brown_shrooma_bucket", "aquaculture:brown_shrooma", 10, 1, True
)
add_edible_bucket(
    "aquaculture:red_shrooma_bucket", "aquaculture:red_shrooma", 10, 1, True
)
add_edible_bucket(
    "aquaculture:jellyfish_bucket", 
    "aquaculture:jellyfish", 
    6, 
    0.4, 
    True, 
    {
        "chance": 0.8,
        "effect": {
            "effect": "ars_elemental:static_charged",
            "amplifier": 0,
            "duration": 200,
        },
    },
)
add_edible_bucket(
    "aquaculture:red_grouper_bucket", "aquaculture:red_grouper", 7, 0.7, True
)
add_edible_bucket("aquaculture:tuna_bucket", "aquaculture:tuna", 10, 12, True)

add_edible_bucket("alexsmobs:lobster_bucket", "alexsmobs:lobster", 10, 1, True)
add_edible_bucket(
    "alexsmobs:blobfish_bucket",
    "alexsmobs:blobfish",
    7,
    0.4,
    True,
    {
        "chance": 1,
        "effect": {"effect": "minecraft:poison", "amplifier": 1, "duration": 300},
    },
)
add_edible_bucket(
    "alexsmobs:frilled_shark_bucket",
    "alexsmobs:frilled_shark",
    12,
    1,
    True,
    {
        "chance": 0.5,
        "effect": {"effect": "ageofweapons:bleeding", "amplifier": 0, "duration": 300},
    },
)
add_edible_bucket(
    "alexsmobs:mimic_octopus_bucket",
    "alexsmobs:mimic_octopus",
    7,
    0.7,
    True,
    {
        "chance": 1,
        "effect": {"effect": "minecraft:nausea", "amplifier": 2, "duration": 300},
    },
)
add_edible_bucket(
    "alexsmobs:cosmic_cod_bucket",
    "alexsmobs:cosmic_cod",
    8,
    0.4,
    True,
    {
        "chance": 0.15,
        "effect": {"effect": "alexsmobs:ender_flu", "amplifier": 0, "duration": 600},
    },
)
add_edible_bucket(
    "alexsmobs:comb_jelly_bucket",
    "alexsmobs:comb_jelly",
    6, 
    0.4, 
    True, 
    {
        "chance": 0.8,
        "effect": {
            "effect": "ars_elemental:static_charged",
            "amplifier": 0,
            "duration": 200,
        },
    },
)
add_edible_bucket(
    "alexsmobs:devils_hole_pupfish_bucket",
    "alexsmobs:devils_hole_pupfish",
    14,
    1,
    True,
)
add_edible_bucket(
    "alexsmobs:small_catfish_bucket", "alexsmobs:small_catfish", 8, 0.7, True
)
add_edible_bucket(
    "alexsmobs:medium_catfish_bucket", "alexsmobs:medium_catfish", 10, 1, True
)
add_edible_bucket(
    "alexsmobs:large_catfish_bucket", "alexsmobs:large_catfish", 12, 1, True
)
add_edible_bucket("alexsmobs:flying_fish_bucket", "alexsmobs:flying_fish", 10, 1, True)
add_edible_bucket("alexsmobs:mudskipper_bucket", "alexsmobs:mudskipper", 7, 0.7, True)
add_edible_bucket("alexsmobs:triops_bucket", "alexsmobs:triops", 6, 0.7, True)

# {{{1 Serialization
with open("data/mermaid_origin/tags/items/bait.json", "w") as f:
    dump({"replace": False, "values": fishes}, f, indent=2)
with open("data/mermaid_origin/powers/bait_diet.json", "w") as f:
    dump(multiple, f, indent=2,)
# }}}1
