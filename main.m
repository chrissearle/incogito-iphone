//
//  main.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

#ifdef LOG_FUNCTION_TIMES
	NSLog(@"%@ Calling UIApplicationMain", [[[NSDate alloc] init] autorelease]);
#endif
	
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
