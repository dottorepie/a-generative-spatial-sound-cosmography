~r = Buffer.readChannel(s,"/Users/amimid/Music/SuperCollider Recordings/SC_260511_104839.aiff",channels:0 );


(
~fftsize=8192;
~hop=0.25;
~win=0;
);

~f=Buffer.alloc(s,~r.duration.calcPVRecSize(~fftsize,~hop))

(
{
	var sig,chain,localbuf;
	sig= PlayBuf.ar(1, ~r.bufnum, BufRateScale.kr(~r.bufnum), loop: 0, doneAction:2);
	localbuf=LocalBuf.new(~fftsize);
	chain=FFT(localbuf,sig,~hop,~win);
	chain=PV_RecordBuf(chain,~f,run:1,hop:~hop,wintype:~win);
	0;
	}.play;
)

(
~rev={
	var sig,chain,localbuf;
	localbuf=LocalBuf.new(~fftsize);
	chain=PV_PlayBuf(localbuf,~f,\rate.kr(1),loop:1);
	sig=IFFT(chain,~win);
}.play;
)

~rev.set(\rate,0);
~rev.set(\rate,1);

///////////////////////


(
~fftsize = 2048;
~hop = 0.25;
~win = 0;

~freezeSynth = {
    var in, chain, buf, freeze, trigFreq;

    // realtime signal
	in = PlayBuf.ar(1, ~r.bufnum, BufRateScale.kr(~r.bufnum), loop: 1, doneAction:0);

    // local FFT buffer
    buf = LocalBuf(~fftsize);

    // analysis
    chain = FFT(buf, in, ~hop, ~win);

    // frequency of switching
    trigFreq = \switchFreq.kr(2);

    /*
    toggle 0/1 continuously

    0 = normal live spectral update
    1 = freeze current spectrum
    */

    freeze = LFPulse.kr(trigFreq, 0, 0.5);

    // freeze/unfreeze spectrum
    chain = PV_Freeze(chain, freeze);

    // back to audio
    IFFT(chain, ~win);


}.play;
)
~freezeSynth.set(\switchFreq, 0.01);


