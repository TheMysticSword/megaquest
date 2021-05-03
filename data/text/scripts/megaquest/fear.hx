//Create a puzzle where you need to use all dice and all equipment with variable difficulty

var hints_in_console = true; //Trace the solution to the console

//Load arguments from the status script
var difficulty = args[0];
var loaddata = args[1];
var _self = args[2];
var _target = args[3];
var turn = args[5];

var newdice = []; //Starting dice
var currentdice = []; //Dice that we will do simulation on
var c = 0;
//Create starting dice values
for (i in 0...(runscript("megaquest/math/floor", [difficulty / 3]) + 2)) {
	var dval = (c % 6) + 1;
	newdice.push(dval);
	currentdice.push(dval);
	c++;
}
var newequipment = [];
var equipmentchoices = [];
//Populate the list of data of possible puzzle equipment
for (feareq in loaddata("megaquest/fear")) {
	var equipmentchoice = {name: feareq.name, complexity: feareq.complexity};
	var eq = new elements.Equipment(feareq.name);

    equipmentchoice.size = eq.size;
    equipmentchoice.parsedscript = new hscript.Parser().parseString(eq.script); //We will simulate the equipment's script later
    var canuse = ""; //Script that checks whether this equipment can be used with the current set of simulation dice based on comparing slots and dice values
    if (eq.needstotal != 0) {
        canuse += "
            totalfilled = " + eq.needstotal + ";
        ";
        equipmentchoice.needstotal = eq.needstotal;
    } else {
        canuse += "
            totalfilled = 1000000;
        ";
    }
    var slots = eq.getslots();
    if (slots.length > 0) for (slot in slots.copy()) {
        if (slot.indexOf("DOUBLES") != -1) {
            canuse += "
                bool1 = false;
                float1 = 0;
                if (indice.length > 0) for (i in 0...indice.length) {
                    if ((indice.length - float1) > 0) for (j in float1...indice.length) if (i != j) {
                        if (indice[j] == indice[i]) {
                            bool1 = true;
                            totalfilled = 0;
                            outdice.push(indice[i]);
                            outdice.push(indice[i]);
                            indice.remove(indice[i]);
                            indice.remove(indice[i]);
                            break;
                        }
                    }
                    float1++;
                    if (bool1) break;
                }
                if (!bool1) canuse = false;
            ";
            slots.remove(slot);
        }
    }
    if (slots.length > 0) for (slot in slots.copy()) {
        if (slot.indexOf("REQUIRE") != -1) {
            canuse += "
                bool1 = false;
                if (indice.length > 0) for (d in indice.copy()) {
                    if (d == " + slot.substr("REQUIRE".length) + " && totalfilled > 0) {
                        bool1 = true;
                        totalfilled -= d;
                        indice.remove(d);
                        outdice.push(d);
                        break;
                    }
                }
                if (!bool1) canuse = false;
            ";
            slots.remove(slot);
        }
    }
    if (slots.length > 0) for (slot in slots.copy()) {
        if (slot.indexOf("MIN") != -1) {
            canuse += "
                bool1 = false;
                if (indice.length > 0) for (d in indice.copy()) {
                    if (d >= " + slot.substr("MIN".length) + " && totalfilled > 0) {
                        bool1 = true;
                        totalfilled -= d;
                        indice.remove(d);
                        outdice.push(d);
                        break;
                    }
                }
                if (!bool1) canuse = false;
            ";
            slots.remove(slot);
        }
    }
    if (slots.length > 0) for (slot in slots.copy()) {
        if (slot.indexOf("MAX") != -1) {
            canuse += "
                bool1 = false;
                if (indice.length > 0) for (d in indice.copy()) {
                    if (d <= " + slot.substr("MAX".length) + " && totalfilled > 0) {
                        bool1 = true;
                        totalfilled -= d;
                        indice.remove(d);
                        outdice.push(d);
                        break;
                    }
                }
                if (!bool1) canuse = false;
            ";
            slots.remove(slot);
        }
    }
    if (slots.length > 0) for (slot in slots.copy()) {
        if (slot.indexOf("RANGE") != -1) {
            canuse += "
                bool1 = false;
                if (indice.length > 0) for (d in indice.copy()) {
                    if (d >= " + slot.substr("RANGE".length + 1, 1) + " && d <= " + slot.substr("RANGE".length + 1, 1) + " && totalfilled > 0) {
                        bool1 = true;
                        totalfilled -= d;
                        indice.remove(d);
                        outdice.push(d);
                        break;
                    }
                }
                if (!bool1) canuse = false;
            ";
            slots.remove(slot);
        }
    }
    if (slots.length > 0) for (slot in slots.copy()) {
        if (slot.indexOf("EVEN") != -1) {
            canuse += "
                bool1 = false;
                if (indice.length > 0) for (d in indice.copy()) {
                    if ((d % 2) == 0 && totalfilled > 0) {
                        bool1 = true;
                        totalfilled -= d;
                        indice.remove(d);
                        outdice.push(d);
                        break;
                    }
                }
                if (!bool1) canuse = false;
            ";
            slots.remove(slot);
        }
    }
    if (slots.length > 0) for (slot in slots.copy()) {
        if (slot.indexOf("ODD") != -1) {
            canuse += "
                bool1 = false;
                if (indice.length > 0) for (d in indice.copy()) {
                    if ((d % 2) == 1 && totalfilled > 0) {
                        bool1 = true;
                        totalfilled -= d;
                        indice.remove(d);
                        outdice.push(d);
                        break;
                    }
                }
                if (!bool1) canuse = false;
            ";
            slots.remove(slot);
        }
    }
    if (slots.length > 0) for (slot in slots.copy()) {
        if (slot.indexOf("NORMAL") != -1) {
            canuse += "
                if (indice.length > 0) for (d in indice.copy()) if (totalfilled > 0) {
                    totalfilled -= d;
                    indice.remove(d);
                    outdice.push(d);
                    break;
                }
            ";
            slots.remove(slot);
        }
    }
    if (slots.length > 0) for (slot in slots.copy()) {
        if (slot.indexOf("COUNTDOWN") != -1) {
            canuse += "
                bool1 = false;
                float1 = " + slot.substr("COUNTDOWN_".length) + ";
                arr1 = [];
                if (indice.length > 0) for (d in indice.copy()) {
                    float1 -= d;
                    arr1.push(d);
                    if (float1 <= 0) {
                        bool1 = true;
                        break;
                    }
                }
                if (!bool1) canuse = false;
                else {
                    if (arr1.length > 0) for (d in arr1) {
                        indice.remove(d);
                        outdice.push(d);
                    }
                }
            ";
            slots.remove(slot);
        }
    }
    if (eq.needstotal != 0) {
        canuse += "
            if (totalfilled != 0) canuse = false;
        ";
    }
    equipmentchoice.canuse = new hscript.Parser().parseString(canuse);

    equipmentchoices.push(equipmentchoice);
}
//Create script interpreters for the simulation and canuse scripts
var interp_canuse = new hscript.Interp();
var interp_parsedscript = new hscript.Interp();
interp_parsedscript.variables.set("trace", trace);
interp_parsedscript.variables.set("rand", rand);
interp_parsedscript.variables.set("pick", pick);
interp_parsedscript.variables.set("bonus", function (arg) {});
interp_parsedscript.variables.set("givedice", function (arg, ?soundevent) { //Define givedice() as a custom simulation function
    if (arg.length == null) {
        args[4].push(arg); //Use an empty global variable - this is the only way to get something outside of a function declared inside hscript!
    } else {
        if (arg.length > 0) for (d in arg) args[4].push(d);
    }
});
interp_parsedscript.variables.set("self", _self);
interp_parsedscript.variables.set("target", _target);
interp_parsedscript.variables.set("simulation", true);
interp_parsedscript.variables.set("turn", turn);
var totalsize = 6; //Let's add a max amount of slots we can fill, just in case we have too many choices
var minchoices = 3; //Don't add too few equipment
var totalcomplexity = 2 + difficulty * 2; //Add a cap on how complex the puzzle can be based on the equipment's complexity value
var maxcomplexity = runscript("megaquest/math/max", [totalcomplexity - 2, 1]); //Don't create equipment with max complexity to prevent puzzles with only one equipment
//Do the puzzle-creation algorithm with simulation!
if (hints_in_console) trace("Megaquest Fear puzzle solution (turn + " + turn + "):");
var step = 1;
while (totalcomplexity > 0 && totalsize > 0) {
    var eqchoiceadded = false;
    var equipmentchoices_current = shuffle(equipmentchoices.copy());
    while (!eqchoiceadded) {
        var choice = equipmentchoices_current.pop();
        if (choice.size > totalsize) break;
        if (choice.complexity > totalcomplexity || choice.complexity > maxcomplexity) break;
        //Execute the "can we use this equipment" simulation
        interp_canuse.variables.set("indice", shuffle(currentdice.copy()));
        interp_canuse.variables.set("outdice", []);
        interp_canuse.variables.set("totalfilled", 0);
        interp_canuse.variables.set("canuse", true);
        interp_canuse.variables.set("bool1", false);
        interp_canuse.variables.set("float1", 0);
        interp_canuse.variables.set("arr1", []);
        interp_canuse.execute(choice.canuse);
        if (!interp_canuse.variables.get("canuse")) break;
        //Grab results from the canuse simulation
        currentdice = interp_canuse.variables.get("indice").copy(); //Dice that we didn't use
        var outdice = interp_canuse.variables.get("outdice").copy(); //Dice that we put inside the equipment and don't have anymore
        if (hints_in_console) trace(" " + step + ". " + choice.name + ": " + outdice);
        var actualdice = [];
        var dsum = 0;
        if (outdice.length > 0) for (mydiceval in outdice) {
            dsum += mydiceval;
            actualdice.push({basevalue: mydiceval});
        }
        interp_parsedscript.variables.set("d", dsum);
        interp_parsedscript.variables.set("actualdice", actualdice);
        args[4] = []; //See givedice()
        //Execute the equipment script simulation
        interp_parsedscript.execute(choice.parsedscript);
        if (args[4].length > 0) for (d in args[4]) currentdice.push(d); //Add dice that we got from the equipment to our current dice
        eqchoiceadded = true;
        totalsize -= choice.size;
        totalcomplexity -= choice.complexity;
        minchoices -= 1;
        if (totalcomplexity <= 0 && minchoices > 0) totalcomplexity = 1;
        newequipment.push(choice.name);
        step++;
    }
}
//Create equipment from generated equipment choices
if (newequipment.length > 0) for (eqname in newequipment) {
    var eq = new elements.Equipment(eqname);
    eq.equippedby = _self;
    eq.x = 3840 + eq.width * 0.5;
    eq.changecolour("GRAY");
    _self.equipment.push(eq);
}
//Create the unique Overcome card where you put the result dice and get rid of the fear status safely
var overcome = new elements.Equipment("Overcome");
overcome.equippedby = _self;
overcome.x = 3840 + overcome.width * 0.5;
overcome.countdown = 0;
if (currentdice.length > 0) for (d in currentdice) {
    overcome.countdown += d; //Set the countdown to the sum of result dice
}
overcome.maxcountdown = overcome.countdown;
overcome.remainingcountdown = overcome.countdown;
_self.equipment.push(overcome);
//Give ourselves the starting dice
for (d in newdice) _self.addstatus("stash" + d, 1);
