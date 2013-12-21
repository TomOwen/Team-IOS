//
//  HTMLHelpView.h
//  Team
//
//  Created by Tom Owen on 8/9/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTMLHelpView : UIViewController <UIScrollViewDelegate,UIWebViewDelegate>
- (void)setHTMLPage:(NSString *)filename;
@property (weak, nonatomic) IBOutlet UIWebView *helpWebView;
@property (weak, nonatomic) NSString *fullFileName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign,nonatomic) UIActivityIndicatorView *spinner;
@end
