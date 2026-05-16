
////////////////////////////////////////////painter

(
var win,wx=0,wy=0,g=((1+5.sqrt)/2),s=(1+2.sqrt),rval=0,rvalc=0;
var size=300,px=4,run=true;
var az,el,polytope,mag,xp=0,yp=0,dimx,dimy,c,n;
var bright,brightx,brighty,bval,pos,c1,c2,c3;
var valx,valy,limit=64,rval1=0,rval2=0;
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
var amp1 = A2K.kr(InFeedback.ar(9)*level).lag(lg);
var amp2 = A2K.kr(InFeedback.ar(10)*level).lag(lg);
var amp3 = A2K.kr(InFeedback.ar(11)*level).lag(lg);
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

(
~view.drawFunc = {
polytope=	Cartesian(~amp1,~amp2,~amp3).asSpherical;
az=polytope.theta;
el=polytope.phi;
mag=polytope.rho;
rval2=mag.linlin(0,2.sqrt,0,1);
c=mag.linlin(0,2.sqrt,0,limit).round(1).asInteger;
//dimx=az.linlin(pi.neg,pi,0,size).round(1).asInteger;
//dimy=el.linlin(-0.5pi, 0.5pi, 0, size).round(1).asInteger;
dimx=exp(Complex(0,1)*az);
dimy=exp(Complex(0,1)*el);
dimx=(dimx*size).round(1).asInteger;
dimy=(dimy*size).round(1).asInteger;
c1 =Spherical(1,az,el).x;
c2 =Spherical(1,az,el).y;
c3 =Spherical(1,az,el).z;
n=1.neg;
pos=size.collect{n=n+1};
size.do{
size.do{
bright=Complex(xp.linlin(0,size,0,2.sqrt.reciprocal),yp.linlin(0,size,0,2.sqrt.reciprocal)).rho;
rval=c.rand2;
rvalc=0.2.rand2;
rval1=0;
brightx= if((xp==(dimx+rval).wrap(0,size)),(bright+rval1).wrap(0,1),0);
brighty= if((yp==(dimy+rval).wrap(0,size)),(bright+rval1).wrap(0,1),0);
bval=brightx+brighty;
Pen.fillColor = Color.new((c1+rvalc).wrap(0,1),(c2+rvalc).wrap(0,1),(c3+rvalc).wrap(0,1),bval);
Pen.fillRect(Rect.new((pos.[xp]),(pos.[yp]),px,px));
xp=xp+1;
};
yp=yp+1; 	xp=0;
};
yp=0;
}
);
{ while { run } {~view.background_(Color.black); ~view.refresh; (1/60).wait } }.fork(AppClock);
win.front;
(
~synth=Synth.new(\synth,[\gain,10,\drive,0,\c,0,\az,pi.rand,\el,0,\size,0,\harmonic,1,\fl,7.5,
				\bg1,0.001,\bg2,0.001,\bg3,0.001,\bg4,0.001,\bg5,0.001,\bg6,0.001,\bg7,0.001,\bg8,0.001,\bg9,0.001,
				\lowend,64,\level,600,\dyn,1,\comp,1,\buffer,1,\tone_axis,1,\ran,16256,\rect_level,2,
\sphharm,16*16256.neg,\speaker_size,0.15,\room,0.5,\mix,0.3,\pan_mod,16*16256.neg,\spread,1,\limit,0.8,\fu,64,\band,10]).register);
~synthp = Synth(\painting).register;
)


~synthp.set(\lg,1)
~synthp.free

//thisThread.randSeed = rval;
