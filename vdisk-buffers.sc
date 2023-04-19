(
o = Server.default.options;
o.numInputBusChannels = 0;
Server.default.boot;
)

x = { 0.2 * SinOsc.ar() }.play;


b = Buffer.cueSoundFile(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff", 0, 1);
c = SoundFile(Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff").info;
c.numFrames;

x = { VDiskIn.ar(1, b, MouseX.kr(0.5, 2), 1, loop:1) }.play;
x = { VDiskIn.ar(1, b, (c.sampleRate / s.sampleRate) * MouseX.kr(0.25, 2), 1, loop:1) }.play;


c.sampleRate;
s.sampleRate;

VDiskIn

