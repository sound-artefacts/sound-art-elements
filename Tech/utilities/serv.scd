

(
s.options.numWireBufs = 1024*32;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
TempoClock.default.tempo_(120/240);
s.options.memSize = 8192*64;
//s.options.blockSize = 64/4;
s.options.maxNodes = 1024 * 64;
//s.waitForBoot
)
Server.freeAll
(
~s1=Server.new(\server1,NetAddr("localhost", 57101),Server.local.options);
~s2=Server.new(\server2,NetAddr("localhost", 57102),Server.local.options);
~s3=Server.new(\server3,NetAddr("localhost", 57103),Server.local.options);
~s4=Server.new(\server4,NetAddr("localhost", 57104),Server.local.options);
~s5=Server.new(\server5,NetAddr("localhost", 57105),Server.local.options);
~s6=Server.new(\server6,NetAddr("localhost", 57106),Server.local.options);
~s7=Server.new(\server7,NetAddr("localhost", 57107),Server.local.options);
~s8=Server.new(\server8,NetAddr("localhost", 57108),Server.local.options);
)
(~s1.boot;~s2.boot;~s3.boot;~s4.boot;~s5.boot;~s6.boot;~s7.boot;~s8.boot;)
(
~s1.makeGui(w);
~s2.makeGui(w);
~s3.makeGui(w);
~s4.makeGui(w);
~s5.makeGui(w);
~s6.makeGui(w);
~s7.makeGui(w);
~s8.makeGui(w);
~s1.meter;
~s2.meter;
~s3.meter;
~s4.meter;
~s5.meter;
~s6.meter;
~s7.meter;
~s8.meter;
)


(
(
SynthDef.new(\oa, {
	arg  n1=1, cutt=440,decay=6,t=4,attack=0.05,x=1,y=0.5,z=0.25,rx=1, ry=1,rz=1;
	var q,i,j,k,v1,v2,v3,ph_v1_x,ph_v1_y,ph_v1_z,ph_v2_x,ph_v2_y,ph_v2_z,ph_v3_x,ph_v3_y,ph_v3_z;
	var osc1,osc2,osc3,freq, env,m=1,bank, pitch, fund, angle=0,r;
	var osc1_x,osc1_y,osc1_z,osc2_x,osc2_y,osc2_z,osc3_x,osc3_y,osc3_z;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut2 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut3 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};

	var out = NamedControl.kr(\out, [0, 1]);  // multiple buses!

	r=[rx.pow(2),ry.pow(2),rz.pow(2)].normalizeSum;

	i = Quaternion(0, r.[0], 0, 0);
	j = Quaternion(0, 0,r.[1], 0);
	k = Quaternion(0, 0, 0, r.[2]);

	v1=Quaternion(0,x,y,z);
	bank=32;
	pitch=2.pow(n1/(2*6));
	fund=(((4*t)-1)*((4*t)/2));
	freq = (fund*6)*pitch;

env=EnvGen.ar(Env.perc(attack,decay,pitch.reciprocal),doneAction:2,levelScale:2);
//env=EnvGen.ar(Env.sine(decay,pitch1.reciprocal),doneAction:2,levelScale:2);

	bank.do{
angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
	q=(cos(angle.degrad)+(sin(angle.degrad)*(i+j+k)));
	v1=q*v1;

	ph_v1_x=Complex(v1.a.round(0.0001),v1.b.round(0.0001)).phase;
	ph_v1_y=Complex(v1.a.round(0.0001),v1.c.round(0.0001)).phase;
	ph_v1_z=Complex(v1.a.round(0.0001),v1.d.round(0.0001)).phase;

osc1_x=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_x,2pi)), LFSaw.ar(1,ph_v1_x.linlin(2pi.neg,2pi,1.neg,1)));

osc1_y=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_y,2pi)), LFSaw.ar(1,ph_v1_y.linlin(2pi.neg,2pi,1.neg,1)));

osc1_z=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_z,2pi)), LFSaw.ar(1,ph_v1_z.linlin(2pi.neg,2pi,1.neg,1)));


m=m+1;

		wrappedOut1.value(out,LPF.ar(LeakDC.ar((osc1_x)*env),cutt));
	wrappedOut2.value(out, LPF.ar(LeakDC.ar((osc1_y)*env),cutt));
	wrappedOut3.value(out, LPF.ar(LeakDC.ar((osc1_z)*env),cutt));

	};
}).add;
);
(
SynthDef.new(\ob, {
	arg  n1=1, cutt=440,decay=6,t=4,attack=0.05,x=1,y=0.5,z=0.25,rx=1, ry=1,rz=1;
	var q,i,j,k,v1,v2,v3,ph_v1_x,ph_v1_y,ph_v1_z,ph_v2_x,ph_v2_y,ph_v2_z,ph_v3_x,ph_v3_y,ph_v3_z;
	var osc1,osc2,osc3,freq, env,m=1,bank, pitch, fund, angle=0,r;
	var osc1_x,osc1_y,osc1_z,osc2_x,osc2_y,osc2_z,osc3_x,osc3_y,osc3_z;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut2 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut3 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};

	var out = NamedControl.kr(\out, [0, 1]);  // multiple buses!

	r=[rx.pow(2),ry.pow(2),rz.pow(2)].normalizeSum;

	i = Quaternion(0, r.[0], 0, 0);
	j = Quaternion(0, 0,r.[1], 0);
	k = Quaternion(0, 0, 0, r.[2]);

	v1=Quaternion(0,x,y,z);
	bank=32;
	pitch=2.pow(n1/(2*6));
	fund=(((4*t)-1)*((4*t)/2));
	freq = (fund*6)*pitch;

env=EnvGen.ar(Env.perc(attack,decay,pitch.reciprocal),doneAction:2,levelScale:2);
//env=EnvGen.ar(Env.sine(decay,pitch1.reciprocal),doneAction:2,levelScale:2);

	bank.do{

	q=(cos(angle.degrad)+(sin(angle.degrad)*(i+j+k)));
	v1=q*v1;

	ph_v1_x=Complex(v1.a.round(0.0001),v1.b.round(0.0001)).phase;
	ph_v1_y=Complex(v1.a.round(0.0001),v1.c.round(0.0001)).phase;
	ph_v1_z=Complex(v1.a.round(0.0001),v1.d.round(0.0001)).phase;

osc1_x=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_x,2pi)), LFSaw.ar(1,ph_v1_x.linlin(2pi.neg,2pi,1.neg,1)));

osc1_y=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_y,2pi)), LFSaw.ar(1,ph_v1_y.linlin(2pi.neg,2pi,1.neg,1)));

osc1_z=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_z,2pi)), LFSaw.ar(1,ph_v1_z.linlin(2pi.neg,2pi,1.neg,1)));

m=m+1;
angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);

		wrappedOut1.value(out,LPF.ar(LeakDC.ar((osc1_x)*env),cutt));
	wrappedOut2.value(out, LPF.ar(LeakDC.ar((osc1_y)*env),cutt));
	wrappedOut3.value(out, LPF.ar(LeakDC.ar((osc1_z)*env),cutt));

	};
}).add;
);
(
SynthDef.new(\oc, {
	arg  n1=1, cutt=440,decay=6,t=4,attack=0.05,x=1,y=0.5,z=0.25,rx=1, ry=1,rz=1;
	var q,i,j,k,v1,v2,v3,ph_v1_x,ph_v1_y,ph_v1_z,ph_v2_x,ph_v2_y,ph_v2_z,ph_v3_x,ph_v3_y,ph_v3_z;
	var osc1,osc2,osc3,freq, env,m=1,bank, pitch, fund, angle=0,r;
	var osc1_x,osc1_y,osc1_z,osc2_x,osc2_y,osc2_z,osc3_x,osc3_y,osc3_z;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut2 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut3 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};

	var out = NamedControl.kr(\out, [0, 1]);  // multiple buses!

	r=[rx.pow(2),ry.pow(2),rz.pow(2)].normalizeSum;

	i = Quaternion(0, r.[0], 0, 0);
	j = Quaternion(0, 0,r.[1], 0);
	k = Quaternion(0, 0, 0, r.[2]);

	v1=Quaternion(0,x,y,z);
	bank=32;
	pitch=2.pow(n1/(2*6));
	fund=(((4*t)-1)*((4*t)/2));
	freq = (fund*6)*pitch;

env=EnvGen.ar(Env.perc(attack,decay,pitch.reciprocal),doneAction:2,levelScale:2);
//env=EnvGen.ar(Env.sine(decay,pitch1.reciprocal),doneAction:2,levelScale:2);

	bank.do{

	q=(cos(angle.degrad)+(sin(angle.degrad)*(i+j+k)));
	v1=q*v1;
	ph_v1_x=Complex(v1.a.round(0.0001),v1.b.round(0.0001)).phase;
	ph_v1_y=Complex(v1.a.round(0.0001),v1.c.round(0.0001)).phase;
	ph_v1_z=Complex(v1.a.round(0.0001),v1.d.round(0.0001)).phase;

osc1_x=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_x,2pi)), LFSaw.ar(1,ph_v1_x.linlin(2pi.neg,2pi,1.neg,1)));

osc1_y=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_y,2pi)), LFSaw.ar(1,ph_v1_y.linlin(2pi.neg,2pi,1.neg,1)));

osc1_z=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_z,2pi)), LFSaw.ar(1,ph_v1_z.linlin(2pi.neg,2pi,1.neg,1)));

m=m+1;
angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);

	wrappedOut1.value(out,LPF.ar(LeakDC.ar((osc1_x)*env),cutt));
	wrappedOut2.value(out, LPF.ar(LeakDC.ar((osc1_y)*env),cutt));
	wrappedOut3.value(out, LPF.ar(LeakDC.ar((osc1_z)*env),cutt));
	};

}).add;
);
(
SynthDef.new(\od, {
	arg  n1=1, cutt=440,decay=6,t=4,attack=0.05,x=1,y=0.5,z=0.25,rx=1, ry=1,rz=1;
	var q,i,j,k,v1,v2,v3,ph_v1_x,ph_v1_y,ph_v1_z,ph_v2_x,ph_v2_y,ph_v2_z,ph_v3_x,ph_v3_y,ph_v3_z;
	var osc1,osc2,osc3,freq, env,m=1,bank, pitch, fund, angle=0,r;
	var osc1_x,osc1_y,osc1_z,osc2_x,osc2_y,osc2_z,osc3_x,osc3_y,osc3_z;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut2 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut3 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};

	var out = NamedControl.kr(\out, [0, 1]);  // multiple buses!

	r=[rx.pow(2),ry.pow(2),rz.pow(2)].normalizeSum;

	i = Quaternion(0, r.[0], 0, 0);
	j = Quaternion(0, 0,r.[1], 0);
	k = Quaternion(0, 0, 0, r.[2]);

	v1=Quaternion(0,x,y,z);
	bank=32;
	pitch=2.pow(n1/(2*6));
	fund=(((4*t)-1)*((4*t)/2));
	freq = (fund*6)*pitch;

env=EnvGen.ar(Env.perc(attack,decay,pitch.reciprocal),doneAction:2,levelScale:2);
//env=EnvGen.ar(Env.sine(decay,pitch1.reciprocal),doneAction:2,levelScale:2);

	bank.do{

	q=(cos(angle.degrad)+(sin(angle.degrad)*(i+j+k)));
	v1=q*v1;

	ph_v1_x=Complex(v1.a.round(0.0001),v1.b.round(0.0001)).phase;
	ph_v1_y=Complex(v1.a.round(0.0001),v1.c.round(0.0001)).phase;
	ph_v1_z=Complex(v1.a.round(0.0001),v1.d.round(0.0001)).phase;

osc1_x=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_x,2pi)), LFSaw.ar(1,ph_v1_x.linlin(2pi.neg,2pi,1.neg,1)));

osc1_y=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_y,2pi)), LFSaw.ar(1,ph_v1_y.linlin(2pi.neg,2pi,1.neg,1)));

osc1_z=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_z,2pi)), LFSaw.ar(1,ph_v1_z.linlin(2pi.neg,2pi,1.neg,1)));

m=m+1;
angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);

	wrappedOut1.value(out,LPF.ar(LeakDC.ar((osc1_x)*env),cutt));
	wrappedOut2.value(out, LPF.ar(LeakDC.ar((osc1_y)*env),cutt));
	wrappedOut3.value(out, LPF.ar(LeakDC.ar((osc1_z)*env),cutt));


	};
}).add;
);
(
SynthDef.new(\oe, {
	arg  n1=1, cutt=440,decay=6,t=4,attack=0.05,x=1,y=0.5,z=0.25,rx=1, ry=1,rz=1;
	var q,i,j,k,v1,v2,v3,ph_v1_x,ph_v1_y,ph_v1_z,ph_v2_x,ph_v2_y,ph_v2_z,ph_v3_x,ph_v3_y,ph_v3_z;
	var osc1,osc2,osc3,freq, env,m=1,bank, pitch, fund, angle=0,r;
	var osc1_x,osc1_y,osc1_z,osc2_x,osc2_y,osc2_z,osc3_x,osc3_y,osc3_z;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut2 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut3 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};

	var out = NamedControl.kr(\out, [0, 1]);  // multiple buses!

	r=[rx.pow(2),ry.pow(2),rz.pow(2)].normalizeSum;

	i = Quaternion(0, r.[0], 0, 0);
	j = Quaternion(0, 0,r.[1], 0);
	k = Quaternion(0, 0, 0, r.[2]);

	v1=Quaternion(0,x,y,z);
	bank=32;
	pitch=2.pow(n1/(2*6));
	fund=(((4*t)-1)*((4*t)/2));
	freq = (fund*8)*pitch;

env=EnvGen.ar(Env.perc(attack,decay,pitch.reciprocal),doneAction:2,levelScale:3/2);
//env=EnvGen.ar(Env.sine(decay,pitch1.reciprocal),doneAction:2,levelScale:2);

	bank.do{
angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
	q=(cos(angle.degrad)+(sin(angle.degrad)*(i+j+k)));
	v1=q*v1;

	ph_v1_x=Complex(v1.a.round(0.0001),v1.b.round(0.0001)).phase;
	ph_v1_y=Complex(v1.a.round(0.0001),v1.c.round(0.0001)).phase;
	ph_v1_z=Complex(v1.a.round(0.0001),v1.d.round(0.0001)).phase;

osc1_x=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_x,2pi)), LFSaw.ar(1,ph_v1_x.linlin(2pi.neg,2pi,1.neg,1)));

osc1_y=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_y,2pi)), LFSaw.ar(1,ph_v1_y.linlin(2pi.neg,2pi,1.neg,1)));

osc1_z=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_z,2pi)), LFSaw.ar(1,ph_v1_z.linlin(2pi.neg,2pi,1.neg,1)));


m=m+1;

		wrappedOut1.value(out,LPF.ar(LeakDC.ar((osc1_x)*env),cutt));
	wrappedOut2.value(out, LPF.ar(LeakDC.ar((osc1_y)*env),cutt));
	wrappedOut3.value(out, LPF.ar(LeakDC.ar((osc1_z)*env),cutt));

	};
}).add;
);
(
SynthDef.new(\of, {
	arg  n1=1, cutt=440,decay=6,t=4,attack=0.05,x=1,y=0.5,z=0.25,rx=1, ry=1,rz=1;
	var q,i,j,k,v1,v2,v3,ph_v1_x,ph_v1_y,ph_v1_z,ph_v2_x,ph_v2_y,ph_v2_z,ph_v3_x,ph_v3_y,ph_v3_z;
	var osc1,osc2,osc3,freq, env,m=1,bank, pitch, fund, angle=0,r;
	var osc1_x,osc1_y,osc1_z,osc2_x,osc2_y,osc2_z,osc3_x,osc3_y,osc3_z;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut2 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut3 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};

	var out = NamedControl.kr(\out, [0, 1]);  // multiple buses!

	r=[rx.pow(2),ry.pow(2),rz.pow(2)].normalizeSum;

	i = Quaternion(0, r.[0], 0, 0);
	j = Quaternion(0, 0,r.[1], 0);
	k = Quaternion(0, 0, 0, r.[2]);

	v1=Quaternion(0,x,y,z);
	bank=32;
	pitch=2.pow(n1/(2*6));
	fund=(((4*t)-1)*((4*t)/2));
	freq = (fund*8)*pitch;

env=EnvGen.ar(Env.perc(attack,decay,pitch.reciprocal),doneAction:2,levelScale:3/2);
//env=EnvGen.ar(Env.sine(decay,pitch1.reciprocal),doneAction:2,levelScale:2);

	bank.do{

	q=(cos(angle.degrad)+(sin(angle.degrad)*(i+j+k)));
	v1=q*v1;

	ph_v1_x=Complex(v1.a.round(0.0001),v1.b.round(0.0001)).phase;
	ph_v1_y=Complex(v1.a.round(0.0001),v1.c.round(0.0001)).phase;
	ph_v1_z=Complex(v1.a.round(0.0001),v1.d.round(0.0001)).phase;

osc1_x=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_x,2pi)), LFSaw.ar(1,ph_v1_x.linlin(2pi.neg,2pi,1.neg,1)));

osc1_y=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_y,2pi)), LFSaw.ar(1,ph_v1_y.linlin(2pi.neg,2pi,1.neg,1)));

osc1_z=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_z,2pi)), LFSaw.ar(1,ph_v1_z.linlin(2pi.neg,2pi,1.neg,1)));

m=m+1;
angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);

		wrappedOut1.value(out,LPF.ar(LeakDC.ar((osc1_x)*env),cutt));
	wrappedOut2.value(out, LPF.ar(LeakDC.ar((osc1_y)*env),cutt));
	wrappedOut3.value(out, LPF.ar(LeakDC.ar((osc1_z)*env),cutt));

	};
}).add;
);
(
SynthDef.new(\og, {
	arg  n1=1, cutt=440,decay=6,t=4,attack=0.05,x=1,y=0.5,z=0.25,rx=1, ry=1,rz=1;
	var q,i,j,k,v1,v2,v3,ph_v1_x,ph_v1_y,ph_v1_z,ph_v2_x,ph_v2_y,ph_v2_z,ph_v3_x,ph_v3_y,ph_v3_z;
	var osc1,osc2,osc3,freq, env,m=1,bank, pitch, fund, angle=0,r;
	var osc1_x,osc1_y,osc1_z,osc2_x,osc2_y,osc2_z,osc3_x,osc3_y,osc3_z;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut2 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut3 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};

	var out = NamedControl.kr(\out, [0, 1]);  // multiple buses!

	r=[rx.pow(2),ry.pow(2),rz.pow(2)].normalizeSum;

	i = Quaternion(0, r.[0], 0, 0);
	j = Quaternion(0, 0,r.[1], 0);
	k = Quaternion(0, 0, 0, r.[2]);

	v1=Quaternion(0,x,y,z);
	bank=32;
	pitch=2.pow(n1/(2*6));
	fund=(((4*t)-1)*((4*t)/2));
	freq = (fund*8)*pitch;

env=EnvGen.ar(Env.perc(attack,decay,pitch.reciprocal),doneAction:2,levelScale:3/2);
//env=EnvGen.ar(Env.sine(decay,pitch1.reciprocal),doneAction:2,levelScale:2);

	bank.do{

	q=(cos(angle.degrad)+(sin(angle.degrad)*(i+j+k)));
	v1=q*v1;
	ph_v1_x=Complex(v1.a.round(0.0001),v1.b.round(0.0001)).phase;
	ph_v1_y=Complex(v1.a.round(0.0001),v1.c.round(0.0001)).phase;
	ph_v1_z=Complex(v1.a.round(0.0001),v1.d.round(0.0001)).phase;

osc1_x=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_x,2pi)), LFSaw.ar(1,ph_v1_x.linlin(2pi.neg,2pi,1.neg,1)));

osc1_y=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_y,2pi)), LFSaw.ar(1,ph_v1_y.linlin(2pi.neg,2pi,1.neg,1)));

osc1_z=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_z,2pi)), LFSaw.ar(1,ph_v1_z.linlin(2pi.neg,2pi,1.neg,1)));

m=m+1;
angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);

	wrappedOut1.value(out,LPF.ar(LeakDC.ar((osc1_x)*env),cutt));
	wrappedOut2.value(out, LPF.ar(LeakDC.ar((osc1_y)*env),cutt));
	wrappedOut3.value(out, LPF.ar(LeakDC.ar((osc1_z)*env),cutt));
	};

}).add;
);
(
SynthDef.new(\ok, {
	arg  n1=1, cutt=440,decay=6,t=4,attack=0.05,x=1,y=0.5,z=0.25,rx=1, ry=1,rz=1;
	var q,i,j,k,v1,v2,v3,ph_v1_x,ph_v1_y,ph_v1_z,ph_v2_x,ph_v2_y,ph_v2_z,ph_v3_x,ph_v3_y,ph_v3_z;
	var osc1,osc2,osc3,freq, env,m=1,bank, pitch, fund, angle=0,r;
	var osc1_x,osc1_y,osc1_z,osc2_x,osc2_y,osc2_z,osc3_x,osc3_y,osc3_z;
	var wrappedOut1 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut2 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};
	var wrappedOut3 = { |busArray, signalArray|
	[busArray, signalArray].flop.do { |pair|
		Out.ar(pair[0], pair[1])}};

	var out = NamedControl.kr(\out, [0, 1]);  // multiple buses!

	r=[rx.pow(2),ry.pow(2),rz.pow(2)].normalizeSum;

	i = Quaternion(0, r.[0], 0, 0);
	j = Quaternion(0, 0,r.[1], 0);
	k = Quaternion(0, 0, 0, r.[2]);

	v1=Quaternion(0,x,y,z);
	bank=32;
	pitch=2.pow(n1/(2*6));
	fund=(((4*t)-1)*((4*t)/2));
	freq = (fund*8)*pitch;

env=EnvGen.ar(Env.perc(attack,decay,pitch.reciprocal),doneAction:2,levelScale:3/2);
//env=EnvGen.ar(Env.sine(decay,pitch1.reciprocal),doneAction:2,levelScale:2);

	bank.do{

	q=(cos(angle.degrad)+(sin(angle.degrad)*(i+j+k)));
	v1=q*v1;

	ph_v1_x=Complex(v1.a.round(0.0001),v1.b.round(0.0001)).phase;
	ph_v1_y=Complex(v1.a.round(0.0001),v1.c.round(0.0001)).phase;
	ph_v1_z=Complex(v1.a.round(0.0001),v1.d.round(0.0001)).phase;

osc1_x=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_x,2pi)), LFSaw.ar(1,ph_v1_x.linlin(2pi.neg,2pi,1.neg,1)));

osc1_y=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_y,2pi)), LFSaw.ar(1,ph_v1_y.linlin(2pi.neg,2pi,1.neg,1)));

osc1_z=PanAz.ar(2,SinOsc.ar((freq*m),mul:m.reciprocal,phase:SinOsc.ar(0.1,ph_v1_z,2pi)), LFSaw.ar(1,ph_v1_z.linlin(2pi.neg,2pi,1.neg,1)));

m=m+1;
angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);

	wrappedOut1.value(out,LPF.ar(LeakDC.ar((osc1_x)*env),cutt));
	wrappedOut2.value(out, LPF.ar(LeakDC.ar((osc1_y)*env),cutt));
	wrappedOut3.value(out, LPF.ar(LeakDC.ar((osc1_z)*env),cutt));


	};
}).add;
);
)
(
SynthDescLib.global.addServer(~s1);
SynthDescLib.global.addServer(~s2);
SynthDescLib.global.addServer(~s3);
SynthDescLib.global.addServer(~s4);
SynthDescLib.global.addServer(~s5);
SynthDescLib.global.addServer(~s6);
SynthDescLib.global.addServer(~s7);
SynthDescLib.global.addServer(~s8);
)

(
var  angle1=0,angle2=0,angle3=0,angle4=0,q1,q2,q3,q4,v1,v2,v3,v4,ph1,ph2,ph3,ph4;
var i = Quaternion(0, (1/3).sqrt, 0, 0),j = Quaternion(0, 0, (1/3).sqrt, 0),k = Quaternion(0, 0, 0, (1/3).sqrt);

v1=Quaternion(0,1,2,3);
v2=Quaternion(0,1,2,3);
v3=Quaternion(0,1,2,3);
v4=Quaternion(0,1,2,3);


	~phase1 = 10000.collect{
		angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
		q1=(cos(angle1.degrad)+(sin(angle1.degrad)*(i+j+k)));
	v1=q1*v1;
	ph1=v1.a;
	//ph1=2.pow(ph1/(2*6));
	};
~phase2 = 10000.collect{
		angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
		q2=(cos(angle2.degrad)+(sin(angle2.degrad)*(i+j+k)));
	v2=q2*v2;
	ph2=v2.b;
	//ph2=2.pow(ph2/(2*6));
	};

~phase3 = 10000.collect{
		angle3=(angle3+(360-(360/1.6180339887499))).wrap(0,360);
		q3=(cos(angle3.degrad)+(sin(angle3.degrad)*(i+j+k)));
	v3=q3*v3;
	ph3=v3.c;
	//ph3=2.pow(ph3/(2*6));
	};

~phase4 = 10000.collect{
		angle4=(angle4+(360-(360/1.6180339887499))).wrap(0,360);
		q4=(cos(angle4.degrad)+(sin(angle4.degrad)*(i+j+k)));
	v4=q4*v4;
	ph4=v4.d;
	//ph4=2.pow(ph4/(2*6));
	};

)

(
var  angle1=0,angle2=0,angle3=0,angle4=0,q1,q2,q3,q4,v1,v2,v3,v4,ph1,ph2,ph3,ph4;
var i = Quaternion(0, (1/3).sqrt, 0, 0),j = Quaternion(0, 0, (1/3).sqrt, 0),k = Quaternion(0, 0, 0, (1/3).sqrt);

v1=Quaternion(0,4,5,6);
v2=Quaternion(0,4,5,6);
v3=Quaternion(0,4,5,6);
v4=Quaternion(0,4,5,6);


	~phase5 = 10000.collect{
		angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
		q1=(cos(angle1.degrad)+(sin(angle1.degrad)*(i+j+k)));
	v1=q1*v1;
	ph1=v1.a;
	//ph1=2.pow(ph1/(2*6));
	};
~phase6 = 10000.collect{
		angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
		q2=(cos(angle2.degrad)+(sin(angle2.degrad)*(i+j+k)));
	v2=q2*v2;
	ph2=v2.b;
	//ph2=2.pow(ph2/(2*6));
	};

~phase7 = 10000.collect{
		angle3=(angle3+(360-(360/1.6180339887499))).wrap(0,360);
		q3=(cos(angle3.degrad)+(sin(angle3.degrad)*(i+j+k)));
	v3=q3*v3;
	ph3=v3.c;
	//ph3=2.pow(ph3/(2*6));
	};

~phase8 = 10000.collect{
		angle4=(angle4+(360-(360/1.6180339887499))).wrap(0,360);
		q4=(cos(angle4.degrad)+(sin(angle4.degrad)*(i+j+k)));
	v4=q4*v4;
	ph4=v4.d;
	//ph4=2.pow(ph4/(2*6));
	};

)

(
var  angle1=0,angle2=0,angle3=0,angle4=0,q1,q2,q3,q4,v1,v2,v3,v4,ph1,ph2,ph3,ph4;
var i = Quaternion(0, (1/3).sqrt, 0, 0),j = Quaternion(0, 0, (1/3).sqrt, 0),k = Quaternion(0, 0, 0, (1/3).sqrt);

v1=Quaternion(0,5,7,12);
v2=Quaternion(0,5,7,12);
v3=Quaternion(0,5,7,12);
v4=Quaternion(0,5,7,12);


	~n1 = 10000.collect{
		angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
		q1=(cos(angle1.degrad)+(sin(angle1.degrad)*(i+j+k)));
	v1=q1*v1;
	ph1=v1.a.round(1);
	};
~n2 = 10000.collect{
		angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
		q2=(cos(angle2.degrad)+(sin(angle2.degrad)*(i+j+k)));
	v2=q2*v2;
	ph2=v2.b.round(1);
	};

~n3 = 10000.collect{
		angle3=(angle3+(360-(360/1.6180339887499))).wrap(0,360);
		q3=(cos(angle3.degrad)+(sin(angle3.degrad)*(i+j+k)));
	v3=q3*v3;
	ph3=v3.c.round(1);
	};

~n4 = 10000.collect{
		angle4=(angle4+(360-(360/1.6180339887499))).wrap(0,360);
		q4=(cos(angle4.degrad)+(sin(angle4.degrad)*(i+j+k)));
	v4=q4*v4;
	ph4=v4.d.round(1);
	};

)
(
var  angle1=0,angle2=0,angle3=0,angle4=0,q1,q2,q3,q4,v1,v2,v3,v4,ph1,ph2,ph3,ph4;
var i = Quaternion(0, (1/3).sqrt, 0, 0),j = Quaternion(0, 0, (1/3).sqrt, 0),k = Quaternion(0, 0, 0, (1/3).sqrt);

v1=Quaternion(0,12,7,5);
v2=Quaternion(0,12,7,5);
v3=Quaternion(0,12,7,5);
v4=Quaternion(0,12,7,5);


	~n5 = 10000.collect{
		angle1=(angle1+(360-(360/1.6180339887499))).wrap(0,360);
		q1=(cos(angle1.degrad)+(sin(angle1.degrad)*(i+j+k)));
	v1=q1*v1;
	ph1=v1.a.round(1);
	};
~n6 = 10000.collect{
		angle2=(angle2+(360-(360/1.6180339887499))).wrap(0,360);
		q2=(cos(angle2.degrad)+(sin(angle2.degrad)*(i+j+k)));
	v2=q2*v2;
	ph2=v2.b.round(1);
	};

~n7 = 10000.collect{
		angle3=(angle3+(360-(360/1.6180339887499))).wrap(0,360);
		q3=(cos(angle3.degrad)+(sin(angle3.degrad)*(i+j+k)));
	v3=q3*v3;
	ph3=v3.c.round(1);
	};

~n8 = 10000.collect{
		angle4=(angle4+(360-(360/1.6180339887499))).wrap(0,360);
		q4=(cos(angle4.degrad)+(sin(angle4.degrad)*(i+j+k)));
	v4=q4*v4;
	ph4=v4.d.round(1);
	};

)

(
~n1=~n1*(2);
~n2=~n2*(2);
~n3=~n3*(2);
~n4=~n4*(2);
)
(
~n5=~n5*(2);
~n6=~n6*(2);
~n7=~n7*(2);
~n8=~n8*(2);
)

(
a=Pdef(\1, Pbind(\instrument, \oa,
	\server,~s1,
	//\dur,1/2,
	\dur,Pseq(~phase1.abs,inf),
\n1,Pseq(~n1,inf),
	\cutt,Pbrown(220*2,220*8,100,inf),
		\out,Pn(Pshuf([0, 1], 1), inf).clump(2).collect([_]),
	//\out,Pn(Pshuf([0, 1], 1), inf).clump(4).collect([_]),
	\x,Pbrown(1.neg,1,0.1,inf),
	\y,Pbrown(1.neg,1,0.1,inf),
	\z,Pbrown(1.neg,1,0.1,inf),
	\rx,Pbrown(1.neg,1,0.1,inf),
	\ry,Pbrown(1.neg,1,0.1,inf),
	\rz,Pbrown(1.neg,1,0.1,inf),
	\decay,Pbrown(2,8,1,inf);
));
b=Pdef(\2, Pbind(\instrument, \ob,
	\server,~s2,
	//\dur,1/2,
	\dur,Pseq(~phase2.abs,inf),
\n1,Pseq(~n2,inf),
	\cutt,Pbrown(220*2,220*8,100,inf),
		\out,Pn(Pshuf([0, 1], 1), inf).clump(2).collect([_]),
	//\out,Pn(Pshuf([0, 1], 1), inf).clump(4).collect([_]),

\x,Pbrown(1.neg,1,0.1,inf),
	\y,Pbrown(1.neg,1,0.1,inf),
	\z,Pbrown(1.neg,1,0.1,inf),
	\rx,Pbrown(1.neg,1,0.1,inf),
	\ry,Pbrown(1.neg,1,0.1,inf),
	\rz,Pbrown(1.neg,1,0.1,inf),
	\decay,Pbrown(2,8,1,inf);
));
c=Pdef(\3, Pbind(\instrument, \oc,
	\server,~s3,
	//\dur,1/2,
	\dur,Pseq(~phase3.abs,inf),
\n1,Pseq(~n3,inf),
	\cutt,Pbrown(220*2,220*8,100,inf),
		\out,Pn(Pshuf([0, 1], 1), inf).clump(2).collect([_]),
	//\out,Pn(Pshuf([0, 1], 1), inf).clump(4).collect([_]),
\x,Pbrown(1.neg,1,0.1,inf),
	\y,Pbrown(1.neg,1,0.1,inf),
	\z,Pbrown(1.neg,1,0.1,inf),
	\rx,Pbrown(1.neg,1,0.1,inf),
	\ry,Pbrown(1.neg,1,0.1,inf),
	\rz,Pbrown(1.neg,1,0.1,inf),
	\decay,Pbrown(2,8,1,inf);
));
d=Pdef(\4, Pbind(\instrument, \od,
	\server,~s4,
	//\dur,1/2,
	\dur,Pseq(~phase4.abs,inf),
\n1,Pseq(~n4,inf),
	\cutt,Pbrown(220*2,220*8,100,inf),
	\out,Pn(Pshuf([0, 1], 1), inf).clump(2).collect([_]),
	//\out,Pn(Pshuf([0, 1], 1), inf).clump(4).collect([_]),

	\x,Pbrown(1.neg,1,0.1,inf),
	\y,Pbrown(1.neg,1,0.1,inf),
	\z,Pbrown(1.neg,1,0.1,inf),
	\rx,Pbrown(1.neg,1,0.1,inf),
	\ry,Pbrown(1.neg,1,0.1,inf),
	\rz,Pbrown(1.neg,1,0.1,inf),
	\decay,Pbrown(2,8,1,inf);
));
e=Pdef(\5, Pbind(\instrument, \oe,
	\server,~s5,
	//\dur,1/2,
	\dur,Pseq(~phase5.abs,inf),
\n1,Pseq(~n5,inf),
	\cutt,Pbrown(220*2,220*8,100,inf),
		\out,Pn(Pshuf([0, 1], 1), inf).clump(2).collect([_]),
	//\out,Pn(Pshuf([0, 1], 1), inf).clump(4).collect([_]),
	\x,Pbrown(1.neg,1,0.1,inf),
	\y,Pbrown(1.neg,1,0.1,inf),
	\z,Pbrown(1.neg,1,0.1,inf),
	\rx,Pbrown(1.neg,1,0.1,inf),
	\ry,Pbrown(1.neg,1,0.1,inf),
	\rz,Pbrown(1.neg,1,0.1,inf),
	\decay,Pbrown(2,8,1,inf);
));
f=Pdef(\6, Pbind(\instrument, \of,
	\server,~s6,
	//\dur,1/2,
	\dur,Pseq(~phase6.abs,inf),
\n1,Pseq(~n6,inf),
	\cutt,Pbrown(220*2,220*8,100,inf),
		\out,Pn(Pshuf([0, 1], 1), inf).clump(2).collect([_]),
	//\out,Pn(Pshuf([0, 1], 1), inf).clump(4).collect([_]),

\x,Pbrown(1.neg,1,0.1,inf),
	\y,Pbrown(1.neg,1,0.1,inf),
	\z,Pbrown(1.neg,1,0.1,inf),
	\rx,Pbrown(1.neg,1,0.1,inf),
	\ry,Pbrown(1.neg,1,0.1,inf),
	\rz,Pbrown(1.neg,1,0.1,inf),
	\decay,Pbrown(2,8,1,inf);
));
g=Pdef(\7, Pbind(\instrument, \og,
	\server,~s7,
	//\dur,1/2,
	\dur,Pseq(~phase7.abs,inf),
\n1,Pseq(~n7,inf),
	\cutt,Pbrown(220*2,220*8,100,inf),
		\out,Pn(Pshuf([0, 1], 1), inf).clump(2).collect([_]),
	//\out,Pn(Pshuf([0, 1], 1), inf).clump(4).collect([_]),
\x,Pbrown(1.neg,1,0.1,inf),
	\y,Pbrown(1.neg,1,0.1,inf),
	\z,Pbrown(1.neg,1,0.1,inf),
	\rx,Pbrown(1.neg,1,0.1,inf),
	\ry,Pbrown(1.neg,1,0.1,inf),
	\rz,Pbrown(1.neg,1,0.1,inf),
	\decay,Pbrown(2,8,1,inf);
));
k=Pdef(\8, Pbind(\instrument, \ok,
	\server,~s8,
	//\dur,1/2,
	\dur,Pseq(~phase8.abs,inf),
\n1,Pseq(~n8,inf),
	\cutt,Pbrown(220*2,220*8,100,inf),
	\out,Pn(Pshuf([0, 1], 1), inf).clump(2).collect([_]),
	//\out,Pn(Pshuf([0, 1], 1), inf).clump(4).collect([_]),

	\x,Pbrown(1.neg,1,0.1,inf),
	\y,Pbrown(1.neg,1,0.1,inf),
	\z,Pbrown(1.neg,1,0.1,inf),
	\rx,Pbrown(1.neg,1,0.1,inf),
	\ry,Pbrown(1.neg,1,0.1,inf),
	\rz,Pbrown(1.neg,1,0.1,inf),
	\decay,Pbrown(2,8,1,inf);
));
)


(
a.play;
b.play;
c.play;
d.play;
e.play;
f.play;
g.play;
k.play;
)
(
~s1.sendMsg("/s_new", "oa", x = s.nextNodeID, 1, 1);
~s2.sendMsg("/s_new", "ob", y = s.nextNodeID, 1, 1);
~s3.sendMsg("/s_new", "oc", z = s.nextNodeID, 1, 1);
~s4.sendMsg("/s_new", "od", a = s.nextNodeID, 1, 1);
)


~s1.scope

(
~s1.record(numChannels:2);
~s2.record(numChannels:2);
~s3.record(numChannels:2);
~s4.record(numChannels:2);
~s5.record(numChannels:2);
~s6.record(numChannels:2);
~s7.record(numChannels:2);
~s8.record(numChannels:2);
)
~s4.stopRecording

(
~s1.stopRecording;
~s2.stopRecording;
~s3.stopRecording;
~s4.stopRecording;
~s5.stopRecording;
~s6.stopRecording;
~s7.stopRecording;
~s8.stopRecording;
)

{Out.ar(0, SoundIn.ar([0,1]))}.play