var e = args[0];
var neweqname = args[1];

var oldequip = e.copy();
var reallyweakened = e.weakened;
var reallyoriginallyupgraded = e.originallyupgraded;
e.overwritefinalline = "";

e.create(neweqname + ((oldequip.upgraded || reallyoriginallyupgraded) ? "+" : ""), false, false);
e.name = e.rawname;

e.x = oldequip.x;
e.y = oldequip.y;
e.timesused = oldequip.timesused;
e.totalusesremaining = oldequip.totalusesremaining;
e.originallyupgraded = reallyoriginallyupgraded;
if (oldequip.countdown != 0) {
    e.reducecountdownby = oldequip.reducecountdownby;
    e.reducecountdowndelay = oldequip.reducecountdowndelay;
    e.remainingcountdown = e.clampremainingcountdown(oldequip.remainingcountdown, oldequip.maxcountdown, e.maxcountdown);
}

if (e.equippedby != null) {
    if ("" + e.equippedby.layout == "DECK" || Rules.bigequipmentmode) if (size != 2) e.resize(2);
}

trace(e.weakentype);
if (reallyweakened) e.downgrade();

e.equipmentpanel = new displayobjects.EquipmentPanel();
