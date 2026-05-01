
Server.killAll
(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=1;
s.options.memSize = 8192*8;
s.options.blockSize = 128;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
//s.boot;
);

//
(
s.waitForBoot{
//s.freqscope;
//s.scope;
//s.makeWindow;
s.meter;
	Tdef(\drone, {
	Buffer.freeAll;

					//tetrahedron
		(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
////// wavetables

		//oscillator table
		(
~n=1.neg;~array=992.collect{~n=~n+1;2.pow(~n/992)};
~n=(0-(2pi/992)); ~ph=992.collect{~n=~n+(2pi/992);};
~bufferSize = 4096*8;
~signalSize = 2048*8;
);


		(
~wt= Buffer.alloc(s,~bufferSize);
		{
	var signal,wt;
signal=Signal.sineFill(~signalSize,~array,[0],~ph);

wt = signal.asWavetable;
~wt.loadCollection(wt);
//signal.plot;
		}.value;
);

		/////scales

(
			{
				var nn=1.neg;
		~scalee=10.collect{nn=nn+1;Scale.majorPentatonic.performDegreeToKey(nn,12)};
			}.value;
		);

		(
			{
				var nn=1.neg;
		~scaleee=10.collect{nn=nn+1;Scale.minorPentatonic.performDegreeToKey(nn,12)};
			}.value;
		);

		~sc=[~scalee,~scaleee];

		////sound
(
SynthDef.new(\synthd,{

arg

var

expaansion=2.pow(c/16256);
fundamental=(fu*(9/8))*expansion;
sph_mod=2.pow(sph.lag(0.001)/16256);
polytope=Spherical(timbre_range,az.lag(0.001),el.lag(0.001));

ton1=2.pow(Select.kr(tone1, Select.kr(qqq.lag(0.001),~sc)) /12).round(0.0001)*2.pow(dron.lag(0.001)/16256);
ton2=2.pow(Select.kr(tone2, Select.kr(qqq.lag(0.001),~sc)) /12).round(0.0001)*2.pow(dron.lag(0.001)/16256);
ton3=2.pow(Select.kr(tone3, Select.kr(qqq.lag(0.001),~sc)) /12).round(0.0001)*2.pow(dron.lag(0.001)/16256);

tonal_x=2.pow(polytope.x.round(1) /16256).round(0.00001);
tonal_y=2.pow(polytope.y.round(1) /16256).round(0.00001);
tonal_z=2.pow(polytope.z.round(1) /16256).round(0.00001);


mod_x=polytope.x.round(0.00001);   mod_y=polytope.y.round(0.00001);   mod_z=polytope.z.round(0.00001);
phase_mod_x=(Complex(1,mod_x).theta*4);   phase_mod_y=(Complex(1,mod_y).theta*4);   phase_mod_z=(Complex(1,mod_z).theta*2);

mod_anglex=(LPF.ar((Osc.ar(~wt.bufnum,sph_mod,phase:phase_mod_x,mul:level).abs*
SinOsc.ar(sph_mod,phase:phase_mod_x)),
sph_mod*2.pow(low.lag(0.01)/992),1).abs*
(LPF.ar((Osc.ar(~wt.bufnum,sph_mod/4,phase:phase_mod_x,mul:level).abs*
SinOsc.ar(sph_mod/4,phase:phase_mod_x)),
(sph_mod/4)*2.pow(low.lag(0.01)/992),(sph_mod/4).reciprocal))).range(pi.neg,pi).lag(0.001);

mod_angley=(LPF.ar((Osc.ar(~wt.bufnum,sph_mod,phase:phase_mod_y,mul:level).abs*
SinOsc.ar(sph_mod,phase:phase_mod_y)),
sph_mod*2.pow(low.lag(0.01)/992),1).abs*
(LPF.ar((Osc.ar(~wt.bufnum,sph_mod/4,phase:phase_mod_y,mul:level).abs*
SinOsc.ar(sph_mod/4,phase:phase_mod_y)),
(sph_mod/4)*2.pow(low.lag(0.01)/992),(sph_mod/4).reciprocal))).range(pi.neg,pi).lag(0.001);

mod_anglez=(LPF.ar((Osc.ar(~wt.bufnum,sph_mod,phase:phase_mod_z,mul:level).abs*
SinOsc.ar(sph_mod,phase:phase_mod_z)),
sph_mod*2.pow(low.lag(0.01)/992),1).abs*
(LPF.ar((Osc.ar(~wt.bufnum,sph_mod/4,phase:phase_mod_z,mul:level).abs*
SinOsc.ar(sph_mod/4,phase:phase_mod_z)),
(sph_mod/4)*2.pow(low.lag(0.01)/992),(sph_mod/4).reciprocal))).range(35.264390.degrad,35.264390.degrad.neg).lag(0.001);

magx=((Complex(cos(((polytope.theta+mod_anglex).round(0.00001)*m).wrap(pi.neg,pi)),
cos((((polytope.theta+mod_anglex).round(0.00001)*m)).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)););

magy=((Complex(sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi)),
sin(((polytope.theta+mod_angley).round(0.00001)*m).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)););

magz=((Complex(cos(((polytope.phi+mod_anglez).round(0.00001)*m).wrap((pi/2).neg,(pi/2))),
cos(((polytope.phi).round(0.00001)*m).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));



	 angtheta = polytope.theta;
     angphi = polytope.phi;
	wave = amp*sin((waveFreq * angtheta) + (waveFreq * angphi )- waveSpeed);


sph_x=(Cartesian(wave,0,0).rho);   sph_y=(Cartesian(0,magy,0).rho);   sph_z=(Cartesian(0,0,magz).rho);
sph_mag=(Cartesian(sph_x,sph_y,sph_z));
sph=Spherical(sph_mag.rho,polytope.theta,polytope.phi);

phasex=Complex(1,sph.x).theta*4;   phasey=Complex(1,sph.y).theta*4;   phasez=Complex(1,sph.z).theta*2;
freq1=(fundamental*ton1)*tonal_x;   freq2=(fundamental*ton2)*tonal_y;   freq3=(fundamental*ton3)*tonal_z;
amp1=expaansion.reciprocal*ton1.reciprocal*tonal_x.reciprocal;
amp2=expaansion.reciprocal*ton2.reciprocal*tonal_y.reciprocal;
amp3=expaansion.reciprocal*ton3.reciprocal*tonal_z.reciprocal;
g1=b_x.reciprocal*dr.reciprocal*ton1.reciprocal;
g2=b_y.reciprocal*dr.reciprocal*ton2.reciprocal;
g3=b_z.reciprocal*dr.reciprocal*ton3.reciprocal;

octave1=2.pow(step1/16256);
octave2=2.pow(step2/16256);
octave3=2.pow(step3/16256);
octave4=2.pow(step4/16256);
octave5=2.pow(step5/16256);
octave6=2.pow(step6/16256);
octave7=2.pow(step7/16256);
octave8=2.pow(step8/16256);
octave9=2.pow(step9/16256);


				(
ds1=((LPF.ar(
(Osc.ar(~wt.bufnum,(f1*dr1.reciprocal),phase:phasex+rph,mul:level).abs*
SinOsc.ar((f1*dr1.reciprocal),phase:phasex+rph)),(f1*dr1.reciprocal)*2.pow(low.lag(0.01)/992),(g1*dr1))).abs
*BPF.ar((SoundIn.ar(0,gain)*qq.sqrt.reciprocal),(f1*dr2.reciprocal),qq,(g1*dr2)));

ds2=((LPF.ar(
(Osc.ar(~wt.bufnum,f2*dr1.reciprocal,phase:phasey+rph,mul:level).abs*
SinOsc.ar((f2*dr1.reciprocal),phase:phasey+rph)),(f2*dr1.reciprocal)*2.pow(low.lag(0.01)/992),(g2*dr1))).abs
*BPF.ar((SoundIn.ar(0,gain)*qq.sqrt.reciprocal),(f2*dr2.reciprocal),qq,(g2*dr2)));

ds3=((LPF.ar(
(Osc.ar(~wt.bufnum,(f3*dr1.reciprocal),phase:phasez+rph,mul:level).abs*
SinOsc.ar((f3*dr1.reciprocal),phase:phasez+rph)),(f3*dr1.reciprocal)*2.pow(low.lag(0.01)/992),(g3*dr1))).abs
*BPF.ar((SoundIn.ar(0,gain)*qq.sqrt.reciprocal),(f3*dr2.reciprocal),qq,(g3*dr2)));
				);


sig1=(LPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex,mul:level).abs*SinOsc.ar(freq1,phase:phasex)),freq1*2.pow(low.lag(0.01)/992),amp1).abs*(ds1));
sig2=(LPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey,mul:level).abs*SinOsc.ar(freq2,phase:phasey)),freq2*2.pow(low.lag(0.01)/992),amp2).abs*(ds2));
sig3=(LPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez,mul:level).abs*SinOsc.ar(freq3,phase:phasez)),freq3*2.pow(low.lag(0.01)/992),amp3).abs*(ds3));


sig1 = (sig1*2.pow(drive/992)).softclip;
sig2 =  (sig2*2.pow(drive/992)).softclip;
sig3 =  (sig3*2.pow(drive/992)).softclip;

control1=SinOsc.ar(freq1,phase:phasex,mul:amp1);
control2=SinOsc.ar(freq2,phase:phasey,mul:amp2);
control3=SinOsc.ar(freq3,phase:phasez,mul:amp3);

threshold1=(((343/speaker_size)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/speaker_size)/fund).reciprocal.ampdb/2.sqrt).dbamp;
threshold3=(((343/speaker_size)/fund).reciprocal.ampdb/2.sqrt).dbamp;

sig1=HPF.ar(sig1,lowend);   sig2=HPF.ar(sig2, lowend);   sig3=HPF.ar(sig3, lowend);

sig1=Compander.ar(sig1,control1,threshold1,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
sig2=Compander.ar(sig2,control2,threshold2,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
sig3=Compander.ar(sig3,control3,threshold3,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);


g_ch1 = (
(Spherical(mx.lag(0.01),(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
Spherical(mag.x,~az[0],~el[0]).x) +
(Spherical(my.lag(0.01),(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
Spherical(mag.y,~az[0],~el[0]).y)+
(Spherical(mz.lag(0.01),(polytope.theta+).wrap(pi,pi.neg),(polytope.phi).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
Spherical(mag.z,~az[0],~el[0]).z)
);
g_ch2 = (
(Spherical(mx.lag(0.01),(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
Spherical(mag.x,~az[1],~el[1]).x)+
(Spherical(mz.lag(0.01),(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
Spherical(mag.y,~az[1],~el[1]).y)+
(Spherical(mz.lag(0.01),(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
Spherical(mag.z,~az[1],~el[1]).z)
);
g_ch3 = (
(Spherical(mx.lag(0.01),(polytope.theta).wrap(pi,pi.neg),(polytope.phi ).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
Spherical(mag.x,~az[2],~el[2]).x)+
(Spherical(my.lag(0.01),(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
Spherical(mag.y,~az[2],~el[2]).y)+
(Spherical(mz.lag(0.01),(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
Spherical(mag.z,~az[2],~el[2]).z)
);
g_ch4 = (
(Spherical(mx.lag(0.01),(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(35.264390.degrad,35.264390.degrad.neg)).x *
Spherical(mag.x,~az[3],~el[3]).x) +
(Spherical(my.lag(0.01),(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(35.264390.degrad,35.264390.degrad.neg)).y *
Spherical(mag.y,~az[3],~el[3]).y)+
(Spherical(mz.lag(0.01),(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(35.264390.degrad,35.264390.degrad.neg)).z *
Spherical(mag.z,~az[3],~el[3]).z)
					);

g_ch1 = g_ch1.pow(spread);   g_ch2 = g_ch2.pow(spread);   g_ch3 = g_ch3.pow(spread);   g_ch4 = g_ch4.pow(spread);
pan1=SinOsc.ar(pan_mod,0).range(spread.linlin(0.001,1,1,0.001),1);
pan2=SinOsc.ar(pan_mod,0.25pi).range(spread.linlin(0.001,1,1,0.001),1);
pan3=SinOsc.ar(pan_mod,0.5pi).range(spread.linlin(0.001,1,1,0.001),1);
pan4=SinOsc.ar(pan_mod,0.75pi).range(spread.linlin(0.001,1,1,0.001),1);

(
Out.ar(0,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain)),0.9,0.01));
Out.ar(1,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1*g_ch2*pon2,mix.lag(0.001),room.lag(0.001),mul:gain)),0.9,0.01));
Out.ar(2,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain)),0.9,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain)),0.9,0.01));

Out.ar(0,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain)),0.9,0.01));
Out.ar(1,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain)),0.9,0.01));
Out.ar(2,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2*g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain)),0.9,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2 g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain)),0.9,0.01));

Out.ar(0,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain)),0.9,0.01)/);
Out.ar(1,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain)),0.9,0.01));
Out.ar(2,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3* g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain)),0.9,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain)),0.9,0.01));
				);

			////stereo
					/*(
Out.ar(0,Pan2.ar(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*sph_x)),0.9,0.01),SinOsc.ar(pan,0)));
Out.ar(0,Pan2.ar(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*sph_y)),0.9,0.01),SinOsc.ar(pan,90.degrad)));
Out.ar(0,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain3*sph_z)),0.9,0.01)!2);
					)*/

	///three channel
					/*(
Out.ar(4,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain*sph_x)),0.9,0.01));
Out.ar(5,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain*sph_y)),0.9,0.01));
Out.ar(6,Limiter.ar(LeakDC.ar(FreeVerb.ar(sig3,mix.lag(0.01),room.lag(0.01),mul:gain*sph_z)),0.9,0.01));
					)*/


}).add);

2.wait;


		(

~synthd=Synth.new(\synthd,[\gain,3,\drive,992*2,\fu,16,\tone1,0,\tone2,0,\tone3,0,\low,992*0,\pan,(992*16).neg,
		\mix,0.3,\drone_amp,1,\room,0.5,\m,1,\pann,(992*16).neg,\pon,0.001,\pneuma,0, \namp,1,\rph,0,\rlx,1,\rla1,1,\rla2,3,
			\x,1,\a,1,\panx,0.01,\pany,0.01,\panz,0.01,\spread,1,
			\az,pi/4,\el,pi/8,\azr,992,\dron,0,\drone,1,\sc,1]).register;
);

	});
	Tdef(\drone).play;
}
)
)





(
	TempoClock.default.tempo_(3);
///sequencer
({
			var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=4,time=8.reciprocal,beat=1,r=0;
			~r=0;		~r1=0;		~r2=0;
				(

			~dur1=[];~dur2=[];~dur3=[]; ~dx=[];~dy=[]; ~dz=[]; ~durx=[]; ~dury=[]; ~durz=[]; ~dur=[];

					1.do{
~x=bank.collect{
m1=m1+1;
					b=Spherical(beat,~az.[m1],~el.[m1]).rotate(~r).tilt(~r1).tumble(~r2).x.round(0.00001);
	2.pow(b).round(time);
};
~y=bank.collect{
m2=m2+1;
	c=Spherical(beat,~az.[m2],~el.[m2]).rotate(~r).tilt(~r1).tumble(~r2).y.round(0.00001);
	2.pow(c).round(time);
};
~z=bank.collect{
m3=m3+1;
	d=Spherical(beat,~az.[m3],~el.[m3]).rotate(~r).tilt(~r1).tumble(~r2).z.round(0.00001);
	2.pow(d).round(time);
}; m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };

				bank.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
		//	~durx = ~dur1.collect { |x| if (x == 0) { Rest(2) } { x }};

		bank.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
			//	~dury = ~dur2.collect { |x| if (x == 0) { Rest(2) } { x }};

		bank.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
			//	~durz = ~dur3.collect { |x| if (x == 0) { Rest(2) } { x }};

			~dur=~dur++~dur1++~dur2++~dur3;
);
		}.value);

				~seqen= Pseq(~dur ,inf).asStream;


		(
	~str1= Routine({loop{



	~synthd.set(\tone1, ~s1);
~synthd.set(\tone2, ~s1);
	~synthd.set(\tone3, ~s1);
    ~seqen.next.wait;

		~synthd.set(\tone1, ~s2);
~synthd.set(\tone2, ~s2);
	~synthd.set(\tone3, ~s2);

	    ~seqen.next.wait;

	~synthd.set(\tone1, ~s3);
~synthd.set(\tone2, ~s3);
	~synthd.set(\tone3, ~s3);

	    ~seqen.next.wait;

	~synthd.set(\tone1, ~s4);
~synthd.set(\tone2, ~s4);
	~synthd.set(\tone3, ~s4);

	    ~seqen.next.wait;

				~synthd.set(\tone1, ~s5);
~synthd.set(\tone2, ~s5);
	~synthd.set(\tone3, ~s5);

	    ~seqen.next.wait;

	~synthd.set(\tone1, ~s6);
~synthd.set(\tone2, ~s6);
		~synthd.set(\tone3, ~s6);

	    ~seqen.next.wait;

	~synthd.set(\tone1, ~s7);
~synthd.set(\tone2, ~s7);
	~synthd.set(\tone3, ~s7);

	    ~seqen.next.wait;

};
		}));

)

	~str1.play;

s.record(numChannels:4)







/*
/tetrahedron
(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);
//////cube
(
~az=[45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////octahedron

(
~az=[0.degrad,0.degrad,90.degrad,180.degrad,90.neg.degrad,0.degrad];
~el=[90.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,90.degrad];
)

//////icosahedron
(
~az=[90.degrad,90.neg.degrad,0.degrad,180.degrad,58.28.degrad,121.72.degrad,121.72.neg.degrad,58.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad];
~el=[58.28.neg.degrad,58.28.neg.degrad,31.72.neg.degrad,31.72.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,58.28.degrad,58.28.degrad,31.72.degrad,31.72.degrad];
)

/////dodecahedron

(
~az=[45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,90.neg.degrad,0.degrad,180.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,90.degrad,
	90.neg.degrad,69.09.degrad,110.91.degrad,110.91.neg.degrad,69.09.neg.degrad,0.degrad,180.degrad];

~el=[35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,35.26.neg.degrad,69.09.neg.degrad,69.09.neg.degrad,20.91.neg.degrad,20.91.neg.degrad,
	35.26.degrad,35.26.degrad,35.26.degrad,35.26.degrad,69.09.degrad,69.09.degrad,0.degrad,0.degrad,0.degrad,0.degrad,20.91.degrad,20.91.degrad]
)

/////Rhombic dodecahedron//// hull

(
~az=[0.degrad,45.degrad,135.neg.degrad,135.degrad,45.neg.degrad,0.degrad,180.degrad,90.degrad,90.neg.degrad,0.degrad,
	45.degrad,135.neg.degrad,135.degrad,45.neg.degrad];
~el=[90.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,35.264390.neg.degrad,0.degrad
	,0.degrad,0.degrad,0.degrad,90.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad,35.264390.degrad];
)

/////cuboctahedron//// core

(
~az=[0.degrad,90.degrad,180.degrad,90.neg.degrad,45.degrad,135.degrad,45.neg.degrad,135.neg.degrad,
	0.degrad,90.degrad,180.degrad,90.neg.degrad];
~el=[45.neg.degrad,45.neg.degrad,45.neg.degrad,45.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
	45.degrad,45.degrad,45.degrad,45.degrad];
)


///////////////Rhombic Triacontahedron//// hull
(
~az=[0.degrad,0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,
	0.degrad,72.degrad,144.degrad,144.neg.degrad,72.neg.degrad,36.degrad,108.degrad,180.degrad,108.neg.degrad,36.neg.degrad,0.degrad];

~el=[90.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,52.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,26.6.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,10.8.neg.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,52.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,26.6.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,10.8.degrad,90.degrad];

)

///////icosidodecahedron//// core
(
~az=[18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad,54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,
	0.degrad,36.degrad,72.degrad,108.degrad,144.degrad,180.degrad,144.neg.degrad,108.neg.degrad,72.neg.degrad,36.neg.degrad,
	54.degrad,126.degrad,162.neg.degrad,90.neg.degrad,18.neg.degrad,18.degrad,90.degrad,162.degrad,126.neg.degrad,54.neg.degrad];

~el=[58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,58.283.neg.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,0.degrad,
37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad,37.717.neg.degrad];

)*/

