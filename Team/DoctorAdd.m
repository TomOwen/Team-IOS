//
//  DoctorAdd.m
//  Team
//
//  Created by Tom Owen on 6/2/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "DoctorAdd.h"


@interface DoctorAdd ()

@end

@implementation DoctorAdd
@synthesize manager = _manager;
@synthesize callBack = _callBack;
@synthesize doctorNameInput = _doctorNameInput;
@synthesize doctorInfoInput = _doctorInfoInput;
@synthesize statusNewLabel = _statusNewLabel;

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
    /*
    NSString *fullURL = [[NSString alloc] initWithFormat:@"http://%@",[[SharedObject sharedTeamData] getDb_server]];
    NSURL *url = [[NSURL alloc] initWithString:fullURL];
    //NSURL *url = [[NSURL alloc] initWithString:[[SharedObject sharedTeamData] getDb_server]];
    self.manager = [RKObjectManager objectManagerWithBaseURL:url];
    self.manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    self.manager.client.username = [[SharedObject sharedTeamData] getDbUser];
    self.manager.client.password = [[SharedObject sharedTeamData] getDbPassword];
    */
}
- (void)viewWillDisappear:(BOOL)animated {
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
}
- (void)viewDidUnload
{
    [self setDoctorNameInput:nil];
    [self setDoctorInfoInput:nil];
    [self setStatusNewLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"adddoctor"]) {
        [self checkAddResults:objects];
        return;
    }
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"Network Not Availble"
                   message:@"Please check your network settings, I can not reach the internet"
                   delegate: nil
                   cancelButtonTitle: @"Ok"
                   otherButtonTitles: nil];
    
    [alertDialog show];
    NSLog(@"error %@",error);
}
- (void) checkAddResults:(NSArray *)objects {
    int count = [objects count];
    // add returns 1 row teamid 0 if doctor exist 1 added ok
    if (count < 1) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Could not reach the TEAM server!"
                       message:@"Please contact TEAM support or check your internet connection"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
    }
    DocandStudyMap* docstudy = [objects objectAtIndex:0];
    if ([docstudy.teamid isEqualToNumber:[NSNumber numberWithInt:0]]) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"That Doctor already exists."
                       message:@"Please try a different Doctor."
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
        
    }
    NSString *display = [NSString stringWithFormat:@"%@ successfully added",self.doctorNameInput.text];
    [self.statusNewLabel setText:display];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
-(NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    return string;
}
-(NSString *)htmlEntityEncode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    
    return string;
}


- (IBAction)saveNewDoctor:(UIBarButtonItem *)sender {
    // check if ID is entered (mandatory) field
    
    if ([self.doctorNameInput.text length] < 1) { 
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Please enter the New Doctor's name" 
                       message:@"Please Re-enter the Name" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    if ([self.doctorInfoInput.text length] < 1) self.doctorInfoInput.text = @"n/a";
    //NSString *name = [self htmlEntityEncode:self.doctorNameInput.text];
    RKObjectMapping* docandstudy = [RKObjectMapping mappingForClass:[DocandStudyMap class]];
    [docandstudy mapKeyPath:@"teamid" toAttribute:@"teamid"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:docandstudy forKeyPath:@"team.doctor"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSString *name = self.doctorNameInput.text;
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSString *info = self.doctorInfoInput.text;
    info = [info stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"doctor_name",name,
                                 @"doctor_info",info,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"adddoctor";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamadddoctor.php" stringByAppendingQueryParameters:queryParams] delegate:self];
        
}
@end
