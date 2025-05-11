const crushing_set = new Map()

function incr(map, key, n) {
	console.log(`before: ${key} = ${n}`)
	map.set(key, (map.get(key) ?? 0) + n)
	console.log(`after: ${key} = ${n}`)
}
function add_crushing(item, body) {
	const result = new Map()
	console.log(`beginning crushing: ${item}`)
	body((out, n) => {
		n = n || 1
		console.log(`registering output: ${item} → ${n}x ${out}`)
		if (crushing_set.has(out)) {
			console.log(`chaining output`)
			for (let [key, m] of crushing_set.get(out)) {
				console.log(`adding chained output: ${item} — ${n}x ${out} → ${m}x ${key} (total ${n*m})`)
				incr(result, key, n*m)
			}
		} else {
			console.log("cannot chain")
			incr(result, out, n)
		}
	})
	crushing_set.set(item, result)
}
const colors = [
	"white",
	"orange",
	"magenta",
	"light_blue",
	"yellow",
	"lime",
	"pink",
	"gray",
	"light_gray",
	"cyan",
	"purple",
	"blue",
	"brown",
	"green",
	"red",
	"black"
]

add_crushing("minecraft:iron_ingot", f => {
	f("vowels:powdered_iron")
})
add_crushing("minecraft:gold_ingot", f => {
	f("vowels:powdered_gold")
})
add_crushing("minecraft:copper_ingot", f => {
	f("vowels:powdered_copper")
})
add_crushing("minecraft:diamond", f => {
	f("createaddition:diamond_grit")
})
add_crushing("minecraft:iron_block", f => {
	f("vowels:powdered_iron", 9)
})
add_crushing("minecraft:gold_block", f => {
	f("vowels:powdered_gold", 9)
})
add_crushing(`minecraft:copper_block`, f => {
	f("minecraft:copper_ingot", 9)
})
for (let oxid of ["", "exposed_", "weathered_", "oxidized_"]) {
	for (let wax of ["", "waxed_"]) {
		let prefix = wax + oxid
		if (prefix) {
			add_crushing(`minecraft:${prefix}copper`, f => {
				f("minecraft:copper_block")
			})
		}
		add_crushing(`minecraft:${prefix}cut_copper`, f => {
			f("minecraft:copper_block")
		})
	}
}
add_crushing("minecraft:diamond_block", f => {
	f("minecraft:diamond", 9)
})
add_crushing("ae2:printed_logic_processor", f => {
	f("minecraft:gold_ingot")
})
add_crushing("ae2:printed_calculation_processor", f => {
	f("ae2:certus_quartz_dust")
})
add_crushing("ae2:printed_engineering_processor", f => {
	f("minecraft:diamond")
})
add_crushing("suppsquared:iron_plaque", f => {
	f("minecraft:iron_ingot")
})
add_crushing("minecraft:stick", f => {
	f("kubejs:wood_chips", 2)
})
add_crushing("#minecraft:planks", f => {
	f("minecraft:stick", 2)
})
function print_processor(t) {
	add_crushing(`ae2:${t}_processor`, f => {
		f(`ae2:printed_${t}_processor`)
		f("ae2:silicon")
		f("minecraft:redstone")
	})
}
print_processor("logic")
print_processor("calculation")
print_processor("engineering")
function make_card(item, adv, g) {
	add_crushing(item, f => {
		f("minecraft:iron_ingot", 3)
		f("ae2:printed_calculation_processor")
		f("minecraft:redstone")
		f(adv ? "minecraft:diamond" : "minecraft:gold_ingot", 2)
		if (g) g(f)
	})
}
add_crushing("minecraft:redstone_torch", f => {
	f("minecraft:redstone")
	f("minecraft:stick")
})
make_card("ae2:basic_card", false)
make_card("ae2:redstone_card", f => {
	f("minecraft:redstone_torch")
})
make_card("ae2:capacity_card", f => {
	f("ae2:printed_calculation_processor")
})
make_card("ae2:void_card", f => {
	f("ae2:calculation_processor")
})
make_card("ae2:crafting_card", f => {
	f("minecraft:crafting_table")
})
make_card("ae2:fuzzy_card", true, f => {
	f("minecraft:string", 4)
})
make_card("ae2:speed_card", true, f => {
	f("ae2:fluix_crystal")
})
make_card("ae2:inverter_card", true, f => {
	f("minecraft:redstone_torch")
})
make_card("ae2:equal_distribution_card", true, f => {
	f("ae2:calculation_processor")
})
make_card("ae2:energy_card", true, f => {
	f("ae2:dense_energy_cell")
})
add_crushing("ae2:certus_quartz_crystal", f => {
	f("ae2:certus_quartz_dust")
})
add_crushing("ae2:fluix_crystal", f => {
	f("ae2:fluix_dust")
})
add_crushing("ae2:fluix_pearl", f => {
	f("minecraft:ender_pearl")
	f("ae2:fluix_crystal", 8)
})
make_card("ae2:advanced_card", true)
add_crushing("ae2:interface", f => {
	// 4 iro
	f("minecraft:iron_ingot", 4)
	// formation & annihilation cores
	f("ae2:formation_core")
	f("ae2:annihilation_core")
	// 2 glass
	f("minecraft:glass", 2)
	// TODO: add glass shards
})
// cable interfaces drop interfaces
add_crushing("ae2:cable_interface", f => {
	f("ae2:interface")
})
// pattern providers: same as interfaces but replace glass with crafting_table
add_crushing("ae2:pattern_provider", f => {
	f("minecraft:iron_ingot", 4)
	f("ae2:formation_core")
	f("ae2:annihilation_core")
	f("minecraft:crafting_table", 2)
})
// and cable pattern providers drop pattern providers
add_crushing("ae2:cable_pattern_provider", f => {
	f("ae2:pattern_provider")
})
add_crushing("minecraft:cobblestone", f => {
	f("minecraft:gravel")
})
add_crushing("minecraft:furnace", f => {
	f("minecraft:cobblestone", 8)
})
add_crushing("ae2:quartz_glass", f => {
	f("minecraft:glass", 4)
	f("ae2:certus_quartz_dust", 5)
})
add_crushing("ae2:energy_acceptor", f => {
	f("minecraft:iron_ingot", 4)
	f("ae2:quartz_glass", 4)
	f("minecraft:copper_ingot")
})
add_crushing("ae2:vibration_chamber", f => {
	f("ae2:energy_acceptor")
	f("minecraft:furnace")
	f("minecraft:iron_ingot", 2)
	f("minecraft:copper_ingot", 4)
	f("ae2:fluix_crystal")
})
add_crushing("sophisticatedbackpacks:upgrade_base", f => {
	f("minecraft:string", 4)
	f("minecraft:leather")
	f("minecraft:iron_ingot", 4)
})
function add_upgrade(stem, body1, body2) {
	add_crushing(`sophisticatedbackpacks:${stem}_upgrade`, f => {
		f()
		body1(f)
	})
	if (body2 == false) return
	add_crushing(`sophisticatedbackpacks:advanced_${stem}_upgrade`, f => {
		f(`sophisticatedbackpacks:${stem}_upgrade`)
		if (body2) {
			body2(f)
		} else {
			f("minecraft:diamond")
			f("minecraft:gold_ingot", 2)
			f("minecraft:redstone", 3)
		}
	})
}
add_upgrade("pickup", f => {
	f("sophisticatedbackpacks:upgrade_base")
	f("minecraft:redstone", 3)
	f("minecraft:string", 2)
	f("minecraft:sticky_piston")
})
add_upgrade("filter", f => {
	f("minecraft:redstone", 4)
	f("minecraft:string", 4)
}, f => {
	f("minecraft:redstone", 3)
	f("minecraft:gold_ingot", 2)
})
// TODO: magnets
add_upgrade("feeding", f => {
	f("minecraft:golden_carrot")
	f("minecraft:golden_apple")
	f("minecraft:ender_pearl")
	f("minecraft:glistering_melon_slice")
})
add_upgrade("compacting", f => {
	f("minecraft:piston", 4)
	f("minecraft:iron_ingot", 2)
	f("minecraft:redstone", 2)
})
add_upgrade("void", f => {
	f("minecraft:obsidian", 3)
	f("minecraft:ender_pearl")
	f("minecraft:redstone", 2)
})
add_upgrade("restock", f => {
	f("minecraft:iron_ingot", 2)
	f("minecraft:redstone", 2)
	f("minecraft:chest")
	f("minecraft:sticky_piston")
})
add_upgrade("deposit", f => {
	f("minecraft:iron_ingot", 2)
	f("minecraft:redstone", 2)
	f("minecraft:chest")
	f("minecraft:piston")
})
add_upgrade("deposit", f => {
	f("minecraft:iron_ingot", 2)
	f("minecraft:redstone", 2)
	f("minecraft:chest")
	f("minecraft:ender_pearl")
})
add_upgrade("inception", f => {
	f("minecraft:ender_eye", 4)
	f("minecraft:diamond", 3)
	f("minecraft:nether_star")
}, false)
add_upgrade("everlasting", f => {
	f("minecraft:end_crystal", 4)
	f("minecraft:nether_star", 4)
}, false)
function add_smelting_like_upgrade(name, furnace) {
	add_upgrade(name, f => {
		f("minecraft:redstone", 4)
		f("minecraft:iron_ingot", 3)
		f(furnace)
	}, f => {
		f("minecraft:diamond", 2)
		f("minecraft:redstone")
		f("minecraft:gold_ingot")
		f("minecraft:hopper", 3)
	})
}
add_smelting_like_upgrade("smelting", "minecraft:furnace")
add_smelting_like_upgrade("smoking", "minecraft:smoker")
add_smelting_like_upgrade("blasting", "minecraft:blast_furnace")
function add_iron_upgrade(name, top_item, bottom_item) {
	add_upgrade(name, f => {
		f("minecraft:iron_ingot", 2)
		f(top_item || name.replace("/", ":"))
		f(bottom_item || "minecraft:redstone")
	})
}
add_iron_upgrade("crafting", "minecraft:crafting_table", "minecraft:chest")
add_iron_upgrade("stonecutter")
add_iron_upgrade("jukebox")
add_iron_upgrade("chipped/botanist_workbench")
add_iron_upgrade("chipped/glassblower")
add_iron_upgrade("chipped/carpenters_table")
add_iron_upgrade("chipped/loom_table")
add_iron_upgrade("chipped/mason_table")
add_iron_upgrade("chipped/alchemy_bench")
add_iron_upgrade("chipped/tinkering_table")

function add_storage_component(nr, corner, core, top, side) {
	core = core || "ae2:quartz_glass"
	top = top || "ae2:calculation_processor"
	side = side || `ae2:cell_component_${nr/4}k`
	add_crushing(`ae2:cell_component_${nr}k`, f => {
		f(corner, 4)
		f(core)
		if (side == true) {
			f(top, 4)
		} else {
			f(top)
			f(side, 3)
		}
	})
}
add_storage_component(1, "minecraft:redstone", "ae2:logic_processor", "ae2:certus_quartz_crystal", true)
add_storage_component(4, "minecraft:redstone")
add_storage_component(16, "minecraft:glowstone_dust")
add_storage_component(64, "minecraft:glowstone_dust")
add_storage_component(256, "ae2:sky_dust")

// TODO: stack upgrades

for (let c in colors) {
	add_crushing(`#chipped:${c}_concrete`, f => {
		f("minecraft:concrete_powder")
	})
}

const built_set = []
for (let [from, out] of crushing_set) {
	built_set.push([from, Array.from(out.entries()).map(([item, n]) => `${n}x ${item}`)])
}

console.log("built set: " + built_set.join("\n"))

ServerEvents.recipes(event => {
	event.recipes.create.compacting(["minecraft:iron_ingot"], ["vowels:powdered_iron"]).heated()
	event.recipes.create.compacting(["16x kubejs:wood_chips", Item.of("8x kubejs:wood_chips").withChance(0.5), Item.of("4x kubejs:wood_chips").withChance(0.52)], ["#minecraft:logs"]).heated()
	for (let [from, to] of built_set) {
		event.recipes.create.crushing(to, from)
	}
})
