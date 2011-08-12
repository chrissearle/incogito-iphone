//
//  SessionParser.h
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SessionParser : NSObject {
	NSData *data;
}

@property (nonatomic, retain) NSData *data;

- (SessionParser *)initWithData:(NSData *)downloadData;

- (NSArray *)sessions;

@end
