usestandardenemies(false);

var items = [];
var gooditems = [];
var otherstuff = [];
var goodotherstuff = [];
var enemies = [];
var hardenemies = [];

// Floor 1:
items = [];
gooditems = [];
otherstuff = [];
goodotherstuff = [];
enemies = ['Snek', 'Lumberjack', 'Rocket Rider', 'Kompuutah', 'Rammy', 'Dummy', 'Sudd N. Death'];
hardenemies = [];

var floor = addfloor('mqtest')
  .addenemies(enemies, hardenemies)
  .additems(items, gooditems)
  .addotherstuff(otherstuff, goodotherstuff)
  .setlocation('GAMESHOW')
  .generate();

// Floor 2:
items = [];
gooditems = [];
otherstuff = [];
goodotherstuff = [];
enemies = [];
hardenemies = ['Sudd N. Death'];

var finalfloor = addfloor('boss')
  .addenemies(enemies, hardenemies)
  .additems(items, gooditems)
  .addotherstuff(otherstuff, goodotherstuff)
  .setlocation('BOSS')
  .generate();

for (node in finalfloor.nodes) {
  if (node.type == 'ENEMY') {
    node.enemytemplate.level = 6;
  }
}