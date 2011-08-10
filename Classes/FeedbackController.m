//
//  FeedbackController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "FeedbackController.h"
#import "FlurryAPI.h"
#import "JZSession.h"
#import "JavaZonePrefs.h"
#import "RegexKitLite.h"

@implementation FeedbackController

@synthesize session;
@synthesize emailField;
@synthesize formField;
@synthesize feedbackURL;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[FlurryAPI logEvent:@"Showing Feedback" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
															[session title],
															@"Title",
															[session jzId],
															@"ID", 
															nil]];
}

- (void)insertStyle {
    NSMutableString *js = [[NSMutableString alloc] init];
    
    [js appendString:@"var headElement = document.getElementsByTagName('head')[0];"];
    [js appendString:@"var styleNode = document.createElement('style');"];
    [js appendString:@"styleNode.type = 'text/css';"];
    [js appendString:@"styleNode.innerText = 'label { display: block; } textarea {display: block; }';"];
    [js appendString:@"headElement.appendChild(styleNode);"];

    [formField stringByEvaluatingJavaScriptFromString:[NSString stringWithString:js]];
    
    [js release];
}

- (void)setEmail:(NSString *)email {
    NSMutableString *js = [[NSMutableString alloc] init];
    
    [js appendString: @"var emailField = document.getElementById('email');"];
    
    [js appendString:[NSString stringWithFormat:@"emailField.value = '%@';", email]];
    
    [formField stringByEvaluatingJavaScriptFromString:[NSString stringWithString:js]];

    [js release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Feedback";
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	const CGFloat myColor[] = {0.67, 0.67, 0.67, 1.0};
	CGColorRef colour = CGColorCreate(rgb, myColor);
	CGColorSpaceRelease(rgb);
	
	[[formField layer] setCornerRadius:8.0f];
	[[formField layer] setMasksToBounds:YES];
	[[formField layer] setBorderWidth:1.0];
	[[formField layer] setBorderColor:colour];
	
	CGColorRelease(colour);
    
    NSLog(@"Initializing registered e-mail %@", [JavaZonePrefs registeredEmail]);
    
    [emailField setText:[JavaZonePrefs registeredEmail]];
    
    [formField loadRequest:[NSURLRequest requestWithURL:feedbackURL]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self setEmail:[emailField text]];
    
    NSLog(@"Storing registered e-mail %@", [textField text]);
    
    [JavaZonePrefs setRegisteredEmail:[textField text]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finished Loading");
    
    // Can't find a way to check HTTP response code here. Seems to be only available if I send the form programatically rather than letting the webview do it.
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
       
    //NSLog(@"Saw %@", html);
    
    if ([html rangeOfString:@"form"].location != NSNotFound) {
        [self setEmail:[emailField text]];
        [self insertStyle];

        return;
    }
    
    
    NSString *errorRegex = @"<div ?[^>]* ?class=\"error\" ?[^>]* ?>(.*)</div>";
    
    NSString *match = [html stringByMatching:errorRegex];
    
    NSLog(@"Saw match %@", match);
    
    if ([match isEqual:@""] == NO) {
        NSString *message = [html stringByMatching:errorRegex capture:1L];
        
        NSLog(@"Message %@", message);

        [webView goBack];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle: @"Unable to send feedback"
								   message: message
								   delegate:nil
								   cancelButtonTitle:@"OK"
								   otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
