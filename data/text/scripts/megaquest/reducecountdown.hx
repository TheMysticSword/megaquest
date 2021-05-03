var mydice = new elements.Dice();
mydice.basevalue = args[1];
args[0].assigndice(mydice);
mydice.assigned = args[0];
self.dicepool.push(mydice);
