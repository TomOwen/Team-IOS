//
//  StudyURLDisplay.m
//  Team
//
//  Created by Tom Owen on 6/26/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "StudyURLDisplay.h"

@interface StudyURLDisplay ()

@end

@implementation StudyURLDisplay
@synthesize myWebView = _myWebView;
@synthesize spinner = _spinner;
static NSString *s_doc = nil;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setStudyDoc:(NSString *)studyDoc
{
    //NSLog(@"got %@",studyDoc);
    s_doc = studyDoc;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    //NSString *myURL = [self retrieveServerURL];
    
    NSString *imagedoc_server = [[SharedObject sharedTeamData] getImagedoc_server];
    NSString *imagedoc_user = [[SharedObject sharedTeamData] getImagedocUser];
    NSString *imagedoc_password = [[SharedObject sharedTeamData] getImagedocPassword];
    
    NSNumber *myteamid = [[SharedObject sharedTeamData] getTeamID];
    NSString *username = [[SharedObject sharedTeamData] getUser_name];
    //NSString *imageURL = [[NSString alloc] initWithFormat:@"%@/teamredirect.php?user_teamid=%@&user_name=%@&fn=%@-%@-%@.%@",serverURL,myteamid,username,patientID,newDateString,lesionText,image_type];
    
    
    //NSString *serverURL = [[NSString alloc]initWithFormat:@"http://%@:%@@%@",imagedoc_user,imagedoc_password,imagedoc_server];
    NSString *serverURL = [[NSString alloc]initWithFormat:@"http://%@:%@@%@",imagedoc_user,imagedoc_password,imagedoc_server];
    
    // old NSString *urlWithDoc = [[NSString alloc] initWithFormat:@"%@/%@",serverURL,s_doc];
    NSString *urlWithDoc = [[NSString alloc] initWithFormat:@"%@/teamredirect.php?user_teamid=%@&user_name=%@&fn=%@",serverURL,myteamid,username,s_doc];
    
    //NSLog(@"retrieving %@",urlWithDoc);
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlWithDoc]]];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    // starting the load, show the activity indicator in the status bar
	[self.spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // finished loading, hide the activity indicator in the status bar
	//NSLog(@"finished loading");
    [self.spinner stopAnimating];
    //self.myUIViewForSpinner.hidden = YES;
    self.navigationItem.rightBarButtonItem = Nil; 
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.hidesWhenStopped = YES;
    [spinner stopAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
    
}

- (void)viewDidUnload
{
    [self setMyWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
