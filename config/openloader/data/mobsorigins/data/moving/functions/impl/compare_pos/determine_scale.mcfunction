#> moving:impl/compare_pos/determine_scale
#
#   > Determine how much the position values is scaled up depending on the initial position values
#
#@within function moving:impl/compare_pos


#   X
execute store result score @s moving.curr.x run data get storage moving:state temp.pos[0]

execute if score @s moving.curr.x matches -21000000..21000000 run function moving:impl/scale/by_100/x

execute if score @s moving.curr.x matches 21000001.. run function moving:impl/scale/by_10/x

execute if score @s moving.curr.x matches ..-21000001 run function moving:impl/scale/by_10/x


#   Y
execute store result score @s moving.curr.y run data get storage moving:state temp.pos[1]

execute if score @s moving.curr.y matches -21000000..21000000 run function moving:impl/scale/by_100/y

execute if score @s moving.curr.y matches 21000001.. run function moving:impl/scale/by_10/y

execute if score @s moving.curr.y matches ..-21000001 run function moving:impl/scale/by_10/y


#   Z
execute store result score @s moving.curr.z run data get storage moving:state temp.pos[2]

execute if score @s moving.curr.z matches -21000000..21000000 run function moving:impl/scale/by_100/z

execute if score @s moving.curr.z matches 21000001.. run function moving:impl/scale/by_10/z

execute if score @s moving.curr.z matches ..-21000001 run function moving:impl/scale/by_10/z