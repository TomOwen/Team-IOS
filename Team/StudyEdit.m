//
//  StudyEdit.m
//  Team
//
//  Created by Tom Owen on 5/31/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "StudyEdit.h"
#import "AppDelegate.h"

@interface StudyEdit ()

@end

@implementation StudyEdit
@synthesize manager = _manager;
@synthesize studyViewButton = _studyViewButton;
@synthesize delegate = _delegate;
@synthesize studyPercentPR = _studyPercentPR;
@synthesize studyPercentPD = _studyPercentPD;
@synthesize studyIDLabel = _studyIDLabel;
@synthesize studyOwnerInput = _studyOwnerInput;
@synthesize studyNameInput = _studyNameInput;
@synthesize studyURLInput = _studyURLInput;
@synthesize statusLabel = _statusLabel;
static NSString *s_id = nil;
static NSString *s_owner = nil;
static NSString *s_name = nil;
static NSString *s_URL = nil;
static NSNumber *s_PR = nil;
static NSNumber *s_PD = nil;
static NSNumber *s_Seats = nil;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"updatestudy"]) {
        [self checkStudyResults:objects];
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
- (void) checkStudyResults:(NSArray *)objects {
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
                       initWithTitle: @"Could not update that study"
                       message:@"Study may have been deleted, or maybe a TEAM DB problem."
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
        
    }
    NSString *display = [NSString stringWithFormat:@"%@ successfully updated",self.studyNameInput.text];
    [self.statusLabel setText:display];
    //[self.delegate userHitSave];
    self.studyViewButton.hidden = NO;
    if ([self.studyURLInput.text isEqualToString:@"n/a"]) {
        self.studyViewButton.hidden = YES;
    }

}

- (IBAction)viewStudyDocument:(UIButton *)sender {
   // NSLog(@"here in study");
    [self performSegueWithIdentifier:@"studyURLDisplay" sender:self];
}

- (IBAction)viewGraph:(UIButton *)sender {
  // NSLog(@"here in graph");
    [[SharedObject sharedTeamData] setStudyid:s_id];
    [self performSegueWithIdentifier:@"studyGraphDisplay" sender:self];
}

- (IBAction)viewPie:(UIButton *)sender {
    //NSLog(@"here in pie");
    [[SharedObject sharedTeamData] setStudyid:s_id];
    [self performSegueWithIdentifier:@"studyPieDisplay" sender:self];
}

- (void)setID:(NSString *)studyID setStudy:(NSString *)study setName:(NSString *)studyName setURL:(NSString *)studyURL setPR:(NSNumber *)studyPR setPD:(NSNumber *)studyPD setSeats:(NSNumber *)studySeats;
{
    //NSLog(@"got %@, %@, %@,%@,%@,%@",studyID,study,studyName,studyURL,studyPR,studyPD);
    s_id = studyID;
    s_owner = study;
    s_name = studyName;
    s_URL = studyURL;
    s_PD = studyPD;
    s_PR = studyPR;
    s_Seats = studySeats;
    
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
    
    self.studyPercentPR.text = [s_PR description];
    self.studyPercentPD.text = [s_PD description];
    self.studySeats.text = [s_Seats description];
    
    self.studyIDLabel.text = s_id;
    self.studyOwnerInput.text = s_owner;
    self.studyNameInput.text = s_name;
    self.studyURLInput.text = s_URL;
    self.studyViewButton.hidden = NO;
    if ([self.studyURLInput.text isEqualToString:@"n/a"]) {
        self.studyViewButton.hidden = YES;
    }
    if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"N"]) {
        self.navigationItem.rightBarButtonItem = Nil;
        self.statusLabel.text = @"";
        self.studyOwnerInput.enabled = NO;
        self.studyOwnerInput.borderStyle = UITextBorderStyleNone;
        [self.studyOwnerInput setTextColor:[UIColor greenColor]];
        self.studyNameInput.enabled = NO;
        self.studyNameInput.borderStyle = UITextBorderStyleNone;
        [self.studyNameInput setTextColor:[UIColor greenColor]];
        self.studyURLInput.enabled = NO;
        self.studyURLInput.borderStyle = UITextBorderStyleNone;
        [self.studyURLInput setTextColor:[UIColor greenColor]];
        self.studyPercentPD.enabled = NO;
        self.studyPercentPD.borderStyle = UITextBorderStyleNone;
        [self.studyPercentPD setTextColor:[UIColor greenColor]];
        self.studyPercentPR.enabled = NO;
        self.studyPercentPR.borderStyle = UITextBorderStyleNone;
        [self.studyPercentPR setTextColor:[UIColor greenColor]];
        self.studySeats.borderStyle = UITextBorderStyleNone;
        [self.studySeats setTextColor:[UIColor greenColor]];
    }
    self.studyViewButton.hidden = NO;
    if ([self.studyURLInput.text isEqualToString:@"n/a"]) {
        self.studyViewButton.hidden = YES;
    }
}

- (void)viewDidUnload
{
    [self setStudyOwnerInput:nil];
    [self setStudyNameInput:nil];
    [self setStudyURLInput:nil];
    [self setStatusLabel:nil];
    [self setStudyIDLabel:nil];
    [self setStudyViewButton:nil];
    [self setStudyPercentPR:nil];
    [self setStudyPercentPD:nil];
    [self setStudySeats:nil];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"here in Seque");
    if ([[segue identifier] isEqualToString:@"studyURLDisplay"]) {
        //StudyURLDisplay *studyURLDisplay = segue.destinationViewController;
        //StudyURLDisplay.delegate = self;
        [[segue destinationViewController] setStudyDoc:self.studyURLInput.text];
    }
    if ([[segue identifier] isEqualToString:@"studyGraphDisplay"]) {
        //StudyURLDisplay *studyURLDisplay = segue.destinationViewController;
        //StudyURLDisplay.delegate = self;
        [segue destinationViewController];
    }
    if ([[segue identifier] isEqualToString:@"studyPieDisplay"]) {
        //StudyURLDisplay *studyURLDisplay = segue.destinationViewController;
        //StudyURLDisplay.delegate = self;
        [segue destinationViewController];
    }
}

- (IBAction)saveStudy:(UIBarButtonItem *)sender {
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
    NSString *tempc = self.studySeats.text;
    // validate temp with NSNumberFormatter numberFromString
    NSNumberFormatter *formatterc = [[NSNumberFormatter alloc] init];
    NSNumber *numberc = [formatterc numberFromString:tempc];
    if (numberc == Nil) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Number of allocatted seats must be a number"
                       message:@"Please enter a valid number"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }


    
    // update the name and trial numbers
    /*
        [matches setValue:self.studyOwnerInput.text forKey:@"study_owner"];
        [matches setValue:self.studyNameInput.text forKey:@"study_name"];
        [matches setValue:self.studyURLInput.text forKey:@"study_url"];
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *myNumber = [f numberFromString:self.studyPercentPR.text];
        [matches setValue:myNumber forKey:@"study_percentpr"];
        
        NSNumberFormatter * f2 = [[NSNumberFormatter alloc] init];
        [f2 setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *myNumber2 = [f2 numberFromString:self.studyPercentPD.text];
        [matches setValue:myNumber2 forKey:@"study_percentpd"];
     */
    if (![self.studyOwnerInput.text length]) self.studyOwnerInput.text = @"n/a";
    if (![self.studyNameInput.text length]) self.studyNameInput.text = @"n/a";
    if (![self.studyURLInput.text length]) self.studyNameInput.text = @"n/a";
    // set up mapping
    RKObjectMapping* myresults = [RKObjectMapping mappingForClass:[Results class]];
    [myresults mapKeyPath:@"succeed" toAttribute:@"succeed"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:myresults forKeyPath:@"team.results"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSString *owner = self.studyOwnerInput.text;
    owner = [owner stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSString *name = self.studyNameInput.text;
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSString *url = self.studyURLInput.text;
    url = [url stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"study_id",s_id,
                                 @"study_name",name,
                                 @"study_owner",owner,
                                 @"study_percentPD",self.studyPercentPD.text,
                                 @"study_percentPR",self.studyPercentPR.text,
                                 @"study_seats",self.studySeats.text,
                                 @"study_url",url,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"updatestudy";
    //NSLog(@"%@,%@,%@,%@,%@,%@,%@",myid,s_id,self.studyNameInput.text,self.studyOwnerInput.text,self.studyPercentPD.text,self.studyPercentPR.text,self.studyURLInput.text);
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamupdatestudy.php" stringByAppendingQueryParameters:queryParams] delegate:self];
    
}
@end
