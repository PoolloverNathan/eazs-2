ServerEvents.recipes(event => {
	event.recipes.create.compacting(["minecraft:calcite"], ["2x minecraft:quartz", "2x minecraft:bone_meal"]).heated()
	event.recipes.create.compacting(["minecraft:tuff"], ["4x supplementaries:ash", Fluid.lava(500)]).heated()
	event.recipes.create.compacting([Fluid.of("kubejs:resin", 125)], ["minecraft:spruce_log"])
	event.recipes.create.mixing(["kubejs:rubber_patch"], ["minecraft:paper", Fluid.of("kubejs:resin", 125)]).heated()
	event.smelting("supplementaries:ash", "kubejs:wood_chips")
	event.smoking("supplementaries:ash", "kubejs:wood_chips")
})
