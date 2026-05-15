
////////////////////////////////////////////painter

(
var win,wx=0,wy=0,g=((1+5.sqrt)/2),s=(1+2.sqrt),rval=0;
var size=300,px=10,scale=300,run=true;
var az,el,polytope,mag,xp=0,yp=0,dimx,dimy,c,nx,ny,nz;
var bright,brightx,brighty,bval,pposx,pposy,posx,posy,c1,c2,c3;
var valx,valy;
//Window.closeAll;

~amp1 = 0;
~amp2 = 0;
~amp3 = 0;
//~amp4= 0;
//~amp5 = 0;
//~amp6= 0;
//~amp7= 0;

win = Window("RGB Audio", Rect(100, 10, size,size));
~view = UserView(win, Rect(0,0,size,size)).background_(Color.black);

SynthDef(\painting, {
arg lg=0.1,level=2;
var amp1 = A2K.kr(InFeedback.ar(6)*level).lag(lg);
var amp2 = A2K.kr(InFeedback.ar(7)*level).lag(lg);
var amp3 = A2K.kr(InFeedback.ar(8)*level).lag(lg);
//	var amp4 = (InFeedback.ar(5).abs*gain1).lag(lag);
//	var amp5 = (InFeedback.ar(6)*gain2).lag(lag);
//	var amp6 = (InFeedback.ar(7)*gain2).lag(lag);
//	var amp7 = (InFeedback.ar(8).abs*gain2).lag(lag);

SendReply.ar(Impulse.ar(60), '/amp1', amp1);
SendReply.ar(Impulse.ar(60), '/amp2', amp2);
SendReply.ar(Impulse.ar(60), '/amp3', amp3);
//	SendReply.ar(Impulse.ar(60), '/amp4', amp4);
//	SendReply.ar(Impulse.ar(60), '/amp5', amp5);
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

/*OSCdef(\ampt4, { |msg|
	~amp4 = msg[3];
	defer { ~v1.refresh };
}, '/amp4');

OSCdef(\ampt5, { |msg|
	~amp5 = msg[3];
	defer { ~v1.refresh };
}, '/amp5');

OSCdef(\ampt6, { |msg|
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
//mag=polytope.rho;
//bright=mag.linlin(0,mag,0.00001,1);
//c = mag.linlin(0.00001,1,0,size).round(1).asInteger;
dimx=az.linlin(0,pi,0,size).round(1).asInteger;
dimy=el.linlin(-0.5pi, 0.5pi, 0, size).round(1).asInteger;
valx=az.linlin(0,pi,0,1);
valy=el.linlin(-0.5pi, 0.5pi, 0, 1);
c1 =polytope.x.linexp(polytope.x.neg,polytope.x,0.0001,1);
c2 =polytope.y.linexp(polytope.y.neg,polytope.y,0.0001,1);
c3 =polytope.z.linexp(polytope.z.neg,polytope.z,0.0001,1);
nx=1.neg;
ny=1.neg;
posx=scale.collect{nx=nx+1};
posy=scale.collect{ny=ny+1};
//thisThread.randSeed = rval;
scale.do{
scale.do{
rval=size.rand;
brightx= if((xp==(dimx-rval).abs),1,0);
brighty= if((yp==(dimy-rval).abs),1,0);
bval=brightx+brighty;
Pen.fillColor = Color.new(c1,c2,c3,bval);
Pen.fillRect(Rect.new((posx.[xp]),(posy.[yp]),px,px));
xp=xp+1;
};
yp=yp+1; 	xp=0;
};
yp=0;
}
);
{ while { run } {~view.background_(Color.black); ~view.refresh; (1/120).wait } }.fork(AppClock);
win.front;
(
~synth=Synth.new(\synth,[\gain,1,\drive,0,\c,0,\az,0,\el,0,\scale,0,\harmonic,1,\fl,7.5,
				\bg1,0.001,\bg2,0.001,\bg3,0.001,\bg4,0.001,\bg5,0.001,\bg6,0.001,\bg7,0.001,\bg8,0.001,\bg9,0.001,
				\lowend,64,\level,600,\dyn,1,\comp,1,\buffer,1,\tone_axis,1,\ran,16256,\rect_level,2,
\sphharm,0,\speaker_size,0.15,\room,0.5,\mix,0.3,\pan_mod,16*16256.neg,\spread,1,\limit,0.8,\fu,64,\band,10]).register);
~synthp = Synth(\painting).register;
)


~synthp.set(\lg,5)
~synthp.set(\level,5)
~synthp.free


