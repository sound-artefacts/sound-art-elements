

(
{
var n1,n2,g=((1+5.sqrt)/2),angle=0,fund=110,amp1,amp2;
	2048.do{
		n1=exp(Complex(0,1)*angle).real*(20000-fund);
		n2=exp(Complex(0,1)*angle).imag*(20000-fund);
		amp1=exp(Complex(0,1)*angle).real.linlin(0,1,1,0);
		amp2=exp(Complex(0,1)*angle).imag.linlin(0,1,1,0);
		angle=(angle+(2pi-(2pi/g))).wrap(0,2pi);
		Out.ar(0,SinOsc.ar(fund+n1,0pi,mul:amp1)*0.001);
		Out.ar(1,SinOsc.ar(fund+n2,0.5pi,mul:amp2)*0.001);

	}
}.play
)
		