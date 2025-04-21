StartupEvents.registry("item", (event) => {
  event.create("powdered_coal").displayName("Powdered Coal");
  event.create("powdered_zinc").displayName("Powdered Zinc");
  event.create("wood_chips").displayName("Wood Chips");
  event.create("rubber_patch").displayName("Rubber Patch");
  event.create("hopper_pot_incomplete").displayName("Incomplete Hopper Pot");
});

StartupEvents.registry("fluid", (event) => {
  event.create("resin").thinTexture(0x452e22).bucketColor(0x452e22).displayName("Resin")
});
