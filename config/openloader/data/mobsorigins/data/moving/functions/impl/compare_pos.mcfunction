#> moving:impl/compare_pos
#
#   > Compare the entity's current position to its previous position
#
#   - *This function is called by the `moving:state` power (`data/moving/powers/state.json`)*
#
#@internal


#   Remove the tags that were added earlier
function moving:impl/remove_tags


#   Initialize the scores of the entity from the `moving.v_ticks` and `moving.h_ticks` objectives
execute unless score @s moving.h_ticks = @s moving.h_ticks run scoreboard players set @s moving.h_ticks 0

execute if score @s moving.h_ticks matches 1.. run scoreboard players remove @s moving.h_ticks 1


execute unless score @s moving.v_ticks = @s moving.v_ticks run scoreboard players set @s moving.v_ticks 0

execute if score @s moving.v_ticks matches 1.. run scoreboard players remove @s moving.v_ticks 1


#   Get the position values of the entity
data modify storage moving:state temp.pos set from entity @s Pos

function moving:impl/compare_pos/determine_scale


#   Determine whether if the entity is moving horizontally or vertically
execute unless score @s moving.prev.x = @s moving.curr.x run function moving:state/horizontally

execute unless score @s moving.prev.y = @s moving.curr.y run function moving:state/vertically

execute unless score @s moving.prev.z = @s moving.curr.z run function moving:state/horizontally


#   Add a tag that indicates the entity's position values are initialized
tag @s add moving.initialized

data remove storage moving:state temp
