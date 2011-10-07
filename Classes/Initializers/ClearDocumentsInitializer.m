//
//  ClearDocumentsInitializer.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "ClearDocumentsInitializer.h"


@implementation ClearDocumentsInitializer

-(void)clearPath:(NSString *)subpath {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *docPath = [docDir stringByAppendingPathComponent:subpath];
    AppLog(@"docPath %@", docPath);
    NSString *cachePath = [cacheDir stringByAppendingPathComponent:subpath];
    AppLog(@"cachePath %@", cachePath);
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSError *error = nil;
    
    if ([fileManager fileExistsAtPath:cachePath]) {
        AppLog(@"Saw %@ in cache", subpath);
        if ([fileManager fileExistsAtPath:docPath]) {
            AppLog(@"Saw %@ in doc (also in cache) so removing", subpath);
            [fileManager removeItemAtPath:docPath error:&error];
            if (nil != error) {
                AppLog(@"Unable to remove items at path %@ due to %@", docPath, error);
                [FlurryAnalytics logError:@"Error removing path" message:[NSString stringWithFormat:@"Unable to remove items at path %@", docPath] error:error];
                return;
            }
        }
    } else {
        if ([fileManager fileExistsAtPath:docPath]) {
            AppLog(@"Saw %@ in doc (not in cache) so moving", subpath);
            [fileManager moveItemAtPath:docPath toPath:cachePath error:&error];
            if (nil != error) {
                AppLog(@"Unable to move items at path %@ to path %@ due to %@", docPath, cachePath, error);
                [FlurryAnalytics logError:@"Error moving path" message:[NSString stringWithFormat:@"Unable to move items at path %@ to path %@", docPath, cachePath] error:error];
                return;
            }
        }
        
    }
}

- (void)clear {
    [self clearPath:@"levelIcons"];
    [self clearPath:@"labelIcons"];
    [self clearPath:@"bioIcons"];

    [self clearPath:@"feedback.xhtml"];
    [self clearPath:@"video.plist"];
}

@end
