//
//  UsersGuide.h
//  Team
//
//  Created by Tom Owen on 7/9/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersGuide : UIViewController <UIWebViewDelegate>
@property (assign,nonatomic) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIWebView *usersGuide;
@end
