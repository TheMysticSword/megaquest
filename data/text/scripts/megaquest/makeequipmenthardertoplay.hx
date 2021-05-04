var eq = args[0];
var amount = (args.length >= 2 ? args[1] : 1);
for (i in 0...amount) {
	var newslots = [];
	for (slot in eq.getslots())
		switch (slot) {
			case "NORMAL":
				newslots.push("EVEN");
			case "EVEN", "MIN5":
				newslots.push("REQUIRE6");
			case "ODD":
				newslots.push("REQUIRE5");
			case "MIN2":
				newslots.push("MIN3");
			case "MIN3":
				newslots.push("MIN4");
			case "MIN4":
				newslots.push("MIN5");
			case "MAX5":
				newslots.push("MAX4");
			case "MAX4":
				newslots.push("MAX3");
			case "MAX3":
				newslots.push("MAX2");
			case "MAX2":
				newslots.push("REQUIRE1");
			case "RANGE25":
				newslots.push("RANGE34");
			case "RANGE24":
				newslots.push("REQUIRE3");
			case "RANGE23":
				newslots.push("REQUIRE3");
			case "RANGE35":
				newslots.push("REQUIRE4");
			case "RANGE34":
				newslots.push("REQUIRE4");
			case "RANGE45":
				newslots.push("REQUIRE5");
			case "DOUBLES":
				newslots.push("REQUIRE6");
				newslots.push("REQUIRE6");
			default:
				newslots.push(slot);
		}
	var originalcountdown = eq.countdown;
	var originalmaxcountdown = eq.maxcountdown;
	var originalremainingcountdown = eq.remainingcountdown;
	eq.changeslots(newslots);
	if (eq.countdown > 0) {
		eq.countdown = originalcountdown + 1;
		eq.maxcountdown = originalmaxcountdown + 1;
		eq.remainingcountdown = originalremainingcountdown + 1;
	}
}
eq.animate("slotschanged");
