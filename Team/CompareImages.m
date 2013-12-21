//
//  CompareImages.m
//  Team
//
//  Created by Tom Owen on 6/8/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "CompareImages.h"

@interface CompareImages ()

@end

@implementation CompareImages
@synthesize spinner = _spinner;
@synthesize scrollView = _scrollView;
@synthesize lesionImage = _lesionImage;
@synthesize imageLabel = _imageLabel;
@synthesize scrollView2 = _scrollView2;
@synthesize lesionImage2 = _lesionImage2;
@synthesize imageLabel2 = _imageLabel2;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollViewx {
    //NSLog(@"did scrolling");
    if (scrollViewx == self.scrollView) {
        //NSLog(@"scrolling");
        // Do stuff with scrollView1
    } else if (scrollViewx == self.scrollView2) {
        // Do stuff with scrollView2
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView

{
    //NSLog(@"zooming");
    if (scrollView.tag == 1) {
    //return self.lesionImage;
        //NSLog(@"zooming");
        return self.lesionImage;
    } else {
    //return self.lesionImage2;
        return self.lesionImage2;
    }
    
}


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
    // get URL and image type from settings table
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
    
    //NSLog(@"%@,%@,%@",patientID,scanDate,lesionNumber);
   // NSLog(@"imagedocserver=%@",imagedoc_server);
    //NSLog(@"imagetype=%@",[[SharedObject sharedTeamData] getMediaType]);
    // convert to URL in idnum-mmddyy-lesionnum.jpg
    
    
    NSNumber *myteamid = [[SharedObject sharedTeamData] getTeamID];
    NSString *username = [[SharedObject sharedTeamData] getUser_name];
    /*
    NSString *imageURL = [[NSString alloc] initWithFormat:@"%@/teamredirect.php?user_teamid=%@&user_name=%@&fn=%@-%@-%@.%@",serverURL,myteamid,username,patientID,newDateString,lesionText,image_type];
    */
    
    
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMddyy"];
    NSString *newDateString = [outputFormatter stringFromDate:scanDate];
    NSString *lesionText = [[NSString alloc] initWithFormat:@"%@",lesionNumber];
    
    //NSString *imageURL = [[NSString alloc] initWithFormat:@"%@/%@-%@-%@.%@",serverURL,patientID,newDateString,lesionText,image_type];
    NSString *imageURL = [[NSString alloc] initWithFormat:@"%@/teamredirect.php?user_teamid=%@&user_name=%@&fn=%@-%@-%@.%@&patient_id=%@&study_id=n/a",serverURL,myteamid,username,patientID,newDateString,lesionText,image_type,patientID];
    
    //NSLog(@"url lesionimage = %@",imageURL);
    [outputFormatter setDateFormat:@"MM/dd/yy"];
    NSString *newDateString2 = [outputFormatter stringFromDate:scanDate];
    self.imageLabel.text = [[NSString alloc] initWithFormat:@"%@ %@ (Lesion #%@)", patientName,newDateString2,lesionText];
    self.scrollView.delegate = self;
    self.lesionImage.userInteractionEnabled = YES;
    self.scrollView2.delegate = self;
    self.lesionImage2.userInteractionEnabled = YES;

	// Do any additional setup after loading the view.
    NSDate *scanDate2 = [[SharedObject sharedTeamData] getScanDate2];
    NSNumber *lesionNumber2 = [[SharedObject sharedTeamData] getLesionNumber2];
    NSString *mediaType2 = [[SharedObject sharedTeamData] getImageExt2];
    // convert to URL in idnum-mmddyy-lesionnum.jpg
    // image 1
    self.imageLabel.text = [[NSString alloc] initWithFormat:@"%@ %@ (Lesion #%@)", patientName,newDateString2,lesionText]; 
    
    
    [self.lesionImage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]]];
    // image 2
    NSDateFormatter *outputFormatter2 = [[NSDateFormatter alloc] init];
    [outputFormatter2 setDateFormat:@"MMddyy"];
    NSString *newDateString3 = [outputFormatter2 stringFromDate:scanDate2];
    NSString *lesionText2 = [[NSString alloc] initWithFormat:@"%@",lesionNumber2];
    
    
    //NSString *imageURL2 = [[NSString alloc] initWithFormat:@"%@/%@-%@-%@.%@",serverURL,patientID,newDateString3,lesionText2,mediaType2];
    NSString *imageURL2 = [[NSString alloc] initWithFormat:@"%@/teamredirect.php?user_teamid=%@&user_name=%@&fn=%@-%@-%@.%@&patient_id=%@&study_id=n/a",serverURL,myteamid,username,patientID,newDateString3,lesionText2,mediaType2,patientID];
    
    
    //NSLog(@"url lesionimage2 = %@",imageURL2);
    [outputFormatter setDateFormat:@"MM/dd/yy"];
    NSString *newDateString4 = [outputFormatter stringFromDate:scanDate2];
    self.imageLabel2.text = [[NSString alloc] initWithFormat:@"%@ %@ (Lesion #%@)", patientName,newDateString4,lesionText2]; 
    
    
    [self.lesionImage2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL2]]];

    
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
