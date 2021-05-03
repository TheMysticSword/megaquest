if (args[0].getvar("mqspecialdice") == 0) {
    args[0].setvar("mqspecialdice", 1);
    var actSpecialDice = new motion.actuators.SimpleActuator(null, 1, null);
    actSpecialDice.repeat(-1);
    var funcSpecialDice = new hscript.Parser().parseString("
        if (self.dicepool.length > 0) for (mydice in self.dicepool) {
            if (mydice.basevalue < 1 || mydice.basevalue > 6) {
                mydice.flash += 0.1;
                runscript(\"megaquest/textparticle\", [mydice, \"\" + mydice.basevalue, 0xFFFFFF]);
            }
        }
        if (self.getvar(\"mqmyturn\") == 0) {
            actSpecialDice._repeat = 0;
            self.setvar(\"mqspecialdice\", 0);
        }
    ");
    var interp = new hscript.Interp();
    interp.variables.set("self", args[0]);
    interp.variables.set("runscript", runscript);
    interp.variables.set("actSpecialDice", actSpecialDice);
    interp.execute(funcSpecialDice);
    actSpecialDice.onRepeat(interp.execute, [funcSpecialDice]);
    actSpecialDice.move();
}
