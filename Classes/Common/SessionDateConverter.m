//
//  SessionDateConverter.m
//
//  Created by Chris Searle on 23.08.11.
//

#import "SessionDateConverter.h"

@implementation SessionDateConverter

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZ"];      
    
	NSDate *date = [inputFormatter dateFromString:dateString];
	
    [inputFormatter release];
    
    return date;
}

@end
