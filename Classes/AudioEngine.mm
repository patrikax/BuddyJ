/*
 *  AudioEngine.cpp
 *  IR909
 *
 *  Created by Einar Andersson on 10/19/09.
 *  Copyright 2009 Roventskij. All rights reserved.
 *
 */

#include "AudioEngine.h"

#include <iostream>
#include <algorithm>

#include "Track.h"

#include "SoundSet.h"
#include "AudioFile.h"
#include "WavFile.h"
using namespace std;

double pos=0;
double fPos = 0;
UInt32 lastPos = 100;

float interpolate(float value1, float value2, double pos) {
	float frac = pos-floor(pos);
	return frac*(value2-value1)+value1;
}

OSStatus render(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames,  AudioBufferList *ioData) {
	
	AudioEngine *audioEngine = (AudioEngine*)inRefCon;
	
	AudioUnitSampleType *output = (AudioUnitSampleType *)ioData->mBuffers[0].mData;
	
	memset(audioEngine->outBuffer, 0, inNumberFrames*sizeof(SInt32)*2);
	
	
	AudioFile *file = audioEngine->audioFile;
	if(pos >= 0 && pos < file->fileLength) {
		
		double pitch = audioEngine->pitch;
		for (UInt32 i = 0; i < inNumberFrames*2; i++) {
			
			int prevIndex = ((int)pos/2)*2;
			int nextIndex = prevIndex + 2;
			
			
			// INTERPOLATE TO SMOOTH PITCH
			output[i] = interpolate(file->buffer[prevIndex], file->buffer[nextIndex], pos);
			output[i+1] = interpolate(file->buffer[prevIndex+1], file->buffer[nextIndex+1], pos);
			
			
			// INCREASE VOLUME
			output[i] = output[i] << 8;
			output[i+1] = output[i+1] << 8;
			
			if(audioEngine->dragging) {
				if(pos > -.0003 && pos < .0003) {
					pos = 0;
				} else {
					if(pos < 0) pos+= audioEngine->diff*.0000001;
					if(pos > 0) pos-= audioEngine->diff*.0000001;
				}
			}
			pos += pitch;
			
		}
	} else if(pos < 0) {
		pos = 0;
	} else if(pos > file->fileLength) {
		pos = file->fileLength-1000;
		NSLog(@"stop");
	}
	
	
	return noErr;
}
void AudioEngine::setDragging(Boolean flag) {
	dragging = flag;
}
void AudioEngine::setPitch(double pitch) {
	this->pitch = pitch;
}

void AudioEngine::setSong(AudioFile *file) {
	audioFile = file;
}
void AudioEngine::loadSet(UInt8 sid) {
	for(UInt8 i=0;i<=1;i++) {
		tracks[i]->setAudioFile(soundSets[sid]->files[i]);
	}
	currentSetIndex = sid;
	
	currentSoundSet = soundSets[sid];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"didLoadSet" object:NULL];
	
}

void AudioEngine::prevSet() {
	if(currentSetIndex == 0) loadSet(soundSets.size()-1);
	else loadSet(currentSetIndex-1);
}

void AudioEngine::nextSet() {
	if(currentSetIndex == soundSets.size()-1) loadSet(0);
	else loadSet(currentSetIndex+1);
}


void AudioEngine::setBPM(UInt32 mBpm) {
	bpm = mBpm;
	
	float framesPerBar = 44100.0 * 60.0 / bpm * 4.0;
	float framesPerBeat = framesPerBar / 4.0;
	realFramesPerDivision = framesPerBeat / 4.0;
	//framesPerDivision = realFramesPerDivision;
	
	if(cDivPos % 2) framesPerDivision = realFramesPerDivision + realFramesPerDivision*shuffle;
	else framesPerDivision = realFramesPerDivision - realFramesPerDivision*shuffle;
	
}
void AudioEngine::startAudioEngine() {
	isPlaying = true;
	AudioOutputUnitStart(outputUnit);
}
void AudioEngine::stopAudioEngine() {
	isPlaying = false;
	AudioOutputUnitStop(outputUnit);
}
AudioEngine::AudioEngine() {
	
	tpm = 0;
	
	shuffle = 0;
	
	isPlaying = false;
	
	setBPM(126);
	
	cPosition = 0;
	
	cDivPos = 0;
	
	// DEFAULT FRAMERATE
	frameSpeed = 2;
	
	// DEFAULT PITCH
	pitch = 1.0;
	previousPitch = pitch;
	/*
	 soundSets.push_back(new SoundSet([[NSString stringWithFormat:@"%@/audio/2",[[NSBundle mainBundle] resourcePath]] UTF8String],"2. Next To Owl Grave Coffin"));
	 soundSets.push_back(new SoundSet([[NSString stringWithFormat:@"%@/audio/3",[[NSBundle mainBundle] resourcePath]] UTF8String],"3. Coconut Office"));
	 soundSets.push_back(new SoundSet([[NSString stringWithFormat:@"%@/audio/4",[[NSBundle mainBundle] resourcePath]] UTF8String],"4. Centralia Detour"));
	 soundSets.push_back(new SoundSet([[NSString stringWithFormat:@"%@/audio/5",[[NSBundle mainBundle] resourcePath]] UTF8String],"5. Gorilla Cage"));
	 soundSets.push_back(new SoundSet([[NSString stringWithFormat:@"%@/audio/6",[[NSBundle mainBundle] resourcePath]] UTF8String],"6. Thinking Of Space"));
	 soundSets.push_back(new SoundSet([[NSString stringWithFormat:@"%@/audio/7",[[NSBundle mainBundle] resourcePath]] UTF8String],"7. Etzweiler"));
	 soundSets.push_back(new SoundSet([[NSString stringWithFormat:@"%@/audio/8",[[NSBundle mainBundle] resourcePath]] UTF8String],"8. Simcoe"));
	 soundSets.push_back(new SoundSet([[NSString stringWithFormat:@"%@/audio/9",[[NSBundle mainBundle] resourcePath]] UTF8String],"9. MD5VSSHA1"));
	 soundSets.push_back(new SoundSet([[NSString stringWithFormat:@"%@/audio/10",[[NSBundle mainBundle] resourcePath]] UTF8String],"10. Forcast Burndown"));
	 */
	
	//soundSets.push_back(new SoundSet([[NSString stringWithFormat:@"%@/",[[NSBundle mainBundle] resourcePath]] UTF8String],"SomeNerve"));
	
	for(UInt8 i=0;i<2;i++) tracks.push_back(new Track());
	
	
	const char *path = [[NSString stringWithFormat:@"%@/",[[NSBundle mainBundle] resourcePath]] UTF8String];
	char *fileName = new char[255];
	
	sprintf(fileName, "%s%s.wav", path, "keys");
	
	
	this->audioFile = new AudioFile(new WavInFile(fileName));
	NSLog(@"%d", audioFile->fileLength/1024);	
	/*
	 for (UInt8 i=0; i<8; i++) {
	 sprintf(fileName, "%s%s.wav", [[NSString stringWithFormat:@"%@/",[[NSBundle mainBundle] resourcePath]] UTF8String], @"SomeNerve");
	 audioFiles.push_back(new AudioFile(new WavInFile(fileName)));
	 }*/
	
	
	
	outBuffer = new SInt32[2048];
	
	
	//AudioUnit outputUnit;
	
	AudioComponentDescription desc;
	desc.componentType = kAudioUnitType_Output;
	desc.componentSubType = kAudioUnitSubType_RemoteIO;
	desc.componentManufacturer = kAudioUnitManufacturer_Apple;
	
	AudioComponent comp = AudioComponentFindNext(NULL, &desc);
	AudioComponentInstanceNew(comp, &outputUnit);
	
	CAStreamBasicDescription outFormat;
	outFormat.SetAUCanonical(2, true);
	outFormat.mSampleRate = kGraphSampleRate;
	AURenderCallbackStruct output;
	output.inputProc = render;
	output.inputProcRefCon = this;
	
	//CAStreamBasicDescription::Print(outFormat);
	
	AudioUnitSetProperty(outputUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &outFormat, sizeof(outFormat));
	AudioUnitSetProperty(outputUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &output, sizeof(output));
	AudioUnitInitialize(outputUnit);
	AudioOutputUnitStart(outputUnit);
}