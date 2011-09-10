//
//  FeedbackAvailability.m
//
//  Copyright 2011 Chris Searle. All rights reserved.
//

#import "FeedbackAvailability.h"
#import "DDXML.h"
#import "CachedPropertyFile.h"

@implementation FeedbackAvailability

@synthesize url;
@synthesize dict;
@synthesize HUD;

- (void)downloadData {
    [CachedPropertyFile retrieveFile:@"feedback.xhtml" fromUrl:self.url];
}

- (void)populateDict {
    NSData *contents = [CachedPropertyFile readFile:@"feedback.xhtml"];
    
    NSMutableDictionary *mutableDictionary = [[[NSMutableDictionary alloc] init] autorelease];    

    if (contents != nil) {
        DDXMLDocument *xmlDoc;
        
        NSError *err=nil;
        
        
        xmlDoc = [[[DDXMLDocument alloc] initWithData:contents options:DDXMLDocumentXHTMLKind error:&err] autorelease];

        // libXml puts everything in the default namespace in a namespace without prefix. We can't register a fake namespace since KissXML doesn't support that - so we have to use local-name()
        NSArray *nodes = [xmlDoc nodesForXPath:@"//*[(local-name()='a') and (@id)]"
                                         error:&err];

        AppLog(@"Found %d feedback URLs", [nodes count]);
        
        for (DDXMLElement *element in nodes) {
            NSString *sessionId = [[element attributeForName:@"id"] stringValue];
            NSString *href = [[element attributeForName:@"href"] stringValue];
            
            AppLog(@"Saw %@ with %@", sessionId, href);
            
            [mutableDictionary setObject:href forKey:sessionId];
        }
    }

    self.dict = [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

- (FeedbackAvailability *) initWithUrl:(NSURL *)downloadUrl {
    self = [super init];
    
    if (self) {
        url = [downloadUrl copy];
    }
	
	return self;
}

- (BOOL)isFeedbackAvailableForSession:(NSString *)sessionId {
    AppLog(@"Checking for feedback availability for %@", sessionId);
    
    return [[self.dict allKeys] containsObject:sessionId];
}

- (NSURL *)feedbackUrlForSession:(NSString *)sessionId {
    if (![self isFeedbackAvailableForSession:sessionId]) {
        return nil;
    }
    
    return [NSURL URLWithString:[self.dict objectForKey:sessionId]];
}

- (void)dealloc {
    [url release];
    [dict release];
    [HUD release];
    
    [super dealloc];
}

@end
