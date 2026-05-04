
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


(
s.waitForBoot{

s.freqscope;
s.scope;
//s.makeWindow;
s.meter;
~tempo=1;
TempoClock.default.tempo_(~tempo);

Tdef(\drone, {

Buffer.freeAll;
///feed buffers, xyz from b-format or mono
(
~c1 = Buffer.readChannel(s,"/Users/amimid/Desktop/marine.wav",channels:0 );
~c2 = Buffer.readChannel(s,"/Users/amimid/Desktop/marine.wav",channels:0 );
~c3 = Buffer.readChannel(s,"/Users/amimid/Desktop/marine.wav",channels:0 );
);

/////tetrahedron
		(
~az=[45.degrad,135.neg.degrad,45.neg.degrad,135.degrad];
~el=[35.264390.neg.degrad,35.264390.neg.degrad,35.264390.degrad,35.264390.degrad];
);

////// wavetable
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

~orange=3;
~comp=0;

/////sound engine
(
SynthDef.new(\synth,{

arg gain=1,drive=0,c=0,az=0,el=0,scale=0,lowend=64,level=100,speaker_size=0.15,room=0.5,mix=0.5,pan_mod=0.01,spread=1,limit=0.8,fu=32,
				dyn=1,band=0.000001,comp=10.pow(35),buffer=1;

var expansion,heavy,fundamental,sph_mod,polytope,bessel_ripple,magx,magy,magz,sph;
var ton1,ton2,ton3,tonal_x,tonal_y,tonal_z,mod_x,mod_y,mod_z,phase_mod_x,phase_mod_y,phase_mod_z;
var mod_anglex,mod_angley,mod_anglez,mx,my,mz,sph_x,sph_y,sph_z,sph_mag,phasex,phasey,phasez;
var freq1,freq2,freq3,amp1,amp2,amp3,feed,control1,control2,control3,sig1,sig2,sig3;
var oct1,oct2,oct3,oct4,oct5,oct6,oct7,oct8,oct9,g=((1+5.sqrt)/2),s=(1+2.sqrt),pan;
var step,ph,ph1,ph2,ph3,ph4,ph5,ph6,ph7,ph8,ph9,orange=~orange;
var threshold1,threshold2,threshold3,g_ch1,g_ch2,g_ch3,g_ch4,pan1,pan2,pan3,pan4;
var waveSpeed,waveFreq,dyn1,dyn2,dyn3,dyn4,dyn5,dyn6,dyn7,dyn8,dyn9,timbre;


ph = (2pi-(2pi/s));
expansion=2.pow(c.lag(0.001)/16256).round(0.00001);
dyn1=dyn*2;
dyn2=dyn*3;
dyn3=dyn*4;
dyn4=dyn*5;
dyn5=dyn*6;
dyn6=dyn*7;
dyn7=dyn*8;
dyn8=dyn*9;
dyn9=dyn*10;
step=c.lag(0.001).linlin(0,(16256*orange),(16256*orange),0).round(1);
heavy=2.pow(drive.lag(0.001)/16256).round(0.00001);
level=level*heavy;
pan=2.pow(pan_mod.lag(0.001)/16256).round(0.00001);
fundamental=(fu*(9/8))*expansion;
mx=2;
my=2;
mz=2;
sph_mod=1;
timbre=c.lag(0.001).linlin(0,(16256*orange),(16256*orange),1).round(1);
polytope=Spherical(timbre,az.lag(0.001),el.lag(0.001));
waveSpeed=1;
waveFreq=2;
bessel_ripple=(0.5)*sin((waveFreq*polytope.theta)+(waveFreq * polytope.phi)-waveSpeed);

ton1=2.pow(Select.kr(polytope.x.round(1).linlin(0,timbre,0,10).round(1), Select.kr(scale.lag(0.001),~sc)) /12).round(0.00001);
ton2=2.pow(Select.kr(polytope.y.round(1).linlin(0,timbre,0,10).round(1), Select.kr(scale.lag(0.001),~sc)) /12).round(0.00001);
ton3=2.pow(Select.kr(polytope.z.round(1).linlin(0,timbre,0,10).round(1), Select.kr(scale.lag(0.001),~sc)) /12).round(0.00001);

tonal_x=2.pow(polytope.x.round(1) /16256).round(0.00001);
tonal_y=2.pow(polytope.y.round(1) /16256).round(0.00001);
tonal_z=2.pow(polytope.z.round(1) /16256).round(0.00001);



mod_x=polytope.x.round(0.00001);
mod_y=polytope.y.round(0.00001);
mod_z=polytope.z.round(0.00001);
phase_mod_x=(Complex(1,mod_x).theta*4);
phase_mod_y=(Complex(1,mod_y).theta*4);
phase_mod_z=(Complex(1,mod_z).theta*2);

mod_anglex=(LPF.ar((Osc.ar(~wt.bufnum,sph_mod,phase:phase_mod_x,mul:level).abs*
SinOsc.ar(sph_mod,phase:phase_mod_x)),
sph_mod*heavy,1)).range(pi.neg,pi);
mod_angley=(LPF.ar((Osc.ar(~wt.bufnum,sph_mod,phase:phase_mod_y,mul:level).abs*
SinOsc.ar(sph_mod,phase:phase_mod_y)),
sph_mod*heavy,1)).range(pi.neg,pi);
mod_anglez=(LPF.ar((Osc.ar(~wt.bufnum,sph_mod,phase:phase_mod_z,mul:level).abs*
SinOsc.ar(sph_mod,phase:phase_mod_z)),
sph_mod*heavy,1)).range(35.264390.degrad,35.264390.degrad.neg);

magx=((Complex(cos(((polytope.theta+mod_anglex).round(0.00001)*mx).wrap(pi.neg,pi)),
cos((((polytope.theta+mod_anglex).round(0.00001)*mx)).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magy=((Complex(sin(((polytope.theta+mod_angley).round(0.00001)*my).wrap(pi.neg,pi)),
sin(((polytope.theta+mod_angley).round(0.00001)*my).wrap(pi.neg,pi))).rho/(2.sqrt))*
(Complex(cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2))),cos((polytope.phi.round(0.00001)).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

magz=((Complex(cos(((polytope.phi+mod_anglez).round(0.00001)*mz).wrap((pi/2).neg,(pi/2))),
cos(((polytope.phi).round(0.00001)*mz).wrap((pi/2).neg,(pi/2)))).rho/(2.sqrt)));

sph_x=(Cartesian(magx,0,0).rho);
sph_y=(Cartesian(0,magy,0).rho);
sph_z=(Cartesian(0,0,magz).rho);
sph_mag=(Cartesian(sph_x,sph_y,sph_z));
sph=Spherical(sph_mag.rho,polytope.theta,polytope.phi);

phasex=Complex(1,sph.x).theta*4;
phasey=Complex(1,sph.y).theta*4;
phasez=Complex(1,sph.z).theta*2;

freq1=(fundamental)*ton1*tonal_x;
freq2=(fundamental)*ton2*tonal_y;
freq3=(fundamental)*ton3*tonal_z;

amp1=expansion.reciprocal*ton1.reciprocal*tonal_x.reciprocal;
amp2=expansion.reciprocal*ton2.reciprocal*tonal_y.reciprocal;
amp3=expansion.reciprocal*ton3.reciprocal*tonal_z.reciprocal;

////calculate range of spectrum 2.pow((16256*1)/16256).pow(8)

oct9=dyn*2.pow(step/16256).round(0.00001);
oct8=dyn1*2.pow(step/16256).round(0.00001);
oct7=dyn2*2.pow(step/16256).round(0.00001);
oct6=dyn3*2.pow(step/16256).round(0.00001);
oct5=dyn4*2.pow(step/16256).round(0.00001);
oct4=dyn5*2.pow(step/16256).round(0.00001);
oct3=dyn6*2.pow(step/16256).round(0.00001);
oct2=dyn7*2.pow(step/16256).round(0.00001);
oct1=dyn8*2.pow(step/16256).round(0.00001);
ph1=(ph+ph).wrap(pi.neg,pi).round(0.00001);
ph2=(ph1+ph).wrap(pi.neg,pi).round(0.00001);
ph3=(ph2+ph).wrap(pi.neg,pi).round(0.00001);
ph4=(ph3+ph).wrap(pi.neg,pi).round(0.00001);
ph5=(ph4+ph).wrap(pi.neg,pi).round(0.00001);
ph6=(ph5+ph).wrap(pi.neg,pi).round(0.00001);
ph7=(ph6+ph).wrap(pi.neg,pi).round(0.00001);
ph8=(ph7+ph).wrap(pi.neg,pi).round(0.00001);
ph9=(ph8+ph).wrap(pi.neg,pi).round(0.00001);

//feed=(SoundIn.ar(0,heavy));    ///input
//feed=(WhiteNoise.ar(heavy));    ///noise
				feed=(PlayBuf.ar(1, ~c1.bufnum, BufRateScale.kr(~c1.bufnum), loop: 1, doneAction:0)*buffer);   ////buffer


///mult chain// beware of 32-bit underflow and value 0 smash
sig1=(
((((((((((((((((((
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct2,phase:phasex+ph8,mul:level).abs*SinOsc.ar(freq1*oct2,phase:phasex+ph8)),freq1*heavy,amp1*oct2.reciprocal)).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct3,phase:phasex+ph7,mul:level).abs*SinOsc.ar(freq1*oct3,phase:phasex+ph7)),freq1*heavy,amp1*oct3.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct4,phase:phasex+ph6,mul:level).abs*SinOsc.ar(freq1*oct4,phase:phasex+ph6)),freq1*heavy,amp1*oct4.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct5,phase:phasex+ph5,mul:level).abs*SinOsc.ar(freq1*oct5,phase:phasex+ph5)),freq1*heavy,amp1*oct5.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct6,phase:phasex+ph4,mul:level).abs*SinOsc.ar(freq1*oct6,phase:phasex+ph4)),freq1*heavy,amp1*oct6.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct7,phase:phasex+ph3,mul:level).abs*SinOsc.ar(freq1*oct7,phase:phasex+ph3)),freq1*heavy,amp1*oct7.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct8,phase:phasex+ph2,mul:level).abs*SinOsc.ar(freq1*oct8,phase:phasex+ph2)),freq1*heavy,amp1*oct8.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq1*oct9,phase:phasex+ph1,mul:level).abs*SinOsc.ar(freq1*oct9,phase:phasex+ph1)),freq1*heavy,amp1*oct9.reciprocal)))+~comp).abs)*
(LPF.ar((Osc.ar(~wt.bufnum,freq1,phase:phasex+ph,mul:level).abs*SinOsc.ar(freq1,phase:phasex+ph)),freq1*heavy,amp1))+~comp)*comp)+
(BPF.ar(feed,freq1,band,band.sqrt.reciprocal*amp1)))
);
sig2=(
((((((((((((((((((
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct2,phase:phasey+ph8,mul:level).abs*SinOsc.ar(freq2*oct2,phase:phasey+ph8)),freq2*heavy,amp2*oct2.reciprocal)).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct3,phase:phasey+ph7,mul:level).abs*SinOsc.ar(freq2*oct3,phase:phasey+ph7)),freq2*heavy,amp2*oct3.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct4,phase:phasey+ph6,mul:level).abs*SinOsc.ar(freq2*oct4,phase:phasey+ph6)),freq2*heavy,amp2*oct4.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct5,phase:phasey+ph5,mul:level).abs*SinOsc.ar(freq2*oct5,phase:phasey+ph5)),freq2*heavy,amp2*oct5.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct6,phase:phasey+ph4,mul:level).abs*SinOsc.ar(freq2*oct6,phase:phasey+ph4)),freq2*heavy,amp2*oct6.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct7,phase:phasey+ph3,mul:level).abs*SinOsc.ar(freq2*oct7,phase:phasey+ph3)),freq2*heavy,amp2*oct7.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct8,phase:phasey+ph2,mul:level).abs*SinOsc.ar(freq2*oct8,phase:phasey+ph2)),freq2*heavy,amp2*oct8.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq2*oct9,phase:phasey+ph1,mul:level).abs*SinOsc.ar(freq2*oct9,phase:phasey+ph1)),freq2*heavy,amp2*oct9.reciprocal)))+~comp).abs)*
(LPF.ar((Osc.ar(~wt.bufnum,freq2,phase:phasey+ph,mul:level).abs*SinOsc.ar(freq2,phase:phasey+ph)),freq2*heavy,amp2))+~comp)*comp)+
(BPF.ar(feed,freq2,band,band.sqrt.reciprocal*amp2)))
);
sig3=(
((((((((((((((((((
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct2,phase:phasez+ph8,mul:level).abs*SinOsc.ar(freq3*oct2,phase:phasez+ph8)),freq3*heavy,amp3*oct2.reciprocal)).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct3,phase:phasez+ph7,mul:level).abs*SinOsc.ar(freq3*oct3,phase:phasez+ph7)),freq3*heavy,amp3*oct3.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct4,phase:phasez+ph6,mul:level).abs*SinOsc.ar(freq3*oct4,phase:phasez+ph6)),freq3*heavy,amp3*oct4.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct5,phase:phasez+ph5,mul:level).abs*SinOsc.ar(freq3*oct5,phase:phasez+ph5)),freq3*heavy,amp3*oct5.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct6,phase:phasez+ph4,mul:level).abs*SinOsc.ar(freq3*oct6,phase:phasez+ph4)),freq3*heavy,amp3*oct6.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct7,phase:phasez+ph3,mul:level).abs*SinOsc.ar(freq3*oct7,phase:phasez+ph3)),freq3*heavy,amp3*oct7.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct8,phase:phasez+ph2,mul:level).abs*SinOsc.ar(freq3*oct8,phase:phasez+ph2)),freq3*heavy,amp3*oct8.reciprocal)))+~comp).abs*
(LPF.ar((Osc.ar(~wt.bufnum,freq3*oct9,phase:phasez+ph1,mul:level).abs*SinOsc.ar(freq3*oct9,phase:phasez+ph1)),freq3*heavy,amp3*oct9.reciprocal)))+~comp).abs)*
(LPF.ar((Osc.ar(~wt.bufnum,freq3,phase:phasez+ph,mul:level).abs*SinOsc.ar(freq3,phase:phasez+ph)),freq3*heavy,amp3))+~comp)*comp)+
(BPF.ar(feed,freq3,band,band.sqrt.reciprocal*amp3)))
);

sig1=(sig1*heavy).softclip;
sig2=(sig2*heavy).softclip;
sig3=(sig3*heavy).softclip;

control1=SinOsc.ar(freq1,phase:phasex+ph,mul:amp1)*feed;
control2=SinOsc.ar(freq2,phase:phasey+ph,mul:amp2)*feed;
control3=SinOsc.ar(freq3,phase:phasez+ph,mul:amp3)*feed;
threshold1=(((343/speaker_size)/fundamental).reciprocal.ampdb/2.sqrt).dbamp;
threshold2=(((343/speaker_size)/fundamental).reciprocal.ampdb/2.sqrt).dbamp;
threshold3=(((343/speaker_size)/fundamental).reciprocal.ampdb/2.sqrt).dbamp;

sig1=HPF.ar(sig1,lowend);
sig2=HPF.ar(sig2, lowend);
sig3=HPF.ar(sig3, lowend);

sig1=Compander.ar(sig1,control1,threshold1,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
sig2=Compander.ar(sig2,control2,threshold2,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);
sig3=Compander.ar(sig3,control3,threshold3,1.2,1/3,0.03,0.15)+BrownNoise.ar(0.00001);

gain=gain*dyn;

g_ch1 = (
(Spherical(sph_x,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).x *
Spherical(sph_x,~az[0],~el[0]).x) +
(Spherical(sph_y,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).y *
Spherical(sph_y,~az[0],~el[0]).y)+
(Spherical(sph_z,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).z *
Spherical(sph_z,~az[0],~el[0]).z)
);
g_ch2 = (
(Spherical(sph_x,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).x *
Spherical(sph_x,~az[1],~el[1]).x)+
(Spherical(sph_z,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).y *
Spherical(sph_y,~az[1],~el[1]).y)+
(Spherical(sph_z,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).z *
Spherical(sph_z,~az[1],~el[1]).z)
);
g_ch3 = (
(Spherical(sph_x,(polytope.theta).wrap(pi,pi.neg),(polytope.phi ).wrap(~el[2],~el[1])).x *
Spherical(sph_x,~az[2],~el[2]).x)+
(Spherical(sph_y,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).y *
Spherical(sph_y,~az[2],~el[2]).y)+
(Spherical(sph_z,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).z *
Spherical(sph_z,~az[2],~el[2]).z)
);
g_ch4 = (
(Spherical(sph_x,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).x *
Spherical(sph_x,~az[3],~el[3]).x) +
(Spherical(sph_y,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).y *
Spherical(sph_y,~az[3],~el[3]).y)+
(Spherical(sph_z,(polytope.theta).wrap(pi,pi.neg),(polytope.phi).wrap(~el[2],~el[1])).z *
Spherical(sph_z,~az[3],~el[3]).z)
);
g_ch1 = g_ch1.pow(spread);   g_ch2 = g_ch2.pow(spread);   g_ch3 = g_ch3.pow(spread);   g_ch4 = g_ch4.pow(spread);
pan1=SinOsc.ar(pan,0).range(spread.linlin(0.001,1,1,0.001),1);
pan2=SinOsc.ar(pan,0.25pi).range(spread.linlin(0.001,1,1,0.001),1);
pan3=SinOsc.ar(pan,0.5pi).range(spread.linlin(0.001,1,1,0.001),1);
pan4=SinOsc.ar(pan,0.75pi).range(spread.linlin(0.001,1,1,0.001),1);

(
Out.ar(0,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(1,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(2,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1*g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(0,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(1,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(2,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2*g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(0,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3*g_ch1*pan1,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(1,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3*g_ch2*pan2,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(2,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3*g_ch3*pan3,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
Out.ar(3,
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig3*g_ch4*pan4,mix.lag(0.001),room.lag(0.001),mul:gain)),limit,0.01));
);
////stereo
/*(
Out.ar(0,Pan2.ar(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig1,mix.lag(0.01),room.lag(0.01),mul:gain1*sph_x)),0.9,0.01),SinOsc.ar(bessel_ripple,0)));
Out.ar(0,Pan2.ar(
Limiter.ar(LeakDC.ar(
FreeVerb.ar(sig2,mix.lag(0.01),room.lag(0.01),mul:gain2*sph_y)),0.9,0.01),SinOsc.ar(bessel_ripple,90.degrad)));
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
}).add
);

2.wait;
~comp=2.pow(45.neg)
~level=10.pow(12);
(
~synth=Synth.new(\synth,[\gain,1,\drive,0,\c,0,\az,0.3pi,\el,0,\scale,0,\lowend,64,\level,100,\dyn,1,\comp,~level,\buffer=1,
\speaker_size,0.15,\room,0.5,\mix,0.3,\pan_mod,16*16256.neg,\spread,1,\limit,0.8,\fu,64,\band,0.01]).register);

		///midi control
(
MIDIClient.init;
MIDIIn.connectAll;
(
(
MIDIdef.cc(\midi_pot1,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0,1).round(0.00000001);
a.postln;
if(~synth.isPlaying,{~synth.set(\gain,a)});
},1);
);
(
MIDIdef.cc(\midi_pot2,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,(16256).neg,(16256*3)).round(1).asInteger;
a.postln;
if(~synth.isPlaying,{~synth.set(\drive,a)});
},2);
);
(
MIDIdef.cc(\midi_pot3,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0.00001,1).round(0.00000001);
a.postln;
if(~synth.isPlaying,{~synth.set(\band,a)});
},3);
);
(
MIDIdef.cc(\midi_pot4,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,pi.neg,pi).round(0.0001);
a.postln;
if(~synth.isPlaying,{~synth.set(\az,a)});
},4);
);
(
MIDIdef.cc(\midi_pot5,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0.5pi.neg,0.5pi).round(0.0001);
a.postln;
if(~synth.isPlaying,{~synth.set(\el,a)});
},5);
);
(
MIDIdef.cc(\midi_pot6,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0,1).round(1).asInteger;
a.postln;
if(~synth.isPlaying,{~synth.set(\scale,a)});
},6);
);
(
MIDIdef.cc(\midi_pot7,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,32,128).round(0.0001);
a.postln;
if(~synth.isPlaying,{~synth.set(\lowend,a)});
},7);
);
(
MIDIdef.cc(\midi_pot8,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0,16256*~orange).round(1).asInteger;
a.postln;
if(~synth.isPlaying,{~synth.set(\c,a)});
},8);
);
(
MIDIdef.cc(\midi_pot9,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,1,4).round(0.0001);
a.postln;
if(~synth.isPlaying,{~synth.set(\dyn,a)});
},9);
);
(
MIDIdef.cc(\midi_pot10,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0.05,0.3).round(0.0001);
a.postln;
if(~synth.isPlaying,{~synth.set(\speaker_size,a)});
},10);
);
(
MIDIdef.cc(\midi_pot11,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0,1).round(0.0001);
a.postln;
if(~synth.isPlaying,{~synth.set(\room,a)});
},11);
);
(
MIDIdef.cc(\midi_pot12,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,0,1).round(0.0001);
a.postln;
if(~synth.isPlaying,{~synth.set(\mix,a)});
},12);
);
(
MIDIdef.cc(\midi_pot13,{ |val, num, chan, src|
var a;
	a=val.linlin(0,127,(16256*6).neg,(16256*3)).round(1).asInteger;
a.postln;
if(~synth.isPlaying,{~synth.set(\pan_mod,a/~tempo)});
},13);
);
(
MIDIdef.cc(\midi_pot14,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,1,0.01).round(0.0001);
a.postln;
if(~synth.isPlaying,{~synth.set(\spread,a)});
},14);
);
(
MIDIdef.cc(\midi_pot15,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,1,0.001).round(0.000001);
a.postln;
if(~synth.isPlaying,{~synth.set(\limit,a)});
},15);
);
(
MIDIdef.cc(\midi_pot16,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,1,8).round(1).asInteger;
a=2.pow(a);
a.postln;
if(~synth.isPlaying,{~synth.set(\fu,a)});
},16);
);
(
MIDIdef.cc(\midi_pot16,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,10,20).round(0.000001);
a=10.pow(a);
a.postln;
if(~synth.isPlaying,{~synth.set(\comp,a)});
},16);
);
(
MIDIdef.cc(\midi_pot16,{ |val, num, chan, src|
var a;
a=val.linlin(0,127,1,10).round(0.000001);
a.postln;
if(~synth.isPlaying,{~synth.set(\buffer,a)});
},16);
);
));

	}); Tdef(\drone).play;
})
)


s.record(numChannels:4)



///sequencer///musical automaton
(
({
var m1=1.neg, m2=1.neg, m3=1.neg,a,b,c,n=0,bank=4,time=32.reciprocal,beat=1,r=0;
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
};
m1=1.neg; m2=1.neg; m3=1.neg; ~dx=~dx++~x; ~dy=~dy++~y;  ~dz=~dz++~z;   ~x=[]; ~y=[]; ~z=[];  r=r+90.degrad; };
bank.do{ ~dur1=~dur1++~dx.[n];n=n+1;};n=0;
//	~durx = ~dur1.collect { |x| if (x == 0) { Rest(2) } { x }};
bank.do{ ~dur2=~dur2++~dy.[n];n=n+1;};n=0;
//	~dury = ~dur2.collect { |x| if (x == 0) { Rest(2) } { x }};
bank.do{ ~dur3=~dur3++~dz.[n];n=n+1;};n=0;
//	~durz = ~dur3.collect { |x| if (x == 0) { Rest(2) } { x }};
~dur=~dur++~dur1++~dur2++~dur3;
)}.value);

~seq= Pseq(~dur ,inf).asStream;
~val=123;
~tempo=1;
TempoClock.default.tempo_(~tempo);

(
~sq= Routine({loop{
thisThread.randSeed = ~val;

~synth.set(\az, pi.rand2);
~synth.set(\el, 0.5.rand2);
  ~seq.next.wait;
}}));

)
~sq.play;

////////further spatial arrays
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

