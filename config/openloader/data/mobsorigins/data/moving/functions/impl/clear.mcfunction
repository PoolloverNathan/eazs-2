#> moving:impl/clear
#
#   > Clear the scores of the player from the `moving.x.x` scoreboard objectives, and remove the `moving.initialized` tag
#
#@private


#   Remove the `moving.initialized` tag
tag @s remove moving.initialized

function moving:impl/remove_tags


#   Reset the scores of the entity in all of the `moving.<cur|pre>.<x|y|z>` scoreboard objectives
scoreboard players reset @s moving.h_ticks

scoreboard players reset @s moving.v_ticks


scoreboard players reset @s moving.curr.x

scoreboard players reset @s moving.curr.y

scoreboard players reset @s moving.curr.z