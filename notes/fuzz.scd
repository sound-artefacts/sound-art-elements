

	(
{
    var t, sf;
    sf = Saw.ar(10);
    t = TBall.ar(sf, Saw.ar(220,mul:100).abs, 0.0001).abs;
    Pan2.ar(t*SinOsc.ar(220)*100,0);
}.play;
)