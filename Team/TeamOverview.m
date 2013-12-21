//
//  TeamOverview.m
//  Team
//
//  Created by Tom Owen on 7/8/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "TeamOverview.h"

@interface TeamOverview ()

@end

@implementation TeamOverview
@synthesize scrollView = _scrollView;
@synthesize spinner = _spinner;
@synthesize teamOverview = _teamOverview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"received error");
    [self.spinner stopAnimating];
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc] 
                   initWithTitle: @"Sorry, the connection to the Network returned an error!" 
                   message:@"Try again, or contact your administrator for help" 
                   delegate: nil
                   cancelButtonTitle: @"Ok"
                   otherButtonTitles: nil];
    [alertDialog show];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    // starting the load, show the activity indicator in the status bar
	[self.spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // finished loading, hide the activity indicator in the status bar
	NSLog(@"finished loading");
    [self.spinner stopAnimating];
    //self.myUIViewForSpinner.hidden = YES;
    self.navigationItem.rightBarButtonItem = Nil; 
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.hidesWhenStopped = YES;
    [spinner stopAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //self.spinner.color = [UIColor redColor];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    NSString *teamOverviewURL = @"http://www.whereryou.webuda.com/gallery/team/team-schematic.jpg";
    [self.teamOverview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:teamOverviewURL]]];
}

- (void)viewDidUnload
{
    //[self setTeamOverview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
