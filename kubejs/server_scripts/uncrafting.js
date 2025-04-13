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
make_card("ae2:acceleration_card", true, f => {
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
