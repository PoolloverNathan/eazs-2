ServerEvents.recipes(event => {
	event.recipes.create.compacting(["minecraft:calcite"], ["2x minecraft:quartz", "2x minecraft:bone_meal"]).heated()
	event.recipes.create.compacting(["minecraft:tuff"], ["4x supplementaries:ash", Fluid.lava(500)]).heated()
})
