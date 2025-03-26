#> moving:impl/scale/by_100/x
#
#@within function moving:impl/compare_pos/determine_scale


execute store result score @s moving.curr.x run data get storage moving:state temp.pos[0] 100
