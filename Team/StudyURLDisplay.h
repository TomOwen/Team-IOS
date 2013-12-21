//
//  StudyURLDisplay.h
//  Team
//
//  Created by Tom Owen on 6/26/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedObject.h"
#import "AppDelegate.h"

@interface StudyURLDisplay : UIViewController <UIWebViewDelegate>
- (void)setStudyDoc:(NSString *)studyDoc;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (assign,nonatomic) UIActivityIndicatorView *spinner;

@end
