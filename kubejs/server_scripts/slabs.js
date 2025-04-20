const acq = []
function compact(a, b, n) {
	acq.push(a)
	if (typeof n !== "number") n = 2
	ServerEvents.recipes(event => {
		event.recipes.create.compacting([b], [`${n}x ${a}`])
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
//{{{1 catwalks (close enough)
const catwalk_materials = {
	andesite: "create:andesite_alloy",
	brass: "create:brass_ingot",
	iron: "minecraft:iron_ingot",
	copper: "minecraft:copper_ingot",
	industrial_iron: "createdeco:industrial_iron_ingot",
	zinc: "create:zinc_ingot",
}
for (const [stem, item] of Object.entries(catwalk_materials)) {
	compact(`createdeco:${stem}_catwalk`, item, 4)
	compact(`createdeco:${stem}_catwalk_stairs`, item, 2)
	compact(`createdeco:${stem}_catwalk_railing`, item, 8)
}
//}}}1
console.log("Known slabs: " + acq)
