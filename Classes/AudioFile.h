/*
 *  AudioFile.h
 *  DF666
 *
 *  Created by Einar Andersson on 12/23/09.
 *  Copyright 2009 Roventskij. All rights reserved.
 *
 */

#include <MacTypes.h>

class WavInFile;

class AudioFile {
public:
	
	UInt32 fileLength;
	short *buffer;
	
	AudioFile(WavInFile *inFile);
	
};