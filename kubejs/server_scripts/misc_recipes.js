ServerEvents.recipes(event => {
	event.recipes.create.compacting(["minecraft:calcite"], ["2x minecraft:quartz", "2x minecraft:bone_meal"]).heated()
	event.recipes.create.compacting(["minecraft:tuff"], ["4x supplementaries:ash", Fluid.lava(500)]).heated()
	event.recipes.create.compacting([Fluid.of("kubejs:resin", 125)], ["minecraft:spruce_log"])
	event.recipes.create.mixing(["kubejs:rubber_patch"], ["minecraft:paper", Fluid.of("kubejs:resin", 125)]).heated()
	event.smelting("supplementaries:ash", "kubejs:wood_chips")
	event.smoking("supplementaries:ash", "kubejs:wood_chips")
	let inter = 'kubejs:hopper_pot_incomplete'
	event.recipes.create.sequenced_assembly([
		Item.of('botanypots:terracotta_hopper_botany_pot').withChance(116),
		Item.of('create:andesite_alloy').withChance(0.1),
		'create:brass_ingot',
		'minecraft:redstone',
		'minecraft:redstone',
		'minecraft:terracotta',
		'minecraft:dried_kelp',
		'minecraft:brick'
	], 'botanypots:terracotta_botany_pot', [
		event.recipes.createDeploying(inter, [inter, 'create:andesite_funnel']),
		event.recipes.createDeploying(inter, [inter, 'create:brass_ingot']),
		event.recipes.createDeploying(inter, [inter, 'minecraft:redstone']),
		event.recipes.createDeploying(inter, [inter, 'minecraft:redstone']),
		event.recipes.createDeploying(inter, [inter, 'create:tree_fertilizer']),
	]).transitionalItem(inter).loops(1)
	event.remove({ not: { type: 'create:sequenced_assembly' }, output: '#botanypots:hopper_botany_pots'})
})
