#> moving:state/vertically
#
#   > If the entity's previous Y position value do not match their current Y position value, consider the entity moving vertically
#
#@within function moving:impl/compare_pos


#   Add the `moving.state_vertically` tag only if the entity has the `moving.initialized` tag
tag @s[tag = moving.initialized] add moving

tag @s[tag = moving.initialized] add moving.state_vertically


#   Set the score of the entity from the `moving.v_ticks` objective
scoreboard players operation @s[type = minecraft:player] moving.v_ticks = %playerDelay moving.main

scoreboard players operation @s[type = !minecraft:player] moving.v_ticks = %nonPlayerDelay moving.main


#   Sync the previous and current position values
scoreboard players operation @s moving.prev.y = @s moving.curr.y
