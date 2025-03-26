#> moving:state/horizontally
#
#   > If the entity's previous X and Z position values do not match their current X and Z position values, consider the entity moving horizontally
#
#@within function moving:impl/compare_pos


#   Add the `moving.state_horizontally` tag only if the entity has the `moving.initialized` tag
tag @s[tag = moving.initialized] add moving

tag @s[tag = moving.initialized] add moving.state_horizontally


#   Set the score of the entity from the `moving.h_ticks` objective
scoreboard players operation @s[type = minecraft:player] moving.h_ticks = %playerDelay moving.main

scoreboard players operation @s[type = !minecraft:player] moving.h_ticks = %nonPlayerDelay moving.main


#   Sync the previous and current position values
scoreboard players operation @s moving.prev.x = @s moving.curr.x

scoreboard players operation @s moving.prev.z = @s moving.curr.z
