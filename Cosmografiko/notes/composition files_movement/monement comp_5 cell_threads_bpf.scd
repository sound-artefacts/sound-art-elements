(
Server.default = s = Server.local;
////server setup
(
s.options.numWireBufs = 1024*4;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=0;
TempoClock.default.tempo_(1);
s.options.memSize = 8192*128*2;
s.options.blockSize = 64*4;
s.options.maxNodes = 1024 * 16;
s.options.sampleRate= 44100;
);

s.waitForBoot{
Buffer.freeAll;
		~c1 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/PROJECT  FILES/recordings/bpf samples/bpf/0_tapsi diskos.wav",channels:0 );
	~c2 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/PROJECT  FILES/recordings/bpf samples/bpf/0_tapsi diskos.wav",channels:0 );
	~c3 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/PROJECT  FILES/recordings/bpf samples/bpf/0_tapsi diskos.wav",channels:0 );
	~c4 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/PROJECT  FILES/recordings/bpf samples/bpf/0_tapsi diskos.wav",channels:0 );
	~c5 = Buffer.readChannel(s,"/Users/petrostatsiopoulos/Desktop/PROJECT  FILES/recordings/bpf samples/bpf/0_tapsi diskos.wav",channels:0 );
////////////////////////////////////speaker setup///other

	~a = VBAPSpeakerArray.new(3, [[0, 45], [180, 45], [90, 45.neg], [90.neg, 45.neg]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);


///////////////////////////////////////////////////////arrays
///////l-system
	(
{
var dict = IdentityDictionary[\A -> "AB", \B -> "A"];
//These are the production rules of the L-system
var word = "A";
var string_temp = "";
var iter = 18;

//These are diction for the mapping of the alphabet to "artistic" parameters: degrees in a scale, beat occurrence, etc.

var dictnotes = IdentityDictionary[\A -> 0, \B -> 1];
 ~r=[];

//This iteration generates the system recursively

iter.do({

word.asArray.do({|i|
    string_temp = string_temp ++ dict[i.asSymbol];
});

word = string_temp;
	string_temp = "";
});

word.postln;

//Here we map the final system to the parameters as above

word.do({|i| ~r = ~r ++ dictnotes[i.asSymbol];});

~r.postln;
}.value
);


//////////////////////////////////////////////////basis
	////no0
	///Cartesian(ellipsis.normalizeSum.sqrt.[0],ellipsis.normalizeSum.sqrt.[1],ellipsis.normalizeSum.sqrt.[2])
	(
{
var  sph1,sph2,sph3,sph4,sph5,m_x=2,m_y=2,m_z=2;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z;
var az4=0,el4=0,az5=0,el5=0,pl1=0,pl2=0,pl3=0,pl4=0,pl5=0;
var angle=0,ang=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez;
var durx,dury,durz;
var sphx,sphy,sphz,azx,elx,azy,ely,azz,elz,plx=1,ply=1,plz=1;
var num=1.neg;
var ellipsis=[1,1,1],spread=1;
			~az=[];~el=[];

		45.do{
durx=(12).collect{
			azx = (angle+(360*2.pow(plx/12))).wrap(180.neg,180);  // Increment azimuth
				elx = (angle+(180*2.pow(plx/12))).wrap(90.neg,90);
		plx=(plx+1).mod(12);

		sphx=(Spherical(7,(azx.degrad),(elx.degrad))).x.round(1/32);

	};

dury=(12).collect{
		azy = (angle+(360*2.pow(ply/12))).wrap(180.neg,180);  // Increment azimuth
			ely = (angle+(180*2.pow(ply/12))).wrap(90.neg,90);
		ply=(ply+1).mod(12);

		sphy=(Spherical(7,(azy.degrad),(ely.degrad))).y.round(1/32);

	};
durz=(12).collect{
			azz = (angle+(360*2.pow(plz/12))).wrap(180.neg,180);  // Increment azimuth
				elz = (angle+(180*2.pow(plz/12))).wrap(90.neg,90);
		plz=(plz+1).mod(12);

		sphz=(Spherical(7,(azz.degrad),(elz.degrad))).z.round(1/32);

	};

azimuth=(12).collect{

			az1 = (angle+(360*2.pow(pl1/12))).wrap(180.neg,180);  // Increment azimuth
				el1 = (angle+(180*2.pow(pl1/12))).wrap(90.neg,90);
		pl1=(pl1+1).mod(12);

		sph1=(Spherical(1,(az1.degrad),(el1.degrad))).theta.round(0.00001);

	};

elevation=(12).collect{

				az2 = (angle+(360*2.pow(pl2/12))).wrap(180.neg,180);  // Increment azimuth
			el2 = (angle+(180*2.pow(pl2/12))).wrap(90.neg,90);
		pl2=(pl2+1).mod(12);

		sph2=(Spherical(1,(az2.degrad),(el2.degrad))).phi.round(0.00001);

	};

angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);~az=~az++azimuth;~el=~el++elevation;

			}
}.value;
);
	///////////wavetable
~t= Buffer.alloc(s,2048);
		{
var signal,wt,m=0,amp;

~level=15.collect{m=m+1;amp=m.reciprocal};
~phase=15.collect{pi};
signal=Signal.sineFill(1024,~level,~phase);

wt = signal.asWavetable;
~t.loadCollection(wt);
signal.plot;
		}.value;
	////////////list
	({
		var n=1.neg;
		~list1=(45*12-1).collect{
		n=n+1;
		}
		}.value
	);

		({
		var n=1.neg;
		~list2=(45*12*10).collect{
		n=n+1;
		}
		}.value
	);

	({
		var n=0; ~list=[];
		(45*12*10+1).do{ n=n+(10.reciprocal);
			~list=~list++~list1.[n];
	}}.value);
~list=~list.scramble;

				//////localization areas on the sphere array
	(	{~points = ~az.collect({ |az, i|Spherical(1, az, ~el[i]);})}.value;);

	(	{var n=1.neg,neighbors;
		~neighbors=[];
		(45*12).do{n=n+1;
		~center = Spherical(1, ~az.[n], ~el.[n] );
~threshold = 	0.5;
	neighbors = ~points.select { |pt|
		Quaternion(0,pt.x,pt.y,pt.z).distance(Quaternion(0,~center.x,~center.y,~center.z)) < ~threshold};
			~neighbors=~neighbors.add(neighbors);
}}.value;);

	~thetaArray = ~neighbors.collect(_.theta);
     ~phiArray = ~neighbors.collect(_.phi);

/////synths////


		(
SynthDef.new(\ospace, {
	arg amp=1,pl1=0,lfo,spread=1,ripple=0.01,amount=1,decay=8,varamp=5,coo,cell=1,pl2=0,rot_angle=0,a=0,b=0,mm=1,lfo2,mh=0,buf=0;
	var amp1,amp2,amp3,octave1=1,octave2=2,octave3=4,multiplier=64,center=1800/2;////343speed of sound/1800hz= 0.1905 aproximate head diameter
	var osc4,osc5,osc6,osc7,osc8,osc9,amp4,amp5,amp6,amp7,amp8,amp9,lamdoma,point;
	var pitch4,pitch5,pitch6,pitch7,pitch8,pitch9,dist,harm;
	var ton1,ton2,ton3,fundamental,sph,sph8,rq=0.000001,phase0;
	var freq1,freq2,freq3,pitch1,pitch2,pitch3,env,sig,n1,n2,n3;
	var magx,magy,magz,mag_x,mag_y,mag_z,magqx,magqy,mag_qx,mag_qy;
	var ratio1,ratio2,ratio3,m=3,mq=2,phase,osc1,osc2,osc3,sphere;
	var scale,nn=29.neg,nnn=8.neg,scale_coo;
	var ampx,ampy,ampz,mod_angle,mod_angle1,mod_angle2;
	var ellipsis=[1,1,1],mag,magxx,q1,q2,plsph;
	var waveSpeed = 1, waveFreq = 4, theta,phi,wave,t,scalar;
	var axis,i,j,k,coordinatesx,coordinatesy,coordinatesz,v,v1,qsphe;
	var ii,iii,jj,jjj,kk,kkk,axis1,axis2,axis3,v2,v3,mod_anglez;
  var wrappedOut1 = { |busArray, signalArray|[busArray, signalArray].flop.do { |pair| Out.ar(pair[0], pair[1])}};
	var wrappedOut2 = { |busArray, signalArray|[busArray, signalArray].flop.do { |pair|Out.ar(pair[0], pair[1])}};
	var wrappedOut3 = { |busArray, signalArray|[busArray, signalArray].flop.do { |pair|Out.ar(pair[0], pair[1])}};
	 var out1 = NamedControl.kr(\out1, [0, 1, 2, 3]);  // multiple buses!
	var out2 = NamedControl.kr(\out2, [0, 1, 2, 3]);
	var out3 = NamedControl.kr(\out3, [0, 1, 2, 3]);



			plsph=Spherical(10,Select.kr(pl1,~az),Select.kr(pl1,~el));
				phase0=Complex(plsph.theta.linlin(pi.neg,pi,1.neg,1),plsph.phi.linlin((pi/2).neg,(pi/2),1.neg,1)).theta;
	mod_angle2=SinOsc.ar(lfo2,phase0).range(90.neg.degrad,90.degrad);///harm oscillator phase can vary across tones
			//mod_angle2=LFNoise1.ar(lfo2).range(90.neg.degrad,90.degrad);///harm oscillator phase can vary across tones

harm=((Complex(cos(((plsph.phi+mod_angle2).round(0.00001)*mh).wrap((pi/2).neg,(pi/2))),cos(((plsph.phi).round(0.00001)*mh).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

			point=LFNoise0.kr(harm).range(22.neg,22).round(1).abs;

	t=SinOsc.kr(ripple).range(1, 100);
			waveFreq=amount;
			sph=Spherical(1,Select.kr(point,Select.kr(pl1,~thetaArray)),Select.kr(point,Select.kr(pl1,~phiArray)));

	//phase=Complex(sph.theta.linlin(pi.neg,pi,1.neg,1),sph.phi.linlin((pi/2).neg,(pi/2),1.neg,1)).theta;

	mod_angle=SinOsc.ar(lfo,0.degrad).range(90.neg.degrad,90.degrad);
	mod_angle1=SinOsc.ar(lfo,90.degrad).range(90.neg.degrad,90.degrad);
	mod_anglez=SinOsc.ar(lfo,45.degrad).range(90.neg.degrad,90.degrad);


	sph8=Spherical(1,Select.kr(point,Select.kr(pl1+1,~thetaArray)),Select.kr(point,Select.kr(pl1+1,~phiArray)));
q1=Quaternion(0,sph.x,sph.y,sph.z); q2=Quaternion(0,sph8.x,sph8.y,sph8.z);
dist=q1.distance(q2);

			env=EnvGen.ar(Env.sine(decay*dist.lag(0.1),amp),doneAction:2,levelScale:1);

//scale=57.collect{nn=nn+1;Scale.major.performDegreeToKey(nn,12)};
scale_coo=15.collect{nnn=nnn+1;Scale.major.performDegreeToKey(nnn,12)};
//scalar=2.pow(Select.kr(coo.round(1).linlin(7.neg, 7, 0, 14), scale_coo) / 12);
		scalar=1;	lamdoma=mm;

fundamental=(center)*scalar*lamdoma;
freq1=(fundamental*octave1);freq2=(fundamental*octave2);freq3=(fundamental*octave3);

					(
		magx=((Complex(cos(((sph.theta+mod_angle).round(0.00001)*m).wrap(pi.neg,pi)),cos((((sph.theta+mod_angle).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
	(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread);
				);

magy=((Complex(sin(((sph.theta+mod_angle1).round(0.00001)*m).wrap(pi.neg,pi)),sin(((sph.theta+mod_angle1).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt)).pow(spread)*
		(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread);
				);

magz=((Complex(cos(((sph.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),cos(((sph.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)).pow(spread));

magqx=((((Complex(cos(((sph.theta.round(0.00001)+mod_angle)*mq).wrap(pi.neg,pi)),
cos(((sph.theta.round(0.00001)+mod_angle)*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);

 magqy=((((Complex(sin(((sph.theta.round(0.00001)+mod_angle1)*mq).wrap(pi.neg,pi)),
sin(((sph.theta.round(0.00001)+mod_angle1)*mq).wrap(pi.neg,pi))))*
(Complex(sin((sph.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2))),
sin((sph.phi.round(0.00001)*(mq-1)).wrap((pi/2).neg,(pi/2)))))*
(Complex(cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),
cos((sph.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))))))).rho/(2.sqrt)).pow(spread);

	theta = Select.kr(point,Select.kr(pl1,~thetaArray)).degrad;
     phi = Select.kr(point,Select.kr(pl1,~phiArray)).degrad;
	 wave = varamp*sin(waveFreq * theta + waveFreq * phi - waveSpeed * t);
  magxx=  magx * wave;

				mag_x=magxx.value;mag_y=magy.value;mag_z=magz.value;mag_qx=magqx.value;mag_qy=magqy.value
				);

sphere=Spherical(24,Select.kr(point,Select.kr(pl1,~thetaArray)),Select.kr(point,Select.kr(pl1,~phiArray)));

n1=(sphere.x).round(0.00000001);
n2=(sphere.y).round(0.00000001);
n3=(sphere.z).round(0.00000001);
ratio1=n1.round(1);ratio2=n2.round(1);ratio3=n3.round(1);
ton1 = 2.pow(Select.kr(ratio1.linlin(28.neg, 28, 0, 56), scale) / 12);
ton2 = 2.pow(Select.kr(ratio2.linlin(28.neg, 28, 0, 56), scale) / 12);
ton3 = 2.pow(Select.kr(ratio3.linlin(28.neg, 28, 0, 56), scale) / 12);
//ton1 = 2.pow(n1 / 12);
//ton2 = 2.pow(n2 / 12);
//ton3 = 2.pow(n3 / 12);
	amp1=(ton1.reciprocal*octave1.reciprocal*scalar.reciprocal*lamdoma.reciprocal).round(0.00000001);
	amp2=(ton2.reciprocal*octave1.reciprocal*scalar.reciprocal*lamdoma.reciprocal).round(0.00000001);
	amp3=(ton3.reciprocal*octave1.reciprocal*scalar.reciprocal*lamdoma.reciprocal).round(0.00000001);
	amp4=(ton1.reciprocal*octave2.reciprocal*scalar.reciprocal*lamdoma.reciprocal).round(0.00000001);
	amp5=(ton2.reciprocal*octave2.reciprocal*scalar.reciprocal*lamdoma.reciprocal).round(0.00000001);
	amp6=(ton3.reciprocal*octave2.reciprocal*scalar.reciprocal*lamdoma.reciprocal).round(0.00000001);
	amp7=(ton1.reciprocal*octave3.reciprocal*scalar.reciprocal*lamdoma.reciprocal).round(0.00000001);
	amp8=(ton2.reciprocal*octave3.reciprocal*scalar.reciprocal*lamdoma.reciprocal).round(0.00000001);
	amp9=(ton3.reciprocal*octave3.reciprocal*scalar.reciprocal*lamdoma.reciprocal).round(0.00000001);

	pitch1=(freq1*ton1).round(0.0000001);pitch2=(freq1*ton2).round(0.0000001);pitch3=(freq1*ton3).round(0.0000001);
	pitch4=(freq2*ton1).round(0.0000001);pitch5=(freq2*ton2).round(0.0000001);pitch6=(freq2*ton3).round(0.0000001);
	pitch7=(freq3*ton1).round(0.0000001);pitch8=(freq3*ton2).round(0.0000001);pitch9=(freq3*ton3).round(0.0000001);


mag=(Cartesian(mag_x,mag_y,mag_z).rho)+(Cartesian(mag_qx,mag_qy,mag_z).rho);


	v=Quaternion(0,sph.x,sph.y,sph.z);/// vector as quaternion

	coordinatesx=[1,0,0].normalizeSum.sqrt;
	coordinatesy=[0,1,0].normalizeSum.sqrt;
	coordinatesz=[0,0,1].normalizeSum.sqrt;

	i=Quaternion(0, coordinatesx.[0], 0, 0);j=Quaternion(0, 0, coordinatesx.[1], 0);k=Quaternion(0, 0, 0, coordinatesx.[2]);
	ii=Quaternion(0, coordinatesy.[0], 0, 0);jj=Quaternion(0, 0, coordinatesy.[1], 0);kk=Quaternion(0, 0, 0, coordinatesy.[2]);
	iii=Quaternion(0, coordinatesz.[0], 0, 0);jjj=Quaternion(0, 0, coordinatesz.[1], 0);kkk=Quaternion(0, 0, 0, coordinatesz.[2]);

axis1=(((i+j+k)*exp(Complex(0,1)*rot_angle).imag)+exp(Complex(0,1)*rot_angle).real); ////rotation vector with angle of rotatio and ijk xyz normalized components
v1=axis1*v*axis1.conjugate;

axis2=(((ii+jj+kk)*exp(Complex(0,1)*rot_angle).imag)+exp(Complex(0,1)*rot_angle).real);
v2=axis2*v1*axis2.conjugate;

axis3=(((iii+jjj+kkk)*exp(Complex(0,1)*rot_angle).imag)+exp(Complex(0,1)*rot_angle).real);
v3=axis3*v2*axis3.conjugate;

qsphe=Cartesian(v3.b,v3.c,v3.d).asSpherical;

sig=PlayBuf.ar(1, buf, BufRateScale.kr(buf), loop: 1,doneAction:2)*0.1;

osc1=VBAP.ar(4,BPF.ar(sig,pitch1,mul:amp1*mag,rq:rq),~b.bufnum,qsphe.theta.raddeg,
				Osc.ar(~t.bufnum,cell,qsphe.phi).range(90.neg,90));
osc2=VBAP.ar(4,BPF.ar(sig,pitch2,mul:amp2*mag,rq:rq),~b.bufnum,qsphe.theta.raddeg,
				Osc.ar(~t.bufnum,cell,qsphe.phi).range(90.neg,90));
osc3=VBAP.ar(4,BPF.ar(sig,pitch3,mul:amp3*mag,rq:rq),~b.bufnum,qsphe.theta.raddeg,
				Osc.ar(~t.bufnum,cell,qsphe.phi).range(90.neg,90));
osc4=VBAP.ar(4,BPF.ar(sig,pitch4,mul:amp4*mag,rq:rq),~b.bufnum,qsphe.theta.raddeg,
				Osc.ar(~t.bufnum,cell,qsphe.phi).range(90.neg,90));
osc5=VBAP.ar(4,BPF.ar(sig,pitch5,mul:amp5*mag,rq:rq),~b.bufnum,qsphe.theta.raddeg,
				Osc.ar(~t.bufnum,cell,qsphe.phi).range(90.neg,90));
osc6=VBAP.ar(4,BPF.ar(sig,pitch6,mul:amp6*mag,rq:rq,),~b.bufnum,qsphe.theta.raddeg,
				Osc.ar(~t.bufnum,cell,qsphe.phi).range(90.neg,90));
osc7=VBAP.ar(4,BPF.ar(sig,pitch7,mul:amp7*mag,rq:rq),~b.bufnum,qsphe.theta.raddeg,
				Osc.ar(~t.bufnum,cell,qsphe.phi).range(90.neg,90));
osc8=VBAP.ar(4,BPF.ar(sig,pitch8,mul:amp8*mag,rq:rq),~b.bufnum,qsphe.theta.raddeg,
				Osc.ar(~t.bufnum,cell,qsphe.phi).range(90.neg,90));
osc9=VBAP.ar(4,BPF.ar(sig,pitch9,mul:amp9*mag,rq:rq),~b.bufnum,qsphe.theta.raddeg,
				Osc.ar(~t.bufnum,cell,qsphe.phi).range(90.neg,90));

wrappedOut1.value(out1,LeakDC.ar(osc3,mul:env*(rq.sqrt.reciprocal))*In.kr(0));
wrappedOut1.value(out1,LeakDC.ar(osc2,mul:env*(rq.sqrt.reciprocal))*In.kr(0));
wrappedOut1.value(out1,LeakDC.ar(osc1,mul:env*(rq.sqrt.reciprocal))*In.kr(0));
wrappedOut2.value(out2,LeakDC.ar(osc9,mul:env*(rq.sqrt.reciprocal))*In.kr(0));
wrappedOut2.value(out2,LeakDC.ar(osc8,mul:env*(rq.sqrt.reciprocal))*In.kr(0));
wrappedOut2.value(out2,LeakDC.ar(osc7,mul:env*(rq.sqrt.reciprocal))*In.kr(0));
wrappedOut3.value(out3,LeakDC.ar(osc6,mul:env*(rq.sqrt.reciprocal))*In.kr(0));
wrappedOut3.value(out3,LeakDC.ar(osc5,mul:env*(rq.sqrt.reciprocal))*In.kr(0));
wrappedOut3.value(out3,LeakDC.ar(osc4,mul:env*(rq.sqrt.reciprocal))*In.kr(0));

}).add;
);
/////angle
		({
		var angle=0;
		~angle=(360*12).collect{
		angle=(angle+(360-(360/1.6180339887499))).wrap(0,360);
		}
		}.value;
	);

//////////pattern

(
		~aa=Pdef(\1, Pbind(\instrument, \ospace,
			//\dur,Pseq(~dur.abs,inf),
			\dur,4,
		\buf,Prand([0,1,2,3,4],inf),
		\coo,Pseq(~dur,inf),
		//\mm,Prand([1,2,3,4,5,6,7,8,9,10],inf),
		\mm,Prand([1,1/2,2/3,3/4],inf),
		\mh,Prand([3],inf),
			\pl1,Pseq(~list1.scramble,inf),    ///////coordinate selection
		//	\pl2,Pseq(~list2,inf),
		\lfo,Pbrown(0.01,0.1,0.1,inf), /////mag spherical harmonic oscillation
		\lfo2,Pbrown(0.1,1,0.01,inf), /////tone spherical harmonic oscillation
		\cell,Pbrown(0.01,0.1,0.1,inf), ///////speed of 4dimensional oscillation
		\rot_angle,Pseq(~angle,inf),
		//\lfo,1/2,
		\spread,Pbrown(1,1.5,1,inf),  //////spherical harmonic width
		//\spread,2,
		\ripple,Pbrown(0.001,0.1,0.1,inf),  /////sphere ripple wave oscillation speed
		//\ripple,0.1,
		//\amount,Prand([4,5,6,7,8],inf),   /////sphere ripple waves amount
		\amount,5,
		\varamp,Pbrown(0.1,5,0.1,inf), /////ripple amp
		\decay,Pbrown(16,32,1,inf),
		//\varamp,1,
				\out1,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
		\out2,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
		\out3,Pn(Pshuf([0, 1, 2, 3], 1), inf).clump(4).collect([_]),
			\amp,Pseq(~r,inf);///l system
			//\amp,1;
)));
	TempoClock.default.tempo_(8);

s.meter;s.freqscope;s.scope;
}
)

/*(
	~m=Buffer.alloc(s,2048);
			{
var signal,wt,env;

		env=Env([0,1,1,0],[50,100,50],[4,0,-4]);
		signal=env.asSignal(1024);
wt=signal.asWavetable;
		//signal.plot;
~m.loadCollection(wt);
		}.value;
)*/;

(
~aa.play;
//{Out.kr(0,Osc.ar(~m.bufnum,300.reciprocal,mul:1))}.play;
{Out.kr(0,SinOsc.ar(300.reciprocal,mul:1))}.play;
);

s.record(numChannels:4);
 