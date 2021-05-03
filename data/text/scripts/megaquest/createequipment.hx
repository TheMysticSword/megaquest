var e = new elements.Equipment(args[0], args[1]);
if (args[2]) e.downgrade();
e.x = args[3];
e.y = args[4];
e.equippedby = args[5];
e.temporary_thisturnonly = args[6];
args[5].equipment.push(e);
return e;
