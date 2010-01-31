/*
 *  audioObject.h
 *  audios
 *
 *  Created by Einar Andersson on 5/3/08.
 *  Copyright 2008 Dist Kommunikation. All rights reserved.
 *
 */

#include <AudioToolbox/AudioToolbox.h>
#include "CAStreamBasicDescription.h"

struct bufferCache {
	float *data;
	UInt32 length;
	UInt32 scale;
};

class audioData {
public:
	UInt32 channelCount;
	UInt32 frameLength;
	UInt32 bufferLength;
	float *bufferData;
	bufferCache myCache;
	
	audioData(NSString* file);
	~audioData();
	void constructCache();
};