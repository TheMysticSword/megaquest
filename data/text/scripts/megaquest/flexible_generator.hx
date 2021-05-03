//Duplicate of diceydungeons/flexible_generator.hx with modifications for Megaquest episodes
 
if(args.length == 0){
	trace("Error: no generator name supplied.");
	return;
}else if(args.length == 1){
	trace("Error: no extra generator name supplied.");
}else if(args.length == 2){
	trace("Error: no empty lists supplied.");
}else{
	var thisgenerator = args[0];
	var extragenerator= args[1];
	var itempools     = args[2];
	var scriptstorun = loadtext("diceydungeons/itempools/" + thisgenerator + "/scriptstorun").concat(loadtext("diceydungeons/itempools/" + extragenerator + "/scriptstorun"));
	if (scriptstorun.indexOf("vanilla") != -1) scriptstorun.remove("vanilla");
	if (scriptstorun.length > 0) for(scriptname in scriptstorun) {
		var itemstoadd = runscript("diceydungeons/itempools/" + thisgenerator + "/" + scriptname);
		for(i in 0...itempools.length) {
			itempools[i] = itempools[i].concat(itemstoadd[i]);
			if(itemstoadd[i].length > 0) shuffle(itempools[i]);
		}
	}
	return itempools;
}