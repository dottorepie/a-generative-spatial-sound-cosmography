
////////////////////////////////////////////painter

(
var win,wx=0,wy=0,g=((1+5.sqrt)/2),s=(1+2.sqrt),size=1000,scale=400,px=10;
var az,el,polytope,mag,xp=0,yp=0,dimx,dimy,c,nx,ny,nz;
var c1,c2,c3,cx,cy,cz,cdimx,cdimy,cdimz;
var run=true,pposx,pposy,posx,posy,bvalx,bvaly,bvalz,bvalx_0,bvaly_0,bvalz_0;
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
defer { ~view.refresh };
}, '/amp1');

OSCdef(\ampt2, { |msg|
~amp2 = msg[3];
defer { ~view.refresh };
}, '/amp2');

OSCdef(\ampt3, { |msg|
~amp3 = msg[3];
defer { ~view.refresh };
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
polytope=	Cartesian(~amp1,~amp2,~amp3);
az=polytope.theta;
el=polytope.phi;
mag=polytope.rho;
dimx=az.linlin(0,pi,0,scale).round(1).asInteger;
dimy = el.linlin(-0.5pi, 0.5pi, 0, scale).round(1).asInteger;
cdimx=Spherical(1,az,el).x.linlin(1.neg,1,0,scale).round(1).asInteger;
cdimy=Spherical(1,az,el).y.linlin(1.neg,1,0,scale).round(1).asInteger;
cdimz=Spherical(1,az,el).z.linlin(1.neg,1,0,scale).round(1).asInteger;
c = mag.linlin(0,mag,0,scale).round(1).asInteger;
c1 =Spherical(1,az,el).x.linlin(1.neg,1,0,0.5);
c2 =Spherical(1,az,el).y.linlin(1.neg,1,0,0.5);
c3 =Spherical(1,az,el).z.linlin(1.neg,1,0,0.5);
nx = 1.neg;
ny = 1.neg;
pposx=scale.collect{nx=nx+1; if(nx==dimx,c,nx)};
pposy=scale.collect{ny=ny+1; if(ny==dimy,c,ny)};
nx=1.neg;
ny=1.neg;
nz=1.neg;
cx=scale.collect{nx=nx+1; if(nx==cdimx,c1,0.5.rand)};
cy=scale.collect{ny=ny+1; if(ny==cdimy,c2,0.5.rand)};
cz=scale.collect{nz=nz+1; if(nz==cdimz,c3,0.5.rand)};
nx = 1.neg;
ny = 1.neg;
posx=scale.collect{nx=nx+1};
posy=scale.collect{ny=ny+1};
//~posx=scale.collect{xp=xp+1}; xp=0;
//~posy=scale.collect{yp=yp+1}; yp=0;
scale.do{
bvalx_0=(cx.[yp]);
bvaly_0=(cy.[yp]);
bvalz_0=(cz.[yp]);
scale.do{
bvalx=(bvalx_0+cx.[xp]);
bvaly=(bvaly_0+cy.[xp]);
bvalz=(bvalz_0+cz.[xp]);
Pen.fillColor = Color.new(bvalx,bvaly,bvalz);
Pen.fillRect(Rect.new((pposx.[xp]),(pposy.[yp]),px,px));
xp=xp+1;
};
yp=yp+1; 	xp=0;
};
yp=0;
}
);
//{ while { run } {~view.background_(Color.black); ~view.refresh; (1/8).wait } }.fork(AppClock);
win.front;
~synthp = Synth(\painting).register;
)


~synthp.set(\lg,1)
~synthp.free


