//
//  CompareImages.h
//  Team
//
//  Created by Tom Owen on 6/8/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedObject.h"
#import "RetrieveSettings.h"

@interface CompareImages : UIViewController<UIScrollViewDelegate,
UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *lesionImage;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView2;
@property (weak, nonatomic) IBOutlet UIWebView *lesionImage2;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel2;
@property (assign,nonatomic) UIActivityIndicatorView *spinner;
@end
