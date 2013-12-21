//
//  ViewImage.h
//  Team
//
//  Created by Tom Owen on 6/7/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedObject.h"


@interface ViewImage : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *lesionImage;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@property (assign,nonatomic) UIActivityIndicatorView *spinner;

@end
