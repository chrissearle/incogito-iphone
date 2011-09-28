//
//  CachedImage.h
//  incogito
//
//  Created by Chris Searle on 28.09.11.
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CachedImage : NSObject

+ (UIImage *)levelImageForLevel:(NSString *) level;
+ (UIImage *)labelImageForLabel:(NSString *) label;

@end
