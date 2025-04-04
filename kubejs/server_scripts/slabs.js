ServerEvents.recipes(event => {
	function compact_slab(a, b) {
		event.recipes.create.compacting([b], [`2x ${a}`])
	}
	//
	//{{{1 wooden slabs
	for (let wood of [
		"minecraft:oak",
		"minecraft:spruce",
		"minecraft:birch",
		"minecraft:jungle",
		"minecraft:acacia",
		"minecraft:cherry",
		"minecraft:dark_oak",
		"minecraft:mangrove",
		"minecraft:bamboo",
		"minecraft:crimson",
		"minecraft:warped",
	]) {
		compact(`${wood}_slab`, `${wood}_planks`)
	}
	//{{{1 pluralized slabs
	for (let root of [
		"minecraft:brick",
		"minecraft:stone_brick",
		"minecraft:mud_brick",
		"minecraft:nether_brick",
		"minecraft:prismarine_brick_slab",
	]) {
		compact(`${root}_slab`, `${root}s`)
	}
	//{{{1 non-pluralized slabs
	for (let root of [
		"minecraft:stone_slab",
		"minecraft:smooth_stone_slab",
		"minecraft:sandstone_slab",
		"minecraft:cut_sandstone_slab",
		"minecraft:granite_slab",
		"minecraft:andesite_slab",
		"minecraft:diorite_slab",
		"minecraft:prismarine_slab",
		"minecraft:cobblestone_slab",
	]) {
		compact(`${root}_slab`, `${root}`)
	}
	//}}}1
})
