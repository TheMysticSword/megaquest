if (args[0].getvar("mqalchemistremix") == 1) {
    var lb = rand(loaddata("megaquest/remixes/alchemist"));
    args[0].setvar("mqalchemistremix_lb", lb.normal);
    args[0].setvar("mqalchemistremix_lb_weakened", lb.weakened);
}
