//
//  StudyPieDisplay.h
//  Team
//
//  Created by Tom Owen on 12/29/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SharedObject.h"
#import "AppDelegate.h"


@interface StudyPieDisplay : UIViewController <UIWebViewDelegate>
@property (assign,nonatomic) UIActivityIndicatorView *spinner;
- (IBAction)printDetails:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIWebView *responseReport;
@end
