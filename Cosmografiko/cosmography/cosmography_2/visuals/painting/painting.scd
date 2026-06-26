
////////////////////////////////////////////painter

(
var win,wx=0,wy=0,g=((1+5.sqrt)/2),s=(1+2.sqrt),rval=0,rvalc=0;
var size=500,px=100,run=true,angle1=0,angle2=0;
var az,el,polytope,mag,dimx,dimy,c,n;
var bright,brightx,brighty,bval,pos,c1,c2,c3;
var valx=0,valy,limit=100,rval1=0,rval2=0,xx,yy,zz;
//Window.closeAll;

~amp1 = 0;
~amp2 = 0;
~amp3 = 0;
//~amp4= 0;
//~amp5 = 0;
//~amp6= 0;
//~amp7= 0;
Window.closeAll;
win = Window("RGB Audio", Rect(100, 10, size,size));
~view = UserView(win, Rect(0,0,size,size)).background_(Color.black);

SynthDef(\painting, {
arg lg=0.001,level=2;
var amp1 = A2K.kr(InFeedback.ar(0)*level).lag(lg);
var amp2 = A2K.kr(InFeedback.ar(1)*level).lag(lg);
var amp3 = A2K.kr(InFeedback.ar(2)*level).lag(lg);
//	var amp4 = A2K.kr(InFeedback.ar(0)*level).lag(lg);
//	var amp5 = A2K.kr(InFeedback.ar(1)*level).lag(lg);
//	var amp6 = (InFeedback.ar(7)*gain2).lag(lag);
//	var amp7 = (InFeedback.ar(8).abs*gain2).lag(lag);

SendReply.ar(Impulse.ar(60), '/amp1', amp1);
SendReply.ar(Impulse.ar(60), '/amp2', amp2);
SendReply.ar(Impulse.ar(60), '/amp3', amp3);
//SendReply.ar(Impulse.ar(60), '/amp4', amp4);
//SendReply.ar(Impulse.ar(60), '/amp5', amp5);
//	SendReply.ar(Impulse.ar(60), '/amp6', amp6);
//	SendReply.ar(Impulse.ar(60), '/amp7', amp7);
}).add;
~synthp = Synth(\painting).register;

OSCdef(\ampt1, { |msg|
~amp1 = msg[3];
//defer { ~view.refresh };
}, '/amp1');

OSCdef(\ampt2, { |msg|
~amp2 = msg[3];
//defer { ~view.refresh };
}, '/amp2');

OSCdef(\ampt3, { |msg|
~amp3 = msg[3];
//defer { ~view.refresh };
}, '/amp3');

// OSCdef(\ampt4, { |msg|
// 	~amp4 = msg[3];
// 	//	defer { ~view.refresh };
// }, '/amp4');
//
// OSCdef(\ampt5, { |msg|
// 	~amp5 = msg[3];
// 	//	defer { ~view.refresh };
// }, '/amp5');

/*OSCdef(\ampt6, { |msg|
	~amp6 = msg[3];
	defer { ~v1.refresh };
}, '/amp6');

OSCdef(\ampt7, { |msg|
	~amp7 = msg[3];
	defer { ~v1.refresh };
}, '/amp7');*/
//~view.animate=true;
//(512/16)*(512/16)
(
~view.drawFunc = {
polytope=	Cartesian(~amp1,~amp2,~amp3).asSpherical;
az=polytope.theta;
el=polytope.phi;
xx=az.linlin(0,pi,0,size);
yy=el.linlin(0,0.5pi,0,size);
//valx=az.linlin(pi.neg,pi,0,0.5);
//valy=el.linlin(0.5pi.neg,0.5pi,0,0.5);
//bright=valx+valy;
//mag=polytope.rho;
//c=mag.linlin(0,1,0,limit).round(1).asInteger;
//dimx=az.linlin(pi.neg,pi,0,size).round(1).asInteger;
//dimy=el.linlin(-0.5pi, 0.5pi, 0, size).round(1).asInteger;
//dimx=exp(Complex(0,1)*az);
//dimy=exp(Complex(0,1)*(el*2));
//dimx=(dimx*size).round(1).asInteger;
//dimy=(dimy*size).round(1).asInteger;
c1 =Spherical(1,az,el).x;
c2 =Spherical(1,az,el).y;
c3 =Spherical(1,az,el).z;
n=1.neg;
pos=(size).collect{n=n+1};
//angle1=0;
//angle2=0;
//bright=Complex(xp.linlin(0,size,0,2.sqrt.reciprocal),yp.linlin(0,size,0,2.sqrt.reciprocal)).theta;
//angle1=(angle1+(2pi/(2pi/g))).wrap(0,2pi);
//angle2=(angle2+(2pi/(2pi/g))).wrap(0,2pi).linlin(0,2pi,0,1);
////valx=exp(Complex(0,1)*angle1*bright).real;
//valy=exp(Complex(0,1)*angle1*bright).imag;
//rval=c.rand2;
//brightx= if((xp==(dimx+rval).wrap(0,size)),(valx).wrap(0,1),0);
//brighty= if((yp==(dimy+rval).wrap(0,size)),(valy).wrap(0,1),0);
//bval=brightx+brighty;
//bright=xx+yy;
Pen.fillColor = Color.new(c1,c2,c3);
Pen.fillRect(Rect.new((pos.[xx]),(pos.[yy]),px,px));
};
{ while { run } {~view.background_(Color.black); ~view.refresh; (1/60).wait } }.fork(AppClock);
win.front;
);
)


~synthp.set(\lg,0.001)
~synthp.free

//thisThread.randSeed = rval;
