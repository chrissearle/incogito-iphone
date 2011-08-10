//
//  FeedbackAvailability.h
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FeedbackAvailability : NSObject {
	NSURL *url;
    NSDictionary *dict;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSDictionary *dict;

- (FeedbackAvailability *) initWithUrl:(NSURL *)downloadUrl;

- (BOOL)isFeedbackAvailableForSession:(NSString *)sessionId;
- (NSURL *)feedbackUrlForSession:(NSString *)sessionId;

@end
