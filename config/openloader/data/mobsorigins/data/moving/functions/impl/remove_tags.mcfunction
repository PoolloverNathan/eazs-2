#> moving:impl/remove_tags
#
#   > Remove the tags added by the `moving:state/horizontally` and `moving:state/vertically` functions
#
#@within
#   function moving:impl/compare_pos
#   function moving:impl/clear


tag @s remove moving.state_horizontally

tag @s remove moving.state_vertically

tag @s remove moving