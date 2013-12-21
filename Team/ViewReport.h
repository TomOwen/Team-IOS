//
//  ViewReport.h
//  Team
//
//  Created by Tom Owen on 6/7/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedObject.h"

@interface ViewReport : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *scanReport;

@property (assign,nonatomic) UIActivityIndicatorView *spinner;
@end
