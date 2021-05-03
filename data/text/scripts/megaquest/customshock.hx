var e = args[0];
e.shockedtext = args[3];
e.shockedcol = runscript("megaquest/getpalcolour", [args[4]]);
e.shocked_showtitle = args[5];
e.shockedtype = runscript("megaquest/getdiceslottype", [args[1]]);
e.shockedsetting = args[2];
e.positionshockslots();
