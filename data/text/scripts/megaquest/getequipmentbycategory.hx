var category = args[0];
var providedList = args[1];
var vanillaList = [];

if (providedList == null) {
	var vanillaNames = getequipmentlist(null, [], [
		"skillcard",
		"excludefromrandomlists",
		"robotonly",
		"witchonly",
		"onceperbattle",
		"alternateversion"
	]);

	providedList = [];
	for (name in vanillaNames) {
		var eq = new elements.Equipment(name);
		providedList.push(eq);
		vanillaList.push(eq);
	}
}
var list = [];
if (providedList.length > 0) for (eq in providedList) {
	switch (category) {
		case "weapon":
			if (new EReg("attack\\(.*\\);", "gm").match(eq.script) || new EReg("inflict\\(POISON.*\\);", "gm").match(eq.script) || new EReg("inflict\\(FIRE.*\\);", "gm").match(eq.script))
				list.push(eq);
		case "shield":
			if (new EReg("inflictself\\(SHIELD.*\\);", "gm").match(eq.script) || new EReg("inflictself\\(REDUCE.*\\);", "gm").match(eq.script))
				list.push(eq);
	}
}
if (vanillaList.length > 0) for (eq in vanillaList.copy()) {
	vanillaList.remove(eq);
}
return list;
