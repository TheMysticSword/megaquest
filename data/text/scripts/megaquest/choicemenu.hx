var header = args[0];
var options = args[1];
var me = args[2];
var direction = args[3] * (me.isplayer ? 1 : -1);
me.setvar("mqchoicemenu_reopen", 1);
me.setvar("mqchoicemenu_reopen_args", args);

var xOffset = -70;

var eqHeader = new elements.Equipment("");
eqHeader.x = 3840 * 0.5 - eqHeader.width / 2 + xOffset;
eqHeader.y = 2180 * 0.17;
eqHeader.y -= 2180 * direction;
runscript("megaquest/moveequipment", [eqHeader, 0, 2180 * direction]);
eqHeader.height = 0;
eqHeader.displayname = header;
eqHeader.equippedby = me;
eqHeader.ready = false;
eqHeader.active = false;
eqHeader.temporary_thisturnonly = true;
eqHeader.setvar("mqchoicemenu_header", 1);
me.equipment.push(eqHeader);

var c = 0;
var maxperrow = 3;
var rows = runscript("megaquest/math/ceil", [options.length / maxperrow]);
for (option in options) {
    var row = runscript("megaquest/math/ceil", [(c + 1) / maxperrow]);
    var columns = runscript("megaquest/math/min", [options.length - (row - 1) * maxperrow, maxperrow]);
    var column = (c % maxperrow) + 1;
    var eq = new elements.Equipment("");
    eq.x = 3840 * 0.1 + 3840 * 0.8 * ((column - 0.5) / columns) - eq.width / 2 + xOffset;
    eq.y = 2180 * 0.2 + 2180 * 0.6 * ((row - 0.5) / rows) - eq.height / 2;
    eq.y -= 2180 * direction;
    runscript("megaquest/moveequipment", [eq, 0, 2180 * direction]);
    eq.displayname = option.name;
    eq.fulldescription = option.description.join("|");
    eq.changecolour(option.colour);
    eq.script = option.script + "
        if (!self.isplayer) givedice(d);
        if (!simulation) {
            if (self.equipment.length > 0) for (eq in self.equipment.copy()) if (eq != e) {
                if (eq.getvar(\"mqchoicemenu_notoption\") > 0) {
                    runscript(\"megaquest/moveequipment\", [eq, 0, 2180 * " + (-direction) + "]);
                    eq.setvar(\"mqchoicemenu_notoption\", eq.getvar(\"mqchoicemenu_notoption\") - 1);
                    eq.ready = true;
                }
                if (eq.getvar(\"mqchoicemenu_option\") > 0 || eq.getvar(\"mqchoicemenu_header\") > 0) {
                    eq.dispose();
                    self.equipment.remove(eq);
                }
            }
        }
    ";
    eq.scriptbeforeexecute = "
        delay(1.0);
        self.setvar(\"mqchoicemenu_reopen\", 0);
        if (self.equipment.length > 0) for (eq in self.equipment) if (eq != e) {
            if (eq.getvar(\"mqchoicemenu_option\") > 0) {
                runscript(\"megaquest/moveequipment\", [eq, 0, 2180 * " + (-direction) + "]);
                eq.ready = false;
                eq.active = false;
                if (eq.skillsavailable > 0) for (i in 0...eq.skillsavailable.length) eq.skillsavailable[i] = false;
            }
            if (eq.getvar(\"mqchoicemenu_header\") > 0) {
                runscript(\"megaquest/moveequipment\", [eq, 0, 2180 * " + (-direction) + "]);
            }
        }
        sfx(\"_whoosh\");
    ";
    eq.equippedby = me;
    eq.castdirection = direction * (me.isplayer ? 1 : -1);
    eq.temporary_thisturnonly = true;
    eq.setvar("mqchoicemenu_option", 1);
    if (me.isplayer) {
        var panel = new displayobjects.BackupCard();
        panel.setupbackup(eq, false);
        panel.cardhasimage = false;
        eq.equipmentpanel = panel;
    } else {
        eq.changeslots(["NORMAL"]);
    }
    me.equipment.push(eq);
    c++;
}

if (me.equipment.length > 0) for (eq in me.equipment) if (eq.getvar("mqchoicemenu_option") <= 0 && eq.getvar("mqchoicemenu_header") <= 0 && eq.ready) {
    runscript("megaquest/moveequipment", [eq, 0, 2180 * direction]);
    eq.setvar("mqchoicemenu_notoption", 1);
    eq.ready = false;
}

sfx("_whoosh");
