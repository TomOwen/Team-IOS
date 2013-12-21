//
//  TeamGraphResponse.m
//  Team
//
//  Created by Tom Owen on 12/27/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "TeamGraphResponse.h"

@interface TeamGraphResponse ()

@end

@implementation TeamGraphResponse
@synthesize spinner = _spinner;
@synthesize responseReport = _responseReport;

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
    
    UIBarButtonItem *myprint = [[UIBarButtonItem alloc]initWithTitle:@"Print" style:UIBarButtonItemStylePlain target:self action:@selector(printDetails:)];
    self.navigationItem.rightBarButtonItem=myprint;
    
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
    
    NSString *dbserver = [[SharedObject sharedTeamData] getDb_server];
    NSString *dbuser = [[SharedObject sharedTeamData] getDbUser];
    NSString *dbpassword = [[SharedObject sharedTeamData] getDbPassword];
    NSNumber *teamid = [[SharedObject sharedTeamData] getTeamID];
    NSString *patientID = [[SharedObject sharedTeamData] getPatientID];
    NSString *myuser = [[SharedObject sharedTeamData] getUser_name];
    NSString *serverURL = [[NSString alloc]initWithFormat:@"http://%@:%@@%@/graphpatient.php?teamid=%@&patient_id=%@&user_name=%@",dbuser,dbpassword,dbserver,teamid,patientID,myuser];
    //NSLog(@"url=%@",serverURL);
    //serverURL = @"http://teamdb1000:TeamDemo143@www.websoftmagic.com/db/teamresponse.php?teamid=1000&patient_id=100";
    [self.responseReport loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:serverURL]]];
    
}

- (void)viewDidUnload
{
    [self setResponseReport:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (IBAction)printDetails:(UIBarButtonItem *)sender {
    // Get the print job class
    UIPrintInteractionController *pc = [UIPrintInteractionController
                                        sharedPrintController];
    
    // set up basic options
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Patient Scan Graph";
    pc.printInfo = printInfo;
    pc.showsPageRange = YES;
    
    // give the webview to be printed
    UIViewPrintFormatter *formatter = [self.responseReport viewPrintFormatter];
    pc.printFormatter = formatter;
    
    // code to run after printer to see if it failed
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed,
      NSError *error) {
        if(!completed && error){
            NSLog(@"Print failed - domain: %@ error code %u", error.domain,
                  error.code);
        }
    };
    
    // bring up the AirPrint dialog
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [pc presentFromBarButtonItem:sender animated:YES completionHandler:completionHandler];
        
    } else {
        [pc presentAnimated:YES completionHandler:completionHandler];
    }
    
    
}
@end
