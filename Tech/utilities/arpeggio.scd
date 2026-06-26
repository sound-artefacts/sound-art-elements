	var trig = Impulse.ar(0);


////.do iteration with (below) at the end
enva = EnvGen.ar(Env.perc(attack, decay, amp/under, [-4, -4]), trig);

trig = TDelay.ar(trig,dur);   ///dur is the arpeggio time interval