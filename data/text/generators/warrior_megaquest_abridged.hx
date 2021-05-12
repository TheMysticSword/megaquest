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

function getrandomenemy(allenemies, getsuper) {
  if (!getsuper) {
    var enemy = allenemies.pop();
    allenemies.remove(enemy);
    return enemy;
  } else {
    var superenemies = [];
    for (enemyname in allenemies) {
        var fighter = new elements.Fighter(enemyname);
        if (fighter.template.hassuper) {
            superenemies.push(enemyname);
        }
        fighter.dispose();
    }
    var superenemy = superenemies.pop();
    allenemies.remove(superenemy);
    return "Super " + superenemy;
  }
}

usestandardenemies(false);

var items = [];
var gooditems = [];
var otherstuff = [];
var goodotherstuff = [];

//Floor 2:
items = [];
gooditems = [floor2gooditem.pop()];
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
  .addenemies([getrandomenemy(level1enemies, true)], [getrandomenemy(level3enemies, false), getrandomenemy(level3enemies, false)])
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
  .addenemies([getrandomenemy(level3enemies, true)], [getrandomenemy(level5enemies, false), getrandomenemy(level5enemies, false), getrandomenemy(level5enemies, false)])
  .generate();

//Floor 6:
items = [];
gooditems = [];
otherstuff = [];
goodotherstuff = [];

var lastfloor = addfloor("boss");
var finalboss = getrandomenemy(level6enemies, false);

if (finalboss == "Drake"){
  items.push(vampireitem.pop());
}

lastfloor
  .additems(items, gooditems)
  .setlocation('BOSS')
  .addotherstuff(otherstuff, goodotherstuff)
  .addenemies([], [finalboss])
  .generate();

var lvluprewards = "";
for (x in awesomelist) lvluprewards += "Equipment:" + x + ",";
lvluprewards = lvluprewards.substr(0, lvluprewards.length - 1);
Rules.substitute("mqabridged_leveluprewards", lvluprewards);
