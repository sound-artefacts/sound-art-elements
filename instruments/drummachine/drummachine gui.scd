(

Window.closeAll;
w=Window.new("gui",Rect.new(100,100,800,600)).front.alwaysOnTop_(true);

~aa = Slider.new(w.view,Rect.new(20,20,500,30));

~bb = Slider.new(w.view,Rect.new(20,60,500,30));

~cc = Slider2D.new(w.view,Rect.new(60,280,600,300));


~ee = Slider.new(w.view,Rect.new(20,140,500,30));

~ff = Slider.new(w.view,Rect.new(20,180,500,30));

~gg = Slider.new(w.view,Rect.new(20,220,500,30));

~on = Button(w,Rect(10,500,30,30)).states_([
			["off",Color.black,Color.gray],["on",Color.white,Color.gray]]).action_({
	arg obj;
	if(
		obj.value==1,{~synth=Synth.new(\ospace,[
	\gain,~aa.value,
	\lfo_amp,~bb.value.linlin(0,1,0.01,20).round(1/32),
	\spread,~ee.value.linlin(0,1,1,20),
	\ripple,~ff.value.linlin(0,1,0.0001,0.5),
	\amount,~gg.value.linlin(0,1,1,100).round(1),
\elevation,~cc.x.linlin(0,1,180.neg.degrad,180.degrad),
	\azimuth,~cc.y.linlin(0,1,90.neg.degrad,90.degrad)]).register},
		{~synth.free}
)});
(
a = StaticText(w, Rect(530,20,200, 20));
a.string = "gain";
b = StaticText(w, Rect(530,60,200, 20));
b.string = "spherical harmonic amp lfo";
d = StaticText(w, Rect(530,140,200, 20));
d.string = "spherical harmonic width";
e = StaticText(w, Rect(530,180,200, 20));
e.string = "ripple speed";
f = StaticText(w, Rect(530,220,200, 20));
f.string = "ripple waves";
g = StaticText(w, Rect(670,400,100, 70));
g.string = "3d tone coordinate (x_azimuth,
y_elevation)";
);

(
~aa.value_(1).action_({
	arg obj;
					var gain;
	obj.value.postln;
	gain=obj.value;
	if(~synth.isPlaying,{~synth.set(\gain,gain)});
});
);
(
~bb.value_(1).action_({
	arg obj;
			var lfo_amp;
	lfo_amp=obj.value.linlin(0,1,0.01,20).round(1/32);
				lfo_amp.value.postln;
		if(~synth.isPlaying,{~synth.set(\lfo_amp,lfo_amp)});
});
);
(
~cc.action_({
	arg obj;
			var az,el;
	az=obj.x.linlin(0,1,180.neg.degrad,180.degrad);
	el=obj.y.linlin(0,1,90.neg.degrad,90.degrad);
			if(~synth.isPlaying,{~synth.set(\azimuth,az,\elevation,el)});
});
);
(
~ee.action_({
	arg obj;
			var spread;
			spread=obj.value.linlin(0,1,1,20);
				spread.value.postln;
if(~synth.isPlaying,{~synth.set(\spread,spread)});
});
);
	(
~ff.action_({
	arg obj;
			var ripple;
			ripple=obj.value.linlin(0,1,0.0001,0.5);
				ripple.value.postln;
if(~synth.isPlaying,{~synth.set(\ripple,ripple)});
});
);
			(
~gg.action_({
	arg obj;
			var amount;
				amount=obj.value.linlin(0,1,1,100).round(1);
				amount.value.postln;
if(~synth.isPlaying,{~synth.set(\amount,amount)});
});
);
	)