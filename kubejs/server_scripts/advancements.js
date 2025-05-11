/// <reference path="../node_modules/@types/kubejs/globals.d.ts" />

AdvJSEvents.advancement(event => {
	event.get("ensculked:ensculkment/internal_paensculked:ensculkment/internal_pact")
	.addChild("all_infections", c => c
		.display(d => d.setTitle("Pick a Side").setDescription("Fall victim to all infections at once"))
	)
})
