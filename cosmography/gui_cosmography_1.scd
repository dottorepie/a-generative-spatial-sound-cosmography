(
var size=500, size_sl=150;
Window.closeAll;
w=Window.new("c_gui", Rect(10, 10, size,size)).front;
~v = UserView(w, Rect(0,0,size,size)).background_(Color.black);

(
~nb1=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl1=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl1=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb1.value_(value);
});
);
(
~nb2=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl2=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl2=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb2.value_(value);
});
);
(
~nb3=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl3=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl3=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb3.value_(value);
});
);
(
~nb4=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl4=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl4=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb4.value_(value);
});
);
(
~nb5=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl5=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl5=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb5.value_(value);
});
);
(
~nb6=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl6=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl6=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb6.value_(value);
});
);
(
~nb7=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl7=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl7=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb7.value_(value);
});
);
(
~nb8=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl8=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl8=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb8.value_(value);
});
);
(
~nb9=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl9=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl9=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb9.value_(value);
});
);
(
~nb10=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl10=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl10=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb10.value_(value);
});
);
(
~nb11=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl11=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl11=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb11.value_(value);
});
);
(
~nb12=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl12=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl12=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb12.value_(value);
});
);
(
~nb13=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl13=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl13=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb13.value_(value);
});
);
(
~nb14=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl14=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl14=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb14.value_(value);
});
);
(
~nb15=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl15=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl15=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb15.value_(value);
});
);
(
~nb16=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl16=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl16=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb16.value_(value);
});
);
(
~nb17=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl17=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl1=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb17.value_(value);
});
);
(
~nb18=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl18=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl18=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb18.value_(value);
});
);
(
~nb19=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl19=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl19=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb19.value_(value);
});
);
(
~nb20=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl20=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl1=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb20.value_(value);
});
);
(
~nb21=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl21=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl21=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb21.value_(value);
});
);
(
~nb22=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl22=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl22=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb22.value_(value);
});
);
(
~nb23=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl23=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl23=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb23.value_(value);
});
);
(
~nb24=NumberBox(~v,Rect(size_sl,0,50,50)).background_(Color.gray);
~t_sl24=StaticText(~v,Rect(size_sl,50,50,50)).string_("gain").stringColor_(Color.white).background_(Color.black).font_(Font('Arial',16));
~sl24=Slider2D.new(~v,Rect.new(0,0,size_sl,size_sl)).
background_(Color.gray).action_({
arg obj;
var value;
value=Complex(obj.x,obj.y).rho.value.linexp(0,1,10,100).postln;
~synth.set(\gain,value);
~nb24.value_(value);
});
);
)