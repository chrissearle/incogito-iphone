//
//  CachedImage.m
//  incogito
//
//  Created by Chris Searle on 28.09.11.
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "CachedImage.h"


@implementation CachedImage

+ (UIImage *)imageForKey:(NSString *)key inPath:(NSString *)path {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",[docDir stringByAppendingPathComponent:path],key];
	
	NSData *data1 = [NSData dataWithContentsOfFile:pngFilePath];
	
	UIImage *imageFile = [UIImage imageWithData:data1];
    
    return imageFile;
}

+ (UIImage *)levelImageForLevel:(NSString *) level {
    return [CachedImage imageForKey:level inPath:@"levelIcons"];
}

+ (UIImage *)labelImageForLabel:(NSString *) label {
    return [CachedImage imageForKey:label inPath:@"labelIcons"];
}

@end
