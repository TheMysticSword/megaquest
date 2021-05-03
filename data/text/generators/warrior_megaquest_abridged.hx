var thisgenerator = "warrior_megaquest";
var extragenerator = "warrior_normal";
var warriorshops = [];
var strangeshop = [];
var awesomelist = [];
var floor2gooditem = [];
var floor3item = [];
var floor5item = [];
var vampireitem = [];
var itempools = [warriorshops, strangeshop, awesomelist, floor2gooditem, floor3item, floor5item, vampireitem]; //Initialize lists like this for clarity

/*NOTICE TO MODDERS:
  All you need to do to get your items in here is append the name of your mod to:
    diceydungeons/itempools/[this generator's name minus file extension]/scriptstorun.txt
  Then add a .hx script of the appropriate name to that directory that returns an array containing arrays of items
  you want to add to each of the generator's item pools. Use the vanilla script for this generator for reference -
  it's important you return the right amount of arrays!
  
  (If you want to replace the generator entirely, in case you have an extremely specific item pool in mind, you should
  get rid of declaring scriptstorun and the "for scriptname in scriptstorun" bit. - but note it will no longer be quite as
  compatible with other mods.)*/
  
itempools = runscript("megaquest/flexible_generator",[thisgenerator,extragenerator,itempools]);

var warriorshops = itempools[0];
var strangeshop = itempools[1];
var awesomelist = itempools[2];
var floor2gooditem = itempools[3];
var floor3item = itempools[4];
var floor5item = itempools[5];
var vampireitem = itempools[6];

var _level1enemies = shuffle(level1enemies.copy());
var _level2enemies = shuffle(level2enemies.copy());
var _level3enemies = shuffle(level3enemies.copy());
var _level4enemies = shuffle(level4enemies.copy());
var _level5enemies = shuffle(level5enemies.copy());
var _super1enemies = shuffle(runscript("megaquest/getsuperenemies", [1]));
var _super2enemies = shuffle(runscript("megaquest/getsuperenemies", [2]));
var _super3enemies = shuffle(runscript("megaquest/getsuperenemies", [3]));
var _super4enemies = shuffle(runscript("megaquest/getsuperenemies", [4]));
var _super5enemies = shuffle(runscript("megaquest/getsuperenemies", [5]));
var _bosses = shuffle(runscript("megaquest/getbosses"));

usestandardenemies(false);

var items = [];
var gooditems = [];
var otherstuff = [];
var goodotherstuff = [];

//Floor 2:
items = [];
gooditems = [floor2gooditem.pop(), awesomelist.pop()];
otherstuff = [health()];
goodotherstuff = [
  shop(
    [warriorshops.pop(), warriorshops.pop(), warriorshops.pop()],
    [pick([1, 2]), pick([1, 2]), pick([1, 2])]
  )
];

addfloor("small")
  .additems(items, gooditems)
  .addotherstuff(otherstuff, goodotherstuff)
  .addenemies([_super1enemies.pop()], [_level3enemies.pop(), _level3enemies.pop()])
  .generate();

//Floor 5:
items = [];
items.push(floor5item.pop());
gooditems = [];

otherstuff = [health(), health()];
goodotherstuff = [
  upgrade(),
  shop(["upgrade", warriorshops.pop(), warriorshops.pop()], [4, 4, 4])
];

addfloor("big")
  .additems(items, gooditems)
  .addotherstuff(otherstuff, goodotherstuff)
  .addenemies([_super3enemies.pop()], [_level5enemies.pop(), _level5enemies.pop(), _level5enemies.pop()])
  .generate();

//Floor 6:
items = [];
gooditems = [];
otherstuff = [];
goodotherstuff = [];

var lastfloor = addfloor("boss");
var finalboss = _bosses.pop();

if (finalboss == "Drake"){
  items.push(vampireitem.pop());
}

lastfloor
  .additems(items, gooditems)
  .setlocation('BOSS')
  .addotherstuff(otherstuff, goodotherstuff)
  .addenemies([], [finalboss])
  .generate();