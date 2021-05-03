var bosses = [];
var allenemies = getenemy(6, []);
for (enemyname in allenemies) {
    var fighter = new elements.Fighter(enemyname);
    if (fighter.template.boss) {
        bosses.push(enemyname);
    }
    fighter.dispose();
}
return bosses;
