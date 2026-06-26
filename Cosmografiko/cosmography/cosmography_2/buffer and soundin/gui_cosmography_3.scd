(
var sizex=1450, sizey=750, sl=170;
var px1=0,py1=0,px2=sl+(sl/2),py2=0,px3=px2+sl+(sl/2),py3=0,px4=px3+sl+(sl/2),py4=0,px5=px4+sl+(sl/2),py5=0,px6=px5+sl+(sl/2),py6=0;
var px7=0,py7=sl+(sl/4),px8=px7+sl+(sl/2),py8=sl+(sl/4),px9=px8+sl+(sl/2),py9=sl+(sl/4);
var px10=px9+sl+(sl/2),py10=sl+(sl/4),px11=px10+sl+(sl/2),py11=sl+(sl/4),px12=px11+sl+(sl/2),py12=sl+(sl/4);
var px13=0,py13=py7+sl+(sl/4),px14=px13+sl+(sl/2),py14=py7+sl+(sl/4),px15=px14+sl+(sl/2),py15=py7+sl+(sl/4),px16=px15+sl+(sl/2);
var py16=py7+sl+(sl/4),px17=px16+sl+(sl/2),py17=py7+sl+(sl/4),px18=px17+sl+(sl/2), py18=py7+sl+(sl/4);
var px19=0,py19=py13+sl+(sl/4),px20=px19+sl+(sl/2),py20=py13+sl+(sl/4);
var px21=px20+sl+(sl/2),py21=py13+sl+(sl/4),px22=px21+sl+(sl/2),py22=py13+sl+(sl/4),px23=px22+sl+(sl/2),py23=py13+sl+(sl/4),px24=px23+sl+(sl/2),py24=py13+sl+(sl/4);
//Window.closeAll;
~orange=3;
w=Window.new("c_gui", Rect(10, 10, sizex,sizey)).front;
~vw = UserView(w, Rect(0,0,sizex,sizey)).background_(Color.black);

(
~nb1=NumberBox(~vw,Rect(0+px1,(sl/4)+py1,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl1=StaticText(~vw,Rect((sl/2)+px1,(sl/4)+py1,sl/2,sl/4)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl1=Slider2D.new(~vw,Rect.new(px1,py1,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,1).postln;
~synth.set(\gain,value);
~nb1.value_(value);
});
);
(
~nb2=NumberBox(~vw,Rect(0+px2,(sl/4)+py2,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl2=StaticText(~vw,Rect((sl/2)+px2,(sl/4)+py2,sl/2,sl/4)).string_("drive").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl2=Slider2D.new(~vw,Rect.new(px2,py2,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,(16256).neg,(16256*3)).round(1).asInteger.postln;
~synth.set(\drive,value);
~nb2.value_(value);
});
);
(
~nb3=NumberBox(~vw,Rect(0+px3,(sl/4)+py3,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl3=StaticText(~vw,Rect((sl/2)+px3,(sl/4)+py3,sl/2,sl/4)).string_("band").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl3=Slider2D.new(~vw,Rect.new(px3,py3,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linexp(0,1,0.00001,10).postln;
~synth.set(\band,value);
~nb3.value_(value);
});
);
(
~nb4=NumberBox(~vw,Rect(0+px4,(sl/4)+py4,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl4=StaticText(~vw,Rect((sl/2)+px4,(sl/4)+py4,sl/2,sl/4)).string_("azimuth").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl4=Slider2D.new(~vw,Rect.new(px4,py4,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,pi.neg,pi).postln;
~synth.set(\az,value);
~nb4.value_(value);
});
);
(
~nb5=NumberBox(~vw,Rect(0+px5,(sl/4)+py5,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl5=StaticText(~vw,Rect((sl/2)+px5,(sl/4)+py5,sl/2,sl/4)).string_("elevation").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl5=Slider2D.new(~vw,Rect.new(px5,py5,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0.5pi.neg,0.5pi).postln;
~synth.set(\el,value);
~nb5.value_(value);
});
);
(
~nb6=NumberBox(~vw,Rect(0+px6,(sl/4)+py6,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl6=StaticText(~vw,Rect((sl/2)+px6,(sl/4)+py6,sl/2,sl/4)).string_("scale").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl6=Slider2D.new(~vw,Rect.new(px6,py6,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,1).round(1).asInteger.postln;
~synth.set(\scale,value);
~nb6.value_(value);
});
);
(
~nb7=NumberBox(~vw,Rect(0+px7,(sl/4)+py7,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl7=StaticText(~vw,Rect((sl/2)+px7,(sl/4)+py7,sl/2,sl/4)).string_("lowend").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl7=Slider2D.new(~vw,Rect.new(px7,py7,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,32,128).postln;
~synth.set(\lowend,value);
~nb7.value_(value);
});
);
(
~nb8=NumberBox(~vw,Rect(0+px8,(sl/4)+py8,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl8=StaticText(~vw,Rect((sl/2)+px8,(sl/4)+py8,sl/2,sl/4)).string_("c").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl8=Slider2D.new(~vw,Rect.new(px8,py8,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,16256*~orange).round(1).asInteger.postln;
~synth.set(\c,value);
~nb8.value_(value);
});
);
(
~nb9=NumberBox(~vw,Rect(0+px9,(sl/4)+py9,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl9=StaticText(~vw,Rect((sl/2)+px9,(sl/4)+py9,sl/2,sl/4)).string_("dynamic").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl9=Slider2D.new(~vw,Rect.new(px9,py9,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linexp(0,1,1,3).round(1/4).postln;
~synth.set(\dyn,value);
~nb9.value_(value);
});
);
(
~nb10=NumberBox(~vw,Rect(0+px10,(sl/4)+py10,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl10=StaticText(~vw,Rect((sl/2)+px10,(sl/4)+py10,sl/2,sl/4)).string_("speaker_size").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl10=Slider2D.new(~vw,Rect.new(px10,py10,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0.05,0.3).postln;
~synth.set(\speaker_size,value);
~nb10.value_(value);
});
);
(
~nb11=NumberBox(~vw,Rect(0+px11,(sl/4)+py11,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl11=StaticText(~vw,Rect((sl/2)+px11,(sl/4)+py11,sl/2,sl/4)).string_("room").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl11=Slider2D.new(~vw,Rect.new(px11,py11,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linexp(0,1,0.1,1).postln;
~synth.set(\room,value);
~nb11.value_(value);
});
);
(
~nb12=NumberBox(~vw,Rect(0+px12,(sl/4)+py12,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl12=StaticText(~vw,Rect((sl/2)+px12,(sl/4)+py12,sl/2,sl/4)).string_("mix").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl12=Slider2D.new(~vw,Rect.new(px12,py12,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,1).postln;
~synth.set(\mix,value);
~nb12.value_(value);
});
);
(
~nb13=NumberBox(~vw,Rect(0+px13,(sl/4)+py13,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl13=StaticText(~vw,Rect((sl/2)+px13,(sl/4)+py13,sl/2,sl/4)).string_("pann").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl13=Slider2D.new(~vw,Rect.new(px13,py13,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,(16256*10).neg,(16256*5)).round(1).asInteger.postln;
~synth.set(\pan_mod,value);
~nb13.value_(value);
});
);
(
~nb14=NumberBox(~vw,Rect(0+px14,(sl/4)+py14,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl14=StaticText(~vw,Rect((sl/2)+px14,(sl/4)+py14,sl/2,sl/4)).string_("spread").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl14=Slider2D.new(~vw,Rect.new(px14,py14,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linexp(0,1,1,0.1).postln;
~synth.set(\spread,value);
~nb14.value_(value);
});
);
(
~nb15=NumberBox(~vw,Rect(0+px15,(sl/4)+py15,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl15=StaticText(~vw,Rect((sl/2)+px15,(sl/4)+py15,sl/2,sl/4)).string_("limiter").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl15=Slider2D.new(~vw,Rect.new(px15,py15,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linexp(0,1,1,0.001).postln;
~synth.set(\limit,value);
~nb15.value_(value);
});
);
(
~nb16=NumberBox(~vw,Rect(0+px16,(sl/4)+py16,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl16=StaticText(~vw,Rect((sl/2)+px16,(sl/4)+py16,sl/2,sl/4)).string_("fundamental").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl16=Slider2D.new(~vw,Rect.new(px16,py16,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,2,9).round(1).asInteger.postln;
~synth.set(\fu,2.pow(value));
~nb16.value_(value);
});
);
(
~nb17=NumberBox(~vw,Rect(0+px17,(sl/4)+py17,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl17=StaticText(~vw,Rect((sl/2)+px17,(sl/4)+py17,sl/2,sl/4)).string_("comp").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl1=Slider2D.new(~vw,Rect.new(px17,py17,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linexp(0,1,0.001,10000).postln;
~synth.set(\comp,value);
~nb17.value_(value);
});
);
(
~nb18=NumberBox(~vw,Rect(0+px18,(sl/4)+py18,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl18=StaticText(~vw,Rect((sl/2)+px18,(sl/4)+py18,sl/2,sl/4)).string_("buffer_gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl18=Slider2D.new(~vw,Rect.new(px18,py18,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linexp(0,1,0.0001,100).postln;
~synth.set(\buffer,value);
~nb18.value_(value);
});
);
(
~nb19=NumberBox(~vw,Rect(0+px19,(sl/4)+py19,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl19=StaticText(~vw,Rect((sl/2)+px19,(sl/4)+py19,sl/2,sl/4)).string_("rect_level").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl19=Slider2D.new(~vw,Rect.new(px19,py19,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linexp(0,1,0.001,1000).postln;
~synth.set(\level,value);
~nb19.value_(value);
});
);
(
~nb20=NumberBox(~vw,Rect(0+px20,(sl/4)+py20,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl20=StaticText(~vw,Rect((sl/2)+px20,(sl/4)+py20,sl/2,sl/4)).string_("harm_mod").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl1=Slider2D.new(~vw,Rect.new(px20,py20,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,(16256*12).neg,(16256*6)).round(1).asInteger.postln;
~synth.set(\sphharm,value);
~nb20.value_(value);
});
);
(
~nb21=NumberBox(~vw,Rect(0+px21,(sl/4)+py21,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl21=StaticText(~vw,Rect((sl/2)+px21,(sl/4)+py21,sl/2,sl/4)).string_("axis").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl21=Slider2D.new(~vw,Rect.new(px21,py21,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,2).round(1).asInteger.postln;
~synth.set(\tone_axis,value);
~nb21.value_(value);
});
);
(
~nb22=NumberBox(~vw,Rect(0+px22,(sl/4)+py22,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl22=StaticText(~vw,Rect((sl/2)+px22,(sl/4)+py22,sl/2,sl/4)).string_("tonal_range").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl22=Slider2D.new(~vw,Rect.new(px22,py22,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,0,16256*~orange).round(1).asInteger.postln;
~synth.set(\ran,value);
~nb22.value_(value);
});
);
(
~nb23=NumberBox(~vw,Rect(0+px23,(sl/4)+py23,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl23=StaticText(~vw,Rect((sl/2)+px23,(sl/4)+py23,sl/2,sl/4)).string_("drone_level").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl23=Slider2D.new(~vw,Rect.new(px23,py23,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linexp(0,1,0.001,100).postln;
~synth.set(\rect_level,value);
~nb23.value_(value);
});
);
(
~nb24=NumberBox(~vw,Rect(0+px24,(sl/4)+py24,sl/2,sl/4)).background_(Color.black).normalColor_(Color.white).font_(Font('Arial',16));
~t_sl24=StaticText(~vw,Rect((sl/2)+px24,(sl/4)+py24,sl/2,sl/4)).string_("spherical_harm").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl24=Slider2D.new(~vw,Rect.new(px24,py24,sl,sl/4)).
background_(Color.gray).action_({
arg obj;
var value;
value=obj.x.value.linlin(0,1,1,10).round(1).asInteger.postln;
~synth.set(\harmonic,value);
~nb24.value_(value);
});
);
)