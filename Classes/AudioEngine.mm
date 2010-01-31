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

#include "AudioFile.h"
#include "WavFile.h"

#include "audioData.h"

#define TEST 0

using namespace std;

double pos=0;
UInt32 lastPos = 100;

float interpolate(float value1, float value2, double pos) {
	float frac = pos-floor(pos);
	return frac*(value2-value1)+value1;
}

OSStatus render(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames,  AudioBufferList *ioData) {
	
	AudioEngine *audioEngine = (AudioEngine*)inRefCon;
	
	AudioUnitSampleType *output = (AudioUnitSampleType *)ioData->mBuffers[0].mData;
	
	memset(audioEngine->outBuffer, 0, inNumberFrames*sizeof(SInt32)*2);
	
	if(NULL == audioEngine->audioFile) {
		NSLog(@"vaaa");
		return NULL;
	}
	float step = audioEngine->step;

	if (TEST) {
	
	audioData *audio = audioEngine->audio;
	NSLog(@"bufferlength %f", audio->bufferLength);
	for (UInt32 i = 0; i < inNumberFrames*2; i++) {
		if(pos >= 0 && pos < audio->bufferLength) {
			
			int prevIndex = ((int)pos/2)*2;
			int nextIndex = prevIndex + 2;
			
			// INTERPOLATE TO SMOOTH PITCH
			output[i] = interpolate(audio->bufferData[prevIndex], audio->bufferData[nextIndex], pos);
			output[i+1] = interpolate(audio->bufferData[prevIndex+1], audio->bufferData[nextIndex+1], pos);
			
			// INCREASE VOLUME
			output[i] = output[i] << 8;
			output[i+1] = output[i+1] << 8;

			if(audioEngine->dragging) {
				
				// NOT PLAYING, SHOULD SCRATCH
				if(!audioEngine->isPlaying) {
					if(pos > -.0003 && pos < .0003) {
						step = 0;
					} else {
						if(step < 0) step += audioEngine->diff*.0001;
						if(step > 0) step -= audioEngine->diff*.0001;
					}
				} 
				// PLAYING AND WE SHOULD PITCH
				else if(audioEngine->pitching) {
					audioEngine->pitch += audioEngine->diff*0.0001;
				}
			}
			pos += audioEngine->step * audioEngine->pitch;
			
		} else if(pos < 0) {
			pos = 0;
		} else if(pos >= audio->bufferLength) {
			pos = 0;
			//pos = 0;
		}
	}
	 } else {
	AudioFile *file = audioEngine->audioFile;
	for (UInt32 i = 0; i < inNumberFrames*2; i++) {
		if(pos >= 0 && pos < file->fileLength) {
			
			int prevIndex = ((int)pos/2)*2;
			int nextIndex = prevIndex + 2;
			
			// INTERPOLATE TO SMOOTH PITCH
			output[i] = interpolate(file->buffer[prevIndex], file->buffer[nextIndex], pos);
			output[i+1] = interpolate(file->buffer[prevIndex+1], file->buffer[nextIndex+1], pos);
			
			// INCREASE VOLUME
			output[i] = output[i] << 8;
			output[i+1] = output[i+1] << 8;
			
			if(audioEngine->dragging) {
				
				// NOT PLAYING, SHOULD SCRATCH
				if(!audioEngine->isPlaying) {
					if(pos > -.0003 && pos < .0003) {
						step = 0;
					} else {
						if(step < 0) step += audioEngine->diff*.0003;
						if(step > 0) step -= audioEngine->diff*.0003;
					}
				} 
				// PLAYING AND WE SHOULD PITCH
				else if(audioEngine->pitching) {
					audioEngine->pitch += audioEngine->diff;
				}
			}
			pos += audioEngine->step * audioEngine->pitch;
			
		} else if(pos < 0) {
			pos = 0;
		} else if(pos >= file->fileLength) {
			pos = 0;
			//pos = 0;
			NSLog(@"stop");
		}
	}
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

void AudioEngine::startAudioEngine() {
	isPlaying = true;
	step = 1;
}
void AudioEngine::stopAudioEngine() {
	isPlaying = false;
	step = 0;
}
void AudioEngine::rewind() {
	pos = 0;
}
void AudioEngine::setCue() {
	cue = pos;
}
void AudioEngine::go2cue() {
	pos = cue;
}
void AudioEngine::loadTrack(NSString *file) {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	this->audioFile = new AudioFile(new WavInFile([[documentsDirectory stringByAppendingPathComponent:file] UTF8String]));
}
void AudioEngine::startFromDrag() {
	step = defaultStep;
}
AudioEngine::AudioEngine() {
	
	tpm = 0;
	
	shuffle = 0;
	
	isPlaying = false;
	
	dragging = false;
	
	pitching = false;
		
	cPosition = 0;
	
	cDivPos = 0;
	
	cue = 0;
	
	//audioFile = NULL;
	this->loadTrack(@"Adrenalinn.wav");
	
	// DEFAULT FRAMERATE
	defaultStep = 1;
	step = 0;
	
	// DEFAULT PITCH
	pitch = 1.0;
	previousPitch = pitch;
	
	//this->audio = new audioData(p);
	
	outBuffer = new SInt32[2048];
	
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