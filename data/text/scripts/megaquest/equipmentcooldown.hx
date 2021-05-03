var addNew = true;
var cooldownEquipment = args[2].getvar("mqcooldownequipment");
if (cooldownEquipment.length != null && cooldownEquipment.length > 0) {
    cooldownEquipment = cooldownEquipment.copy();
    for (cd in cooldownEquipment) {
        if (cd.eq == args[0]) {
            cd.count += args[1] + 1;
            addNew = false;
            break;
        }
    }
} else {
    cooldownEquipment = [];
}
if (addNew) {
    cooldownEquipment.push({
        count: args[1] + 1,
        eq: args[0]
    });
}
args[2].setvar("mqcooldownequipment", cooldownEquipment);
