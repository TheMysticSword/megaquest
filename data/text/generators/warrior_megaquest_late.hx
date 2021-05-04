var thisgenerator = "warrior_megaquest_late";
var extragenerator = "warrior_remixgenerator";
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



usestandardenemies();

var items = [];
var gooditems = [];
var otherstuff = [];
var goodotherstuff = [];

//Floor 1:
items = [];
gooditems = [awesomelist.pop()];
otherstuff = [];
goodotherstuff = [];

addfloor("tiny")
  .additems(items, gooditems)
  .addotherstuff(otherstuff, goodotherstuff)
  .generate();

//Floor 2:
items = [];
gooditems = [floor2gooditem.pop()];
otherstuff = [health()];
goodotherstuff = [shop([warriorshops.pop(), warriorshops.pop(), warriorshops.pop()])];

addfloor("small")
  .additems(items, gooditems)
  .addotherstuff(otherstuff, goodotherstuff)
  .generate();

//Floor 3:
items = [];
items.push(floor3item.pop());
gooditems = [];

otherstuff = [health(), health()];

goodotherstuff = [
  shop([warriorshops.pop(), warriorshops.pop(), warriorshops.pop()]),
  upgrade()
];

addfloor("normal")
  .additems(items, gooditems)
  .addotherstuff(otherstuff, goodotherstuff)
  .generate();
  
//Floor 4:
items = [];
gooditems = [awesomelist.pop()];

otherstuff = [health()];
goodotherstuff = [
  trade(["any"], [awesomelist.pop()])
];

addfloor("normal")
  .additems(items, gooditems)
  .addotherstuff(otherstuff, goodotherstuff)
  .generate();
  
//Floor 5:
items = [];
items.push(floor5item.pop());
gooditems = [];

otherstuff = [health(), health()];
goodotherstuff = [
  upgrade(),
  shop(["upgrade", strangeshop.pop(), "health"], [4, 4, 4])
];

addfloor("big")
  .additems(items, gooditems)
  .addotherstuff(otherstuff, goodotherstuff)
  .generate();

//Floor 6:
usestandardenemies(false);
items = [];
gooditems = [];
otherstuff = [];
goodotherstuff = [];

var lastfloor = addfloor("boss");
var finalboss = "";
var superfinalboss = false;

// Add a super level 5 enemy instead of a regular boss!
var superenemies = [];
for (enemyname in level5enemies) {
  var fighter = new elements.Fighter(enemyname);
  if (fighter.template.hassuper) {
    superenemies.push(enemyname);
  }
  fighter.dispose();
}
if (superenemies.length > 0) {
  finalboss = rand(superenemies);
  level5enemies.remove(finalboss);
  superfinalboss = true;
} else {
  trace("Error: no super level 5 enemies found. Falling back to regular boss spawn");
  finalboss = level6enemies.pop();
}

if (finalboss == "Drake"){
  items.push(vampireitem.pop());
}

if (superfinalboss) finalboss = "Super " + finalboss;

lastfloor
  .addenemies([], [finalboss])
  .additems(items, gooditems)
  .setlocation('BOSS')
  .addotherstuff(otherstuff, goodotherstuff)
  .generate();