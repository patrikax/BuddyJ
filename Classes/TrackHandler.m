//
//  FileHandler.m
//  BuddyJ
//
//  Created by Leo Giertz on 100130.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TrackHandler.h"

@implementation TrackHandler

+(NSArray*)tracks {
    NSMutableArray* tracks = [NSMutableArray arrayWithCapacity:5];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [[paths objectAtIndex:0] stringByAppendingString:@"/"];
    
    NSLog(@"Searching: %@", documentsDirectory);
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager directoryContentsAtPath:documentsDirectory];

    AudioFileID fileID = nil;
    OSStatus err = noErr;

    for (NSString *file in fileList) {
		
		NSString *filePath = [documentsDirectory stringByAppendingString:file];
		NSLog(@"%@", filePath);
		NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
		
		err = AudioFileOpenURL((CFURLRef) fileUrl, kAudioFileReadPermission, 0, &fileID);
		if(err != noErr){
			NSLog(@"AudioFileOpenURL failed: %d", fileUrl);
		}
		
		CFDictionaryRef trackDict = nil;
		UInt32 piDataSize = sizeof(trackDict);
		
		err = AudioFileGetProperty(fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &trackDict);
		if(err != noErr){
			NSLog(@"AudioFileGetProperty failed for property info dictionary");
		}
		
		NSString * artistString = (NSString *)CFDictionaryGetValue( trackDict, CFSTR( kAFInfoDictionary_Artist ));
		NSString * songString = (NSString *)CFDictionaryGetValue( trackDict, CFSTR( kAFInfoDictionary_Title));
		
		[tracks addObject:[NSDictionary dictionaryWithObjectsAndKeys: artistString, @"artist", songString, @"song", filePath, @"path", nil]];
		
		CFRelease(trackDict);
    }
    return tracks;
}
@end
