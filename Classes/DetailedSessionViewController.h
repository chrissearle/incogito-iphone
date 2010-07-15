//
//  DetailedSessionViewController.h
//  incogito
//
//  Created by Markuz Lindgren on 15.07.10.
//  Copyright 2010 Chris Searle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZSession.h"

@interface DetailedSessionViewController : UIViewController {
	JZSession		*session;
	UITextView		*details;
	UILabel			*sessionTitle;
	UILabel			*startDate;
	UILabel			*endDate;
}

@property (nonatomic, retain) JZSession		*session;
@property (nonatomic, retain) IBOutlet UITextView	*details;
@property (nonatomic, retain) IBOutlet UILabel		*sessionTitle;
@property (nonatomic, retain) IBOutlet UILabel		*startDate;
@property (nonatomic, retain) IBOutlet UILabel		*endDate;


- (void) closeModalViewController:(id)sender;
- (NSString *)removeHtmlTags:(NSString *)textWithTags;

@end
