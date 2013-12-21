//
//  TeamRules.m
//  Team
//
//  Created by Tom Owen on 7/11/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "TeamRules.h"

@interface TeamRules ()

@end

@implementation TeamRules
@synthesize helpWebView = _helpWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.helpWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"patient-response.html" ofType:@""]isDirectory:NO]]];
}

- (void)viewDidUnload
{
    [self setHelpWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
