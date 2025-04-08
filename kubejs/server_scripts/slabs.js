const acq = []
function compact(a, b) {
	acq.push(a)
	ServerEvents.recipes(event => {
		event.recipes.create.compacting([b], [`2x ${a}`])
	})
}
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
	"minecraft:prismarine_brick",
]) {
	compact(`${root}_slab`, `${root}s`)
}
//{{{1 non-pluralized slabs
for (let root of [
	"minecraft:stone",
	"minecraft:smooth_stone",
	"minecraft:sandstone",
	"minecraft:cut_sandstone",
	"minecraft:granite",
	"minecraft:andesite",
	"minecraft:diorite",
	"minecraft:prismarine",
	"minecraft:cobblestone",
]) {
	compact(`${root}_slab`, `${root}`)
}
//}}}1
console.log("Known slabs: " + acq)
