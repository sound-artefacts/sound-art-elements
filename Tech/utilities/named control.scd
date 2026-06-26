		 var wrappedOut1 = { |busArray, signalArray|
			 	[busArray, signalArray].flop.do { |pair|
			 Out.ar(pair[0], pair[1])}};
			 var wrappedOut2 = { |busArray, signalArray|
			 	[busArray, signalArray].flop.do { |pair|
			 Out.ar(pair[0], pair[1])}};
			 var wrappedOut3 = { |busArray, signalArray|
			 	[busArray, signalArray].flop.do { |pair|
			 Out.ar(pair[0], pair[1])}};
			 var out1 = NamedControl.kr(\out1, [0, 1, 2, 3]);  // multiple buses!
	var out2 = NamedControl.kr(\out2, [0, 1, 2, 3, 4, 5]);  // multiple buses!
	var out3 = NamedControl.kr(\out3, [0, 1, 2, 3, 4, 5]);  // multiple buses!


	wrappedOut3.value(out1,LeakDC.ar(osc3,mul:env));

	wrappedOut2.value(out1,LeakDC.ar( osc2,mul:env));

		wrappedOut1.value(out1,LeakDC.ar(osc1,mul:env));


////written by jamshark in scsynth forum
		\out,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),