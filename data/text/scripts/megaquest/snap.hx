// Activates a piece of equipment for free.
// Argument 1 - The equipment that needs to be activated.
// Argument 2 - Self fighter.
// Argument 3 - Target fighter.
// Argument 4 - Set to true if the Snap! animation should be played.
// Argument 5 - Set to true if countdown slots should count down instantly to 0.
var e = args[0];
var instant_countdowns = args.length >= 5 && args[4] != null ? args[4] : true;
e.shockedsetting = 0;
e.positionshockslots();
var wait_for_countdown = false;
if (e.countdown > 0 && e.slots.indexOf("COUNTDOWN") == 0) {
    e.remainingcountdown = instant_countdowns ? 0 : 6;
    e.reducecountdownby = 0;
}
var newdice = [];
var total = e.needstotal > 0 ? e.needstotal : 9999;
var c = 0;
if (e.slots.length > 0) for (slot in e.slots) {
    if (e.assigneddice.length >= c + 1 && e.assigneddice[c] == null) {
        var d = 0;
        switch (slot) {
            case "NORMAL": d = 6;
            case "MIN2": d = 6;
            case "MIN3": d = 6;
            case "MIN4": d = 6;
            case "MIN5": d = 6;
            case "MIN6": d = 6;
            case "MAX6": d = 6;
            case "REQUIRE6": d = 6;
            case "EVEN": d = 6;
            case "DOUBLES": d = 6;
            case "MAX5": d = 5;
            case "ODD": d = 5;
            case "REQUIRE5": d = 5;
            case "RANGE25": d = 5;
            case "RANGE35": d = 5;
            case "RANGE45": d = 5;
            case "MAX4": d = 4;
            case "REQUIRE4": d = 4;
            case "RANGE24": d = 4;
            case "RANGE34": d = 4;
            case "MAX3": d = 3;
            case "REQUIRE3": d = 3;
            case "RANGE23": d = 3;
            case "MAX2": d = 2;
            case "REQUIRE2": d = 2;
            case "MAX1": d = 1;
            case "REQUIRE1": d = 1;
        }
        if (slot == "COUNTDOWN" && !instant_countdowns) {
            d = 6;
            wait_for_countdown = true;
        }
        d = runscript("megaquest/math/min", [d, total]);
        total -= d;
        newdice.push(d);
    } else {
        newdice.push(null);
    }
    c++;
}
c = 0;
if (newdice.length > 0) {
    for (d in newdice) {
        if (d != 0 && d != null) {
            var mydice = new elements.Dice();
            mydice.basevalue = d;
            self.dicepool.push(mydice);
            e.assigndice(mydice, c);
            mydice.assigned = e;
        }
        c++;
    }
}
if (!wait_for_countdown) e.doequipmentaction(args[1], args[2], (args[1].isplayer ? 1 : -1), e.assigneddice);
if (args.length >= 4 && args[3] != null && args[3]) e.animate("snap");
else e.animate("flashandshake");
