//
//  StudyAdd.m
//  Team
//
//  Created by Tom Owen on 5/30/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "StudyAdd.h"


@interface StudyAdd ()

@end

@implementation StudyAdd
@synthesize manager = _manager;
@synthesize callBack = _callBack;
@synthesize studyPercentPR = _studyPercentPR;
@synthesize studyPercentPD = _studyPercentPD;
@synthesize studyIDInput = _studyIDInput;
@synthesize studyOwnerInput = _studyOwnerInput;
@synthesize studyNameInput = _studyNameInput;
@synthesize studyURLInput = _studyURLInput;
@synthesize statusNewLabel = _statusNewLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    self.studyPercentPD.text = @"20";
    self.studyPercentPR.text = @"30";
    self.studySeats.text = @"0";
}

- (void)viewDidUnload
{
    [self setStudyIDInput:nil];
    [self setStudyOwnerInput:nil];
    [self setStudyNameInput:nil];
    [self setStudyURLInput:nil];
    [self setStatusNewLabel:nil];
    [self setStudyPercentPR:nil];
    [self setStudyPercentPD:nil];
    [self setStudySeats:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"addstudy"]) {
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
    DocandStudyMap* docstudy = [objects objectAtIndex:0];
    if ([docstudy.teamid isEqualToNumber:[NSNumber numberWithInt:0]]) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"That Study ID already exists."
                       message:@"Please try a different ID number"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
        
    }
    NSString *display = [NSString stringWithFormat:@"%@ successfully added",self.studyIDInput.text];
    [self.statusNewLabel setText:display];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)saveNewStudy:(UIBarButtonItem *)sender {
    // check if ID is entered (mandatory) field
    
    if ([self.studyIDInput.text length] < 1) { 
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Study ID must be at least 2 characters" 
                       message:@"Please Re-enter the ID" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    NSRange result = [self.studyIDInput.text rangeOfString:@" "];
    if (result.location != NSNotFound) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Study ID must not contain any spaces"
                       message:@"Please Re-enter the ID"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }

    // check percents for valid numbers
    NSString *temp = self.studyPercentPR.text;
    // validate temp with NSNumberFormatter numberFromString
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:temp];
    if (number == Nil) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Partial Response % is not a valid number" 
                       message:@"Please enter a valid percent number" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    NSString *temp2 = self.studyPercentPD.text;
    // validate temp with NSNumberFormatter numberFromString
    NSNumberFormatter *formatter2 = [[NSNumberFormatter alloc] init];
    NSNumber *number2 = [formatter2 numberFromString:temp2];
    if (number2 == Nil) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Progressive Disease % is not a valid number" 
                       message:@"Please enter a valid percent number" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    // check percents for valid numbers
    NSString *tempc = self.studySeats.text;
    // validate temp with NSNumberFormatter numberFromString
    NSNumberFormatter *formatterc = [[NSNumberFormatter alloc] init];
    NSNumber *numberc = [formatterc numberFromString:tempc];
    if (numberc == Nil) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Number of allocated patients is not a valid number"
                       message:@"Please enter a valid number"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }

    RKObjectMapping* docandstudy = [RKObjectMapping mappingForClass:[DocandStudyMap class]];
    [docandstudy mapKeyPath:@"teamid" toAttribute:@"teamid"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:docandstudy forKeyPath:@"team.studies"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSString *studyid = self.studyIDInput.text;
    studyid = [studyid stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSString *owner = self.studyOwnerInput.text;
    owner = [owner stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSString *name = self.studyNameInput.text;
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSString *url = self.studyURLInput.text;
    url = [url stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"study_id",studyid,
                                 @"study_owner",owner,
                                 @"study_name",name,
                                 @"study_url",url,
                                 @"study_percentpr",self.studyPercentPR.text,
                                 @"study_percentpd",self.studyPercentPD.text,
                                 @"study_seats",self.studySeats.text,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"addstudy";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamaddstudy.php" stringByAppendingQueryParameters:queryParams] delegate:self];

}

@end
