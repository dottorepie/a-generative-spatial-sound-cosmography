


(
(
s.options.numWireBufs = 1024*2;
s.options.numOutputBusChannels=4;
s.options.numInputBusChannels=2;
s.options.memSize = 8192*4;
s.options.blockSize = 64;
s.options.maxNodes = 1024 * 2;
//s.makeGui(w);
//s.options.sampleRate= 44100;
//s.recHeaderFormat="aiff";
//s.recSampleFormat ="int16";
//s.recChannels = 8;
s.boot;
~frames=1024;
);


//
(
s.waitForBoot{
MIDIClient.init;
MIDIIn.connectAll;
s.freqscope;
s.scope;
//s.makeWindow;
s.meter;
	Tdef(\drone, {
	Buffer.freeAll;

		//vbap
			(
~a = VBAPSpeakerArray.new(3,
				[[45, 35.264390.neg],[135.neg, 35.264390.neg],[45.neg, 35.264390],[135,35.264390]]);
	 ~b = Buffer.loadCollection(s, ~a.getSetsAndMatrices);
);

(
~f = Buffer.readChannel(s,,channels:0 );
		);
/////////////osc polytope
	(
{
var  sph1,sph2,sph3,sph4,sph5,sph6,sph7,m_x=9,m_y=9,m_z=9,qx,qy,mq=m_x-1;
var az1=0,el1=0,az2=0,el2=0,az3=0,el3=0,mag,mag_x,mag_y,mag_z,mag_qx,mag_qy;
var az4=0,el4=0,az5=0,el5=0,az6=0,el6=0,az7=0,el7=0;
var azimuth,elevation,magnitudex,magnitudey,magnitudez,angle=0,n=12;
var sphx,sphy,sphz,azx,elx,azy,ely,azz,elz,plx=1,ply=1,plz=1;
var ellipsis=[1,1,1],spread=1,silver_r=(1+2.sqrt);
var mag1=1,mag2=1,mag3=1,mag4=1,mag5=1,mag6=1,mag7=1;
	~az=[];~el=[];~magx=[];~magy=[];~magz=[];~qx=[];~qy=[];

//	spread = if(m_z < 1) { 1 / m_z } { m_z };

	16.do{
azimuth=16.collect{
			az1 = (az1+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
		   el1 = (el1+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

//	mag1=(mag1+(1-(1/1.6180339887499))).wrap(0,1);
sph1=(Spherical(mag1,(az1+angle).wrap(pi.neg,pi),(el1+angle).wrap((pi/2).neg,(pi/2)))).theta.round(0.000000000001);

	};

elevation=16.collect{
				az2 = (az2+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
			el2 = (el2+(pi-(pi/silver_r))).wrap((pi/2).neg,(pi/2));

	//mag2=(mag2+(1-(1/1.6180339887499))).wrap(0,1);
		sph2=(Spherical(mag2,(az2+angle).wrap(pi.neg,pi),(el2+angle).wrap((pi/2).neg,(pi/2)))).phi.round(0.000000000001);

	};

angle=(angle+(2pi-(2pi/silver_r))).wrap(pi.neg,pi);
~az=~az++azimuth;~el=~el++elevation;
		az1=0;el1=0;az2=0;el2=0;
				};
}.value;
);
		(
			{
var steps = 256;

~nVals = steps.collect { |i|
    i.linexp(0, steps-1, 0.18, 256).round
};
			~nVals.asInteger;
			}.value;
		);

(
SynthDef.new(\re_q, {

	arg amp=1;
	var chain1,chain,sig,sph,in,frames=~frames,n=0;


   in = PlayBuf.ar(1, ~f.bufnum, BufRateScale.kr(~f.bufnum), loop: 0, doneAction:0);
	//in = SoundIn.ar(0);

	chain = FFT(LocalBuf(frames), in);

				256.do{

chain1 = chain.pvcollect(frames,
						{|mag, phase, index| [mag, (phase)]; }, frombin: ~nVals.[n], tobin: ~nVals.[n], zeroothers: 1);

				sph=Spherical(~az.[n],~el.[n]);


sig=IFFT(chain1);

Out.ar(0,VBAP.ar(4,sig,~b,sph.theta.raddeg,sph.phi.raddeg,72)*amp);
					n=n+1;
				}



}).add;
);


10.wait;
		~synth=Synth.new(\re_q,[\amp,0.33]).register;//s.record



)
});
	Tdef(\drone).play;
}
)
)
s.record(numchannels:2,duration:(4*60));