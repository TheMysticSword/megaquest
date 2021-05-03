var fighter = args[0];
var add = args[1];
if (fighter.usecpuinsteadofdice) {
    add *= 2;
    fighter.addstatus("mqcpu" + (add > 0 ? "+" : "-"), add > 0 ? add : -add);
    var temp = fighter.getstatus("mqcpu+");
    if (fighter.getstatus("mqcpu-") > 0) for (i in 0...fighter.getstatus("mqcpu-")) fighter.decrementstatus("mqcpu+", true);
    if (temp > 0) for (i in 0...temp) fighter.decrementstatus("mqcpu-", true);
    fighter.roll_target += add;
} else {
    fighter.extradice += add;
}
