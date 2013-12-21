//
//  ViewImage.m
//  Team
//
//  Created by Tom Owen on 6/7/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "ViewImage.h"

@interface ViewImage ()

@end

@implementation ViewImage
@synthesize scrollView = _scrollView;
@synthesize lesionImage = _lesionImage;
@synthesize imageLabel = _imageLabel;
@synthesize spinner = _spinner;

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView

{
    //NSLog(@"Zooming called");
    return self.lesionImage;
    
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
	// Do any additional setup after loading the view.
    // create a spinner for the right barbutton
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    
    NSString *imagedoc_server = [[SharedObject sharedTeamData] getImagedoc_server];
    NSString *imagedoc_user = [[SharedObject sharedTeamData] getImagedocUser];
    NSString *imagedoc_password = [[SharedObject sharedTeamData] getImagedocPassword];
    NSString *image_type = [[SharedObject sharedTeamData] getImageExt1];
    NSString *patientID = [[SharedObject sharedTeamData] getPatientID];
    NSString *patientName = [[SharedObject sharedTeamData] getPatientName];
    NSDate *scanDate = [[SharedObject sharedTeamData] getScanDate];
    NSNumber *lesionNumber = [[SharedObject sharedTeamData] getLesionNumber];
    
    NSString *serverURL = [[NSString alloc]initWithFormat:@"http://%@:%@@%@",imagedoc_user,imagedoc_password,imagedoc_server];
    //NSString *serverURL = [[NSString alloc]initWithFormat:@"http://%@",imagedoc_server];
    
    //NSLog(@"%@,%@,%@",patientID,scanDate,lesionNumber);
    //NSLog(@"imagedocserver=%@",imagedoc_server);
    //NSLog(@"imagetype=%@",[[SharedObject sharedTeamData] getMediaType]);
    //NSLog(@"doctype=%@",[[SharedObject sharedTeamData] getDocType]);
    // convert to URL in idnum-mmddyy-lesionnum.jpg
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMddyy"];
    NSString *newDateString = [outputFormatter stringFromDate:scanDate];
    NSString *lesionText = [[NSString alloc] initWithFormat:@"%@",lesionNumber];
    NSNumber *myteamid = [[SharedObject sharedTeamData] getTeamID];
    NSString *username = [[SharedObject sharedTeamData] getUser_name];
    //NSString *imageURL = [[NSString alloc] initWithFormat:@"%@/%@-%@-%@.%@",serverURL,patientID,newDateString,lesionText,image_type];
    NSString *imageURL = [[NSString alloc] initWithFormat:@"%@/teamredirect.php?user_teamid=%@&user_name=%@&fn=%@-%@-%@.%@&patient_id=%@&study_id=n/a",serverURL,myteamid,username,patientID,newDateString,lesionText,image_type,patientID];
    //NSLog(@"url = %@",imageURL);
    [outputFormatter setDateFormat:@"MM/dd/yy"];
    NSString *newDateString2 = [outputFormatter stringFromDate:scanDate];
    self.imageLabel.text = [[NSString alloc] initWithFormat:@"%@ %@ (Lesion #%@)", patientName,newDateString2,lesionText];
    
    
    // test cacheing
    /*
    NSURL *url = [NSURL fileURLWithPath:imageURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [self.lesionImage loadRequest:request];
    */
    
    
    [self.lesionImage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]]];
    
}

- (void)viewDidUnload
{
    [self setImageLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
