//
//  CachedPropertyDownloader.h
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CachedPropertyFile : NSObject

+ (void)retrieveFile:(NSString *) filename fromUrl:(NSURL *)url;
+ (NSData *)readFile:(NSString *)filename;

@end
