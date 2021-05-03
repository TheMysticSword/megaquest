var eq = args[0];
var amount = (args.length >= 2 ? args[1] : 1);
for (i in 0...amount) {
	var newslots = [];
	for (slot in eq.getslots()) switch (slot) {
		case "REQUIRE6" , "REQUIRE5":
			newslots.push("MIN5");
		case "MIN5":
			newslots.push("MIN4");
		case "MIN4" , "RANGE45":
			newslots.push("MIN3");
		case "MIN3" , "RANGE35":
			newslots.push("MIN2");
		case "MIN2" , "MAX5" , "EVEN" , "ODD" , "RANGE25":
			newslots.push("NORMAL");
		case "REQUIRE4":
			newslots.push("RANGE45");
		case "REQUIRE3":
			newslots.push("RANGE23");
		case "REQUIRE2" , "REQUIRE1":
			newslots.push("MAX2");
		case "RANGE34":
			newslots.push("RANGE25");
		case "RANGE23" , "MAX3":
			newslots.push("MAX4");
		case "RANGE24", "MAX4":
			newslots.push("MAX5");
		case "MAX2":
			newslots.push("MAX3");
		case "DOUBLES":
			newslots.push("COUNTDOWN_10");
		default:
			newslots.push(slot);
	}
	var originalcountdown = eq.countdown;
	var originalmaxcountdown = eq.maxcountdown;
	var originalremainingcountdown = eq.remainingcountdown;
	eq.changeslots(newslots);
	if (eq.countdown > 0) {
		eq.countdown = originalcountdown / 2;
		eq.maxcountdown = originalmaxcountdown / 2;
		eq.remainingcountdown = originalremainingcountdown / 2;
		if (eq.remainingcountdown <= 0)
			eq.remainingcountdown = 1;
	}
}
eq.animate("slotschanged");
