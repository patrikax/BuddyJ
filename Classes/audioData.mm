/*
 *  audioObject.cpp
 *  audios
 *
 *  Created by Einar Andersson on 5/3/08.
 *  Copyright 2008 Dist Kommunikation. All rights reserved.
 *
 */

#include "audioData.h"


audioData::audioData(NSString* file) {
	
	NSLog(file);
	
	NSURL *url = [NSURL URLWithString:[file stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	CFURLRef fileRef = (CFURLRef)url;
	
	Float64 kGraphSampleRate = 44100.0;
	OSStatus err;
	ExtAudioFileRef mAudioFile;
	err = ExtAudioFileOpenURL(fileRef,&mAudioFile);

		
	CAStreamBasicDescription clientFormat;
	UInt32 size = sizeof(clientFormat);
	err = ExtAudioFileGetProperty(mAudioFile, kExtAudioFileProperty_FileDataFormat, &size, &clientFormat);
	
	UInt32 numChannels = clientFormat.mChannelsPerFrame;
	//clientFormat.Print();
	
	clientFormat.mSampleRate = kGraphSampleRate;
	clientFormat.SetCanonical(numChannels, true);
	
	size = sizeof(clientFormat);
	err = ExtAudioFileSetProperty(mAudioFile, kExtAudioFileProperty_ClientDataFormat, size, &clientFormat);

	SInt32 totalAudioFrames;
	size = sizeof(totalAudioFrames);
	err = ExtAudioFileGetProperty(mAudioFile, kExtAudioFileProperty_FileLengthFrames, &size, &totalAudioFrames);

	double rateRatio = kGraphSampleRate / clientFormat.mSampleRate;
	UInt32 dataSize = totalAudioFrames*numChannels*rateRatio*sizeof(float);
	float *data = (float*)malloc(dataSize);
	
	UInt32 numPackets = (UInt32)totalAudioFrames;
	UInt32 samples = numPackets<<1; // 2 channels (samples) per frame
	
	AudioBufferList bufList;
	bufList.mNumberBuffers = 1;
	bufList.mBuffers[0].mNumberChannels = numChannels;
	bufList.mBuffers[0].mData = data;
	bufList.mBuffers[0].mDataByteSize = samples * sizeof(Float32);
	
	UInt32 loadedPackets = numPackets;
	err = ExtAudioFileRead(mAudioFile, &loadedPackets, &bufList);

	ExtAudioFileDispose(mAudioFile);
	
	ExtAudioFileRef newAudioFile;
	err = ExtAudioFileSetProperty(newAudioFile, kAudioFormatLinearPCM, totalAudioFrames, &clientFormat);
	
	channelCount = numChannels;
	frameLength = totalAudioFrames;
	bufferLength = totalAudioFrames*numChannels;
	bufferData = data;
	constructCache();
}

audioData::~audioData() {
	if(myCache.data) free(myCache.data);
	if(bufferData) free(bufferData);
}

void audioData::constructCache() {
	float scale = 1024;
	
	myCache.scale = scale;
	myCache.length = (frameLength/scale)*2;
	myCache.data = (float*)malloc(sizeof(float)*myCache.length);
	
	float dMax = -10;
	float dMin = 10;
	UInt32 k = 0;
	UInt32 c = 0;
	UInt32 d = 0;
	
	float value;
	for(UInt32 i=0;i<frameLength;i++) {
		value = (bufferData[k]+bufferData[k+1])*.5;
		dMax = MAX(dMax,value);
		dMin = MIN(dMin,value);
		c++;
		if (c==myCache.scale) {
			if (d<myCache.length) {
				myCache.data[d] = dMax;
				myCache.data[d+1] = dMin;
			} else {
				NSLog(@"%i",d);
			}
			dMax = -10; dMin = 10;
			d+=2;
			c=0;
		}
		k+=2;
	}
}