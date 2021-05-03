var possiblevalues = [];
for (i in args[0]...args[1]) {
    possiblevalues.push(i);
}
return rand(possiblevalues);
