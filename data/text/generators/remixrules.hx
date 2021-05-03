//Generate the level, and then choose remixes that go well with it.
//Does some very basic markov chaining to ensure interesting answers that can react to what you've selected
Remix.reset();

//Making a function to check this because I'm dumb and keep getting it wrong
function isenemyindungeon(enemyname){
  var enemylist = getenemylistindungeon();
  if(enemylist.indexOf(enemyname) == -1) return false;
  return true;
}

function preventclashes(){
  //Generic setup: define some remixes that should never occur at the same time
  Remix.preventclash(['Lady Luck', 'The Inventor']); //Inventor has the same effect, except it affects only the boss

  Remix.preventclash(['Warlock', 'Frog']); //This combintation doesn't work
  Remix.preventclash(['Warlock', 'Rose']); //This combintation doesn't work
  Remix.preventclash(['Warlock', 'Baby Squid']); 
  Remix.preventclash(['Warlock', 'Fireman']);
  Remix.preventclash(['Warlock', 'Snowman']);
  Remix.preventclash(['Warlock', 'Dryad']); //Dryad rule doesn't work that well with alt poison
}

function fillstandardlist(){
  var standardlist = ['Robobot', 'Cowboy', 'Baby Squid', 'Audrey'];
  var player = getplayername();
  
  standardlist = shuffle(standardlist);
  return standardlist;
}

function fillearlytwists(){
  var earlytwists = ['Wolf Puppy', 'Banshee', 'Keymaster', 'Rose', 'Alchemist'];
  var player = getplayername();

  //Offer Cactus only if 3 or more green things are in the dungeon
  var greenthings = 0;
  var greenthinglist = loadtext('megaquest/remixes/cactus');
  for (greenthing in greenthinglist) if (isenemyindungeon(greenthing)) greenthings++;
  if (greenthings >= 3) earlytwists.push('Cactus');

  //Don't offer the Warlock rule change if Drain Monster is in the Dungeon,
  //since Drain Monster doesn't work in Parallel Universe
  if(!isenemyindungeon('Drain Monster')) earlytwists.push('Warlock'); 
  
  earlytwists = shuffle(earlytwists);
  return earlytwists;
}

function fillmidtwists(){
  var midtwists = ['Sticky Hands', 'Haunted Jar', 'Wisp', 'Madison', 'Cornelius']; 
  var player = getplayername();
  
  midtwists = shuffle(midtwists);
  return midtwists;
}

function filllatelist(){
  var latelist = ['Drake', 'Singer', 'Vacuum', 'Handyman', 'Marshmallow'];
  var player = getplayername();

  //Warrior has access to a lot of shield equipment, so consider offering the Aoife rule for him as well
  if (isenemyindungeon('Aoife') || player == 'Warrior') latelist.push('Aoife');
  
  latelist = shuffle(latelist);
  return latelist;
}

function fillveryhardlist(){
  var veryhardlist = ['Scathach', 'Stereohead', 'Crystalina', 'Gargoyle', 'Bully'];

  //These mess with your build, so it's best to have them appear late when you have enough equipment to make a new build work
  //Also keep them rare for the surprise effect
  if (chance(33)) veryhardlist.push('Mimic');
  if (chance(33)) veryhardlist.push('Copycat');

  var playerrules = ['The Thief', 'The Robot', 'The Inventor', 'The Witch', 'The Jester'];
  if (!isenemyindungeon('Sudd N. Death')) playerrules.push('The Warrior'); //Sudd N. Death has a fixed time limit, so the health pool shouldn't be changed
  veryhardlist.push(rand(playerrules));
  
  veryhardlist = shuffle(veryhardlist);
  return veryhardlist;
}

function fillveryrare(){
  //Some remixes are very game defining, and it's better if they only come up very occasionally
  var veryrare = ['Bounty Hunter', 'Dire Wolf', 'Rotten Apple', 'Sorceress'];
  var player = getplayername();

  //This is a free rule, so keep it rare
  if (chance(33)) veryrare.push('Loud Bird');

  //Not fun as Witch, useless against Jester
  if (player != 'Witch' && player != 'Jester') veryrare.push('Frog');
  
  veryrare = shuffle(veryrare);
  return veryrare;
}

function addfireandicerules(standardlist, earlytwists, latelist){
  var player = getplayername();
  if(isenemyindungeon('Buster') || isenemyindungeon('Madison')){
    //We're fighting a fire boss, so offer fire rules
    earlytwists.push('Buster');
    earlytwists = shuffle(standardlist);
  }else{
    var fireenemycountcount = 0;
    var iceenemycountcount = 0;
    
    if(isenemyindungeon('Marshmallow')) { iceenemycountcount++; fireenemycountcount++; }
    if(isenemyindungeon('Aurora')) { iceenemycountcount++; fireenemycountcount++; }
    
    if(isenemyindungeon('Yeti')) iceenemycountcount+=2;
    if(isenemyindungeon('Snowman')) iceenemycountcount+=2;
    if(isenemyindungeon('Banshee')) iceenemycountcount+=2;
    
    if(isenemyindungeon('Fireman')) fireenemycountcount+=2;
    if(isenemyindungeon('Wisp')) fireenemycountcount+=2;
    if(isenemyindungeon('Wicker Man')) fireenemycountcount+=2;
    
    //We're fighting at least three of the fire enemies of level 3 or higher, so offer fire rules
    if(fireenemycountcount >= 5){
      standardlist.push('Fireman');
      standardlist = shuffle(standardlist);

      latelist.push('Paper Knight');
      latelist = shuffle(latelist);
    }
    
    //We're fighting at least three of the ice enemies of level 3 or higher, so offer ice rules
    if(iceenemycountcount >= 5){
      standardlist.push('Snowman');
      standardlist.push('Hothead');
      standardlist = shuffle(standardlist);
    } 
  }
}

function addcurserules(latelist){
  var cursecount = 0;
  if(isenemyindungeon('Banshee')) cursecount++;
  if(isenemyindungeon('Dire Wolf')) cursecount++;
  if(isenemyindungeon('Kraken')) cursecount++;
  if(isenemyindungeon('Skeleton')) cursecount++;
  if(cursecount >= 3 || isenemyindungeon('Scathach')){ //If there are more than 3 curse enemies or Scathach is the boss, offer a curse remix
    //To increase the odds of our curse remix showing up, we remove a few elements from the latelist
    while(latelist.length > 3) latelist.pop();
    latelist.push('Skeleton');
    latelist = shuffle(latelist);
  }
}

function addpoisonrules(standardlist, latelist){
  var poisoncount = 0;
  if(isenemyindungeon('Haunted Jar')) poisoncount++;
  if(isenemyindungeon('Rat King')) poisoncount++;
  if(isenemyindungeon('Drain Monster')) poisoncount++;
  if(isenemyindungeon('Dire Wolf')) poisoncount++;
  if(isenemyindungeon('Drake')) poisoncount+=2;
  if(poisoncount >= 2){
    //To increase the odds of our poison remix showing up, we remove a few elements from the standardlist and latelist
    while(standardlist.length > 3) standardlist.pop();
    standardlist.push('Slime');
    standardlist = shuffle(standardlist);

    while(latelist.length > 3) latelist.pop();
    latelist.push('Dryad');
    latelist = shuffle(latelist);
  }
}

preventclashes();
var standardlist = fillstandardlist();
var latelist = filllatelist();
var veryhardlist = fillveryhardlist();
var earlytwists = fillearlytwists();
var midtwists = fillmidtwists();
var veryrare = fillveryrare();

addfireandicerules(standardlist, earlytwists, latelist);
addcurserules(latelist);
addpoisonrules(standardlist, latelist);

//Really simple first draft, shuffle all the lists, assign them randomly
earlytwists = shuffle(earlytwists);
standardlist.push(earlytwists.pop());
standardlist = shuffle(standardlist);

midtwists = shuffle(midtwists);
latelist.push(midtwists.pop());
latelist.push(midtwists.pop()); //Add an extra mid twist to the late list to make it more interesting
latelist = shuffle(latelist);

//Figure out the final rule offerings
var finaloffer2 = [standardlist.pop(), standardlist.pop(), earlytwists.pop()];

//Add some stuff we don't want to appear in the first remix, e.g. curse and poison related things
var secondremixlist = [];
for(r in standardlist){
  secondremixlist.push(r);
}
secondremixlist = shuffle(secondremixlist);

var finaloffer3 = [secondremixlist.pop(), secondremixlist.pop()];
var finaloffer4 = [latelist.pop(), latelist.pop(), latelist.pop()];
while(latelist.length > 0) veryhardlist.push(latelist.pop());
veryhardlist = shuffle(veryhardlist);
var finaloffer5 = [veryhardlist.pop(), veryhardlist.pop(), veryhardlist.pop()];

//Insert twists!
if(chance(80)){
  //80% chance of seeing a twist
  if(chance(66)){
    if(chance(33)){
      finaloffer2.insert(0, earlytwists.pop());
    }else{
      finaloffer2.insert(1, earlytwists.pop());
    }
  }else{
    if(chance(66)){
      finaloffer2.insert(0, veryrare.pop());
    }else{
      finaloffer2.insert(1, veryrare.pop());
    }
  }
}

//To ensure we never run out, fill up the arrays with the rest of the options
if(midtwists.length > 0) finaloffer3.push(midtwists.pop());
if(standardlist.length > 0) finaloffer2.push(standardlist.pop());
if(standardlist.length > 0) finaloffer3.push(standardlist.pop());
if(standardlist.length > 0) finaloffer2.push(standardlist.pop());
if(standardlist.length > 0) finaloffer3.push(standardlist.pop());
if(earlytwists.length > 0) finaloffer2.push(earlytwists.pop());
if(earlytwists.length > 0) finaloffer3.push(earlytwists.pop());
if(midtwists.length > 0) finaloffer4.push(midtwists.pop());
if(midtwists.length > 0) finaloffer5.push(midtwists.pop());
if(veryhardlist.length > 0) finaloffer4.push(veryhardlist.pop());
if(veryhardlist.length > 0) finaloffer5.push(veryhardlist.pop());
if(veryhardlist.length > 0) finaloffer4.push(veryhardlist.pop());
if(veryhardlist.length > 0) finaloffer5.push(veryhardlist.pop());
if(standardlist.length > 0) finaloffer4.push(standardlist.pop());
if(standardlist.length > 0) finaloffer5.push(standardlist.pop());

//Offer Banshee only before the 2nd floor. It replaces equipment found on later floors and
//we don't want to accidentally replace equipment that's already inside the player's inventory
if(finaloffer3.indexOf('Banshee') > -1) finaloffer3.remove('Banshee');
if(finaloffer4.indexOf('Banshee') > -1) finaloffer4.remove('Banshee');
if(finaloffer5.indexOf('Banshee') > -1) finaloffer5.remove('Banshee');

Remix.offer(2, '', finaloffer2);
Remix.offer(3, '', finaloffer3);
Remix.offer(4, '', finaloffer4);
Remix.offer(5, '', finaloffer5);