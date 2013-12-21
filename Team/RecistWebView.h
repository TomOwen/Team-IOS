//
//  RecistWebView.h
//  Team
//
//  Created by Tom Owen on 6/25/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecistWebView : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (assign,nonatomic) UIActivityIndicatorView *spinner;
@end
