#> moving:impl/scale/by_100/y
#
#@within function moving:impl/compare_pos/determine_scale


execute store result score @s moving.curr.y run data get storage moving:state temp.pos[1] 100
