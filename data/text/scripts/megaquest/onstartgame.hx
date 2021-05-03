var alwaysinbeginning = "
    var statuses = [FIRE, ICE, SHIELD, DODGE];

    function beforestartturn(fighter) {
        var cooldownEquipment = fighter.getvar(\"mqcooldownequipment\");
        if (cooldownEquipment.length != null && cooldownEquipment.length > 0) {
            cooldownEquipment = cooldownEquipment.copy();
            for (cd in cooldownEquipment.copy()) {
                cd.count--;
                if (cd.count > 0) {
                    if (fighter.isplayer) cd.eq.availablethisturn = false;
                    else cd.eq.availablenextturn = false;
                    cd.eq.unavailabletext = cd.eq.displayname + cd.eq.namemodifier;
                    cd.eq.unavailabledetails = [
                        \"Unavailable (Cooldown)\",
                        \"Ready in \" + cd.count + \" turn\" + (cd.count > 1 ? \"s\" : \"\")
                    ];
                } else {
                    cd.eq.availablethisturn = true;
                    cooldownEquipment.remove(cd);
                }
            }
        }
        fighter.setvar(\"mqcooldownequipment\", cooldownEquipment);
        
        var gotchaEquipment = fighter.getvar(\"mqgotchaequipment\");
        if (gotchaEquipment.length != null && gotchaEquipment.length > 0) {
            for (eq in gotchaEquipment) {
                if (fighter.isplayer) eq.availablethisturn = false;
                else eq.availablenextturn = false;
                eq.unavailabletext = \"Gotcha!\";
                eq.unavailabledetails = [
                    \"{enemyname} keeps this\",
                    \"until the fight ends\"
                ];
            }
        }
    }
";

Rules.addextrascript(alwaysinbeginning + "
    for (status in statuses) {
        status = status.toLowerCase();

        if (self.getvar(\"mqnextfight\" + status) > 0) {
            self.addstatus(status, self.getvar(\"mqnextfight\" + status));
            self.setvar(\"mqnextfight\" + status, 0);
        }
    }

    self.setvar(\"mqcombatend\", 0);
    target.setvar(\"mqcombatend\", 0);

    if (self.getvar(\"mqalchemistremix\") == 1) {
        var lb = self.getvar(\"mqalchemistremix_lb\");
        var lb_weakened = self.getvar(\"mqalchemistremix_lb_weakened\");
        self.template.limit = lb;
        self.template.alternatelimit = lb_weakened;
        self.changelimitbreak(lb);
    }
", "startcombat");

Rules.addextrascript(alwaysinbeginning + "
    self.setvar(\"mqmyturn\", 1);
    target.setvar(\"mqmyturn\", 0);

    beforestartturn(self);
", "beforestartturn");

Rules.addextrascript(alwaysinbeginning + "
    if (self.getvar(\"mqchoicemenu_reopen\") == 1) {
        self.setvar(\"mqchoicemenu_reopen\", 0);
        runscript(\"megaquest/choicemenu\", self.getvar(\"mqchoicemenu_reopen_args\"));
    }

    if (self.getvar(\"mqghosthouse\") == 1) {
        var alleq = [];
        self.setvar(\"mqghosthouse\", 0);
        var c = 0;
        while ((\"\" + self.getvar(\"mqghosthouse\" + c)) != \"0\") {
            var eq = runscript(\"megaquest/createequipment\", [self.getvar(\"mqghosthouse\" + c), false, false, 0, 0, self, true]);
            eq.temporary_thisturnonly = true;
            eq.usesleft = 0;
            eq.reuseable = 0;
            alleq.push(eq);
            eq.y = eq.castdirection == 1 ? 2180 + eq.height * 0.5 : -eq.height * 1.5;
            runscript(\"megaquest/delaycall\", [function (args) {
                runscript(\"megaquest/snap\", [args[0], args[1], args[2], args[3]]);
            }, c * 0.5, eq, self, target]);
            self.setvar(\"mqghosthouse\" + c, 0);
            c++;
        }
        if (alleq.length > 0) {
            for (eq in alleq) {
                eq.x = 3180 / (alleq.length + 1) * (alleq.indexOf(eq) + 1);
            }
        }
    }
", "onstartturn");

Rules.addextrascript(alwaysinbeginning + "
    self.setvar(\"mqmyturn\", 0);
    target.setvar(\"mqmyturn\", 1);

    beforestartturn(target);
", "endturn");

Rules.addextrascript(alwaysinbeginning + "
    self.setvar(\"mqchoicemenu_reopen\", 0);
    self.setvar(\"mqchoicemenu_reopen_args\", 0);
    self.setvar(\"mqcooldownequipment\", 0);
    self.setvar(\"mqgotchaequipment\", 0);
    self.setvar(\"mqcombatend\", 1);
    target.setvar(\"mqcombatend\", 1);
", "aftercombat");

var oneachequipmentuse = "";
Rules.addextrascript(alwaysinbeginning + oneachequipmentuse, "playerequipmentuse");
Rules.addextrascript(alwaysinbeginning + oneachequipmentuse, "enemyequipmentuse");
