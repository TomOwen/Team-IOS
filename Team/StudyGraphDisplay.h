//
//  StudyGraphDisplay.h
//  Team
//
//  Created by Tom Owen on 12/28/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedObject.h"
#import "AppDelegate.h"


@interface StudyGraphDisplay : UIViewController <UIWebViewDelegate>
@property (assign,nonatomic) UIActivityIndicatorView *spinner;
- (IBAction)printDetails:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIWebView *responseReport;
@end

