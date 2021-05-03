var actRepeatedFunction = new motion.actuators.SimpleActuator(null, runscript("megaquest/math/max", [args[1], 1 / 60]), null);
actRepeatedFunction.repeat(args[2]);
var funcRepeatedFunction = new hscript.Parser().parseString("
    f(args, actRepeatedFunction);
");
var interp = new hscript.Interp();
interp.variables.set("f", args[0]);
interp.variables.set("args", args.slice(3));
interp.variables.set("actRepeatedFunction", actRepeatedFunction);
actRepeatedFunction.onRepeat(interp.execute, [funcRepeatedFunction]);
actRepeatedFunction.move();
