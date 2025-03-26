#> moving:impl/scale/by_100/z
#
#@within function moving:impl/compare_pos/determine_scale


execute store result score @s moving.curr.z run data get storage moving:state temp.pos[2] 100
