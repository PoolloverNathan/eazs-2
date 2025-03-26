#> moving:load
#
#   > The main load function for the `moving` namespace
#
#@within tag/function minecraft:load
#declare storage moving:state


#   Add scoreboard objectives
scoreboard objectives add moving.main dummy


scoreboard objectives add moving.curr.x dummy

scoreboard objectives add moving.curr.y dummy

scoreboard objectives add moving.curr.z dummy


scoreboard objectives add moving.prev.x dummy

scoreboard objectives add moving.prev.y dummy

scoreboard objectives add moving.prev.z dummy


scoreboard objectives add moving.h_ticks dummy

scoreboard objectives add moving.v_ticks dummy


#   Set variables
execute unless score %playerDelay moving.main = %playerDelay moving.main run scoreboard players set %playerDelay moving.main 10

execute unless score %nonPlayerDelay moving.main = %nonPlayerDelay moving.main run scoreboard players set %nonPlayerDelay moving.main 5


#   Display a load/reload message
execute unless score #loaded moving.main = #loaded moving.main run tellraw @a {"text": "[+ Loaded \"Moving\"]", "color": "green"}

execute if score #loaded moving.main = #loaded moving.main run tellraw @a[tag = moving.debugger] {"text": "[= Reloaded \"Moving\"]", "color": "gold"}

scoreboard players set #loaded moving.main 1
