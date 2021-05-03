if (args[0].finalpos != null) {
    args[0].finalpos = new openfl.geom.Point(args[0].finalpos.x + args[1], args[0].finalpos.y + args[2]);
} else {
    args[0].finalpos = new openfl.geom.Point(args[0].x + args[1], args[0].y + args[2]);
}
new motion.actuators.SimpleActuator(args[0], 0.5, {x: args[0].finalpos.x, y: args[0].finalpos.y}).move();
