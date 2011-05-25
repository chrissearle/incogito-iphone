//
//  VideoMapper.h
//  incogito
//
//  Created by Chris Searle on 14.04.11.
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VideoMapper : NSObject {
    
}

+ (NSString *)streamingUrlForSession:(NSString *) sessionId;

@end
