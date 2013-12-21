//
//  TeamOverview.h
//  Team
//
//  Created by Tom Owen on 7/8/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamOverview : UIViewController <UIScrollViewDelegate,UIWebViewDelegate>

@property (assign,nonatomic) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIWebView *teamOverview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
