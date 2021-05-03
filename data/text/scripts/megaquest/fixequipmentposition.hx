if (args[0].equipment.length > 0) for (eq in args[0].equipment) if (eq.finalpos != null) {
    runscript("megaquest/moveequipment", [eq, 0, 0]);
}
