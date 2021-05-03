// Calls a function after a specified amount of time.
// Argument 1 - The function you want to call. Must take an array as the only argument.
// Argument 2 - Delay time in seconds.
// Other arguments will be passed to the function as an array of values.
var actDelayedFunction = new motion.actuators.SimpleActuator(null, runscript("megaquest/math/max", [args[1], 1 / 60]), null);
var funcDelayedFunction = new hscript.Parser().parseString("f(args);");
var interp = new hscript.Interp();
interp.variables.set("f", args[0]);
interp.variables.set("args", args.slice(2));
actDelayedFunction.onComplete(interp.execute, [funcDelayedFunction]);
actDelayedFunction.move();
