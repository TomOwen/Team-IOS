//
//  ViewReport.m
//  Team
//
//  Created by Tom Owen on 6/7/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "ViewReport.h"

@interface ViewReport ()

@end

@implementation ViewReport
@synthesize spinner = _spinner;
@synthesize scrollView = _scrollView;
@synthesize scanReport = _scanReport;


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView

{
    
    return self.scanReport;
    
}


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    NSString *imagedoc_server = [[SharedObject sharedTeamData] getImagedoc_server];
    NSString *imagedoc_user = [[SharedObject sharedTeamData] getImagedocUser];
    NSString *imagedoc_password = [[SharedObject sharedTeamData] getImagedocPassword];
    NSString *doc_type = [[SharedObject sharedTeamData] getDocType];
    
    NSString *patientID = [[SharedObject sharedTeamData] getPatientID];
    NSDate *scanDate = [[SharedObject sharedTeamData] getScanDate];
    
    NSString *serverURL = [[NSString alloc]initWithFormat:@"http://%@:%@@%@",imagedoc_user,imagedoc_password,imagedoc_server];
    
    //NSLog(@"imagedocserver=%@",imagedoc_server);
    //NSLog(@"doctype=%@",[[SharedObject sharedTeamData] getDocType]);
    // convert to URL in idnum-mmddyy-lesionnum.jpg
    
    NSNumber *myteamid = [[SharedObject sharedTeamData] getTeamID];
    NSString *username = [[SharedObject sharedTeamData] getUser_name];
    //NSString *imageURL = [[NSString alloc] initWithFormat:@"%@/teamredirect.php?user_teamid=%@&user_name=%@&fn=%@-%@-%@.%@",serverURL,myteamid,username,patientID,newDateString,lesionText,image_type];
    
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMddyy"];
    NSString *newDateString = [outputFormatter stringFromDate:scanDate];
    
    //NSString *imageURL = [[NSString alloc] initWithFormat:@"%@/%@-%@.%@",serverURL,patientID,newDateString,doc_type];
    NSString *imageURL = [[NSString alloc] initWithFormat:@"%@/teamredirect.php?user_teamid=%@&user_name=%@&fn=%@-%@.%@",serverURL,myteamid,username,patientID,newDateString,doc_type];
    //NSLog(@"url = %@",imageURL);
    
    [self.scanReport loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
