var level = args[0];
var superenemies = [];
var allenemies = getenemy(level, []);
for (enemyname in allenemies) {
    var fighter = new elements.Fighter(enemyname);
    if (fighter.template.hassuper) {
        superenemies.push("Super " + enemyname);
    }
    fighter.dispose();
}
return superenemies;
