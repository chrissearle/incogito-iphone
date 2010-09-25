//
//  SessionDownloader.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionDownloader : NSObject {
	NSURL *url;
}

@property (nonatomic, retain) NSURL *url;

- (SessionDownloader *) initWithUrl:(NSURL *)downloadUrl;

- (NSData *)sessionData;

@end
