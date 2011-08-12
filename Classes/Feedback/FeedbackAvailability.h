//
//  FeedbackAvailability.h
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface FeedbackAvailability : NSObject {
	NSURL *url;
    NSDictionary *dict;
    
	MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSDictionary *dict;
@property (nonatomic, retain) MBProgressHUD *HUD;

- (FeedbackAvailability *) initWithUrl:(NSURL *)downloadUrl;

- (BOOL)isFeedbackAvailableForSession:(NSString *)sessionId;
- (NSURL *)feedbackUrlForSession:(NSString *)sessionId;
- (void)populateDict:(id)sender;

@end
