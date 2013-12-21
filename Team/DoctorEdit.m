//
//  DoctorEdit.m
//  Team
//
//  Created by Tom Owen on 10/19/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "DoctorEdit.h"

@interface DoctorEdit ()

@end

@implementation DoctorEdit
@synthesize statusLabel = _statusLabel;
@synthesize drName = _drName;
@synthesize drInfo = _drInfo;
@synthesize manager = _manager;

static NSString *s_dr = nil;
static NSString *s_info = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"updatedoctor"]) {
        [self checkDoctorResults:objects];
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
- (void) checkDoctorResults:(NSArray *)objects {
    int count = [objects count];
    // add returns 1 row teamid 0 if patient exist 1 added ok
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
    Results* result = [objects objectAtIndex:0];
    if ([result.succeed isEqualToString:@"0"]) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Could not update that doctor"
                       message:@"Doctor may have been deleted, or maybe a TEAM DB problem."
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
        
    }
    NSString *display = [NSString stringWithFormat:@"%@ successfully updated",self.drName.text];
    self.statusLabel.text = display;
    
}

- (void)doctorName:(NSString *)drname doctorInfo:(NSString *)drinfo
{
    //NSLog(@"got %@, %@, %@,%@,%@,%@",studyID,study,studyName,studyURL,studyPR,studyPD);
    s_dr = drname;
    s_info = drinfo;
}
- (void)viewWillDisappear:(BOOL)animated {
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
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
    
    self.drName.text = s_dr;
    self.drInfo.text = s_info;
    if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"N"]) {
        self.navigationItem.rightBarButtonItem = Nil;
        self.drInfo.enabled = NO;
        self.drInfo.borderStyle = UITextBorderStyleNone;
        [self.drInfo setTextColor:[UIColor greenColor]];
    }
}

- (void)viewDidUnload
{
    
    [self setStatusLabel:nil];
    [self setDrName:nil];
    [self setDrInfo:nil];
    [self setStatusLabel:nil];
    [self setDrName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)saveDoctor:(UIBarButtonItem *)sender {
    if (![self.drInfo.text length]) self.drInfo.text = @"n/a";
    // set up mapping
    RKObjectMapping* myresults = [RKObjectMapping mappingForClass:[Results class]];
    [myresults mapKeyPath:@"succeed" toAttribute:@"succeed"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:myresults forKeyPath:@"team.results"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSString *drInfo = self.drInfo.text;
    drInfo = [drInfo stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"doctor_name",s_dr,
                                 @"doctor_info",drInfo,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"updatedoctor";
    //NSLog(@"%@,%@,%@,%@,%@,%@,%@",myid,s_id,self.studyNameInput.text,self.studyOwnerInput.text,self.studyPercentPD.text,self.studyPercentPR.text,self.studyURLInput.text);
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamupdatedoctor.php" stringByAppendingQueryParameters:queryParams] delegate:self];
    
}
@end
