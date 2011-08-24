//
//  FeedbackController.m
//
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import "FeedbackController.h"
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
															[self.session title],
															@"Title",
															[self.session jzId],
															@"ID", 
															nil]];
}

- (void)insertStyle {
    NSMutableString *js = [[NSMutableString alloc] init];

    NSString *path = [NSString stringWithFormat:@"%@/style-feedback.css", [[NSBundle mainBundle] bundlePath]];
    NSString *styles = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    
    [js appendString:@"var headElement = document.getElementsByTagName('head')[0];"];
    [js appendString:@"var styleNode = document.createElement('style');"];
    [js appendString:@"styleNode.type = 'text/css';"];
    [js appendString:[NSString stringWithFormat:@"styleNode.innerText = '%@';", styles]];
    [js appendString:@"headElement.appendChild(styleNode);"];

    AppLog(@"Running %@", js);
    
    [self.formField stringByEvaluatingJavaScriptFromString:[NSString stringWithString:js]];
    
    [js release];
}

- (void)setEmail:(NSString *)email {
    NSMutableString *js = [[NSMutableString alloc] init];
    
    [js appendString: @"var emailField = document.getElementById('email');"];
    
    [js appendString:[NSString stringWithFormat:@"emailField.value = '%@';", email]];
    
    [self.formField stringByEvaluatingJavaScriptFromString:[NSString stringWithString:js]];

    [js release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Feedback";
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	const CGFloat myColor[] = {0.67, 0.67, 0.67, 1.0};
	CGColorRef colour = CGColorCreate(rgb, myColor);
	CGColorSpaceRelease(rgb);
	
	[[self.formField layer] setCornerRadius:8.0f];
	[[self.formField layer] setMasksToBounds:YES];
	[[self.formField layer] setBorderWidth:1.0];
	[[self.formField layer] setBorderColor:colour];
	
	CGColorRelease(colour);
    
    AppLog(@"Initializing registered e-mail %@", [JavaZonePrefs registeredEmail]);
    
    [self.emailField setText:[JavaZonePrefs registeredEmail]];
    
    [self.formField loadRequest:[NSURLRequest requestWithURL:self.feedbackURL]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.formField = nil;
    self.emailField = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self setEmail:[self.emailField text]];
    
    AppLog(@"Storing registered e-mail %@", [textField text]);
    
    [JavaZonePrefs setRegisteredEmail:[textField text]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    AppLog(@"Finished Loading");
    
    // Can't find a way to check HTTP response code here. Seems to be only available if I send the form programatically rather than letting the webview do it.
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
       
    AppLog(@"Saw %@", html);
    
    if ([html rangeOfString:@"form"].location != NSNotFound) {
        [self setEmail:[self.emailField text]];
        [self insertStyle];
        
        AppLog(@"Generated head %@", [webView stringByEvaluatingJavaScriptFromString:@"document.head.innerHTML"]);
        AppLog(@"Generated body %@", [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"]);

        return;
    }
    
    
    NSString *errorRegex = @"<div ?[^>]* ?class=\"error\" ?[^>]* ?>(.*)</div>";
    NSString *successRegex = @"<div ?[^>]* ?class=\"success\" ?[^>]* ?>(.*)</div>";
    
    NSString *match = [html stringByMatching:errorRegex];
    
    AppLog(@"Saw match %@", match);
    
    if (match != nil && [match isEqual:@""] == NO) {
        NSString *message = [html stringByMatching:errorRegex capture:1L];
        
        AppLog(@"Message %@", message);

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

    match = [html stringByMatching:successRegex];
    
    AppLog(@"Saw match %@", match);

    if (match != nil && [match isEqual:@""] == NO) {
        [webView loadHTMLString:@"" baseURL:nil];
        
        NSString *message = [html stringByMatching:successRegex capture:1L];
        
        AppLog(@"Message %@", message);
        
        UIAlertView *successAlert = [[UIAlertView alloc]
								   initWithTitle: @"Feedback Sent"
								   message: message
								   delegate:self
								   cancelButtonTitle:@"OK"
								   otherButtonTitles:nil];
		[successAlert show];
		[successAlert release];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [session release];
    [emailField release];
    [formField release];
    [feedbackURL release];
    
    [super dealloc];
}

@end
