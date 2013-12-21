//
//  PatientEdit.m
//  Team
//
//  Created by Tom Owen on 5/30/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "PatientEdit.h"
#import "AppDelegate.h"
#import "ScanAdd.h"
#import "SharedObject.h"

@interface PatientEdit ()

@end

@implementation PatientEdit
@synthesize manager = _manager;
@synthesize callBack = _callBack;
@synthesize teamid = _teamid;
@synthesize currentLesions = _currentLesions;
@synthesize delegate = _delegate;
@synthesize studyPickerView = _studyPickerView;
@synthesize doctorPickerView = _doctorPickerView;
@synthesize studyArray = _studyArray;
@synthesize doctorArray = _doctorArray;
@synthesize patientIDLabel = _patientIDLabel;
@synthesize patientNameInput = _patientNameInput;
@synthesize patientStudyInput = _patientStudyInput;
@synthesize patientDoctorInput = _patientDoctorInput;
@synthesize statusLabel = _statusLabel;
static NSString *p_id = nil;
static NSString *p_name = nil;
static NSString *p_study = nil;
static NSString *p_doctor = nil;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)teamCalculator:(UIButton *)sender {
    // perform response calculations
    [self performSegueWithIdentifier:@"teamSegue" sender:sender];
}

- (void)setID:(NSString *)patientID setName:(NSString *)patientName setStudyID:(NSString *)patientStudyID setDoctor:(NSString *)patientDoctor
{
    //NSLog(@"got %@, %@, %@,%@",patientID,patientName,patientStudyID,patientDoctor);
    p_id = patientID;
    p_name = patientName;
    p_study = patientStudyID;
    p_doctor = patientDoctor;
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"getdocandstudy"]) {
        [self checkDocStudyResults:objects];
        return;
    }
    if ([self.callBack isEqualToString:@"updatepatient"]) {
        [self checkUpdateResults:objects];
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
- (void) checkDocStudyResults:(NSArray *)objects {
    int count = [objects count];
    // query returns 1 row teamid 0 if no doctors or studies
    self.studyArray = [[NSMutableArray alloc] init];
    self.doctorArray = [[NSMutableArray alloc] init];
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
        return; // no doctors or studies yet
    }
    // now
    for (DocandStudyMap *fetchData in objects) {
        NSString *myString = fetchData.string;
        NSString *myType = fetchData.type;
        if (![myString length]) myString = @"n/a";
        if (![myType length]) myType = @"n/a";
        if ([myType isEqualToString:@"1"]) {
            [self.doctorArray addObject:myString];
        }
        if ([myType isEqualToString:@"2"]) {
            [self.studyArray addObject:myString];
        }
    }
}
- (void) checkUpdateResults:(NSArray *)objects {
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
                       initWithTitle: @"Could not update that patient"
                       message:@"Patient may have been deleted, or maybe a TEAM DB problem."
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
        
    }
    NSString *display = [NSString stringWithFormat:@"%@ successfully updated",self.patientNameInput.text];
    [self.statusLabel setText:display];
}

- (void)readAllDocandStudies {
    // read patients for teamid, 1st get shared teamid
    // set up mapping
    RKObjectMapping* docandstudy = [RKObjectMapping mappingForClass:[DocandStudyMap class]];
    [docandstudy mapKeyPath:@"teamid" toAttribute:@"teamid"];
    [docandstudy mapKeyPath:@"type" toAttribute:@"type"];
    [docandstudy mapKeyPath:@"string" toAttribute:@"string"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:docandstudy forKeyPath:@"team.docandstudy"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,                          nil];
    self.callBack = @"getdocandstudy";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamdocandstudy.php" stringByAppendingQueryParameters:queryParams] delegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)studyPickerDoneClicked {
    [self.patientStudyInput resignFirstResponder];
}
-(void)doctorPickerDoneClicked {
    [self.patientDoctorInput resignFirstResponder];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //self.trialLabel.text =    [self.trialArray objectAtIndex:row];
    //self.patientTrial.text = [self.trialArray objectAtIndex:row];
    NSLog(@"row selected %d",row);
    if (pickerView == self.studyPickerView) {
        self.patientStudyInput.text = [self.studyArray objectAtIndex:row];
    }
    if (pickerView == self.doctorPickerView) {
        self.patientDoctorInput.text = [self.doctorArray objectAtIndex:row];
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (pickerView == self.studyPickerView) {
        return [self.studyArray count];
    } else {
        return [self.doctorArray count];
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if (pickerView == self.studyPickerView) {
        return [self.studyArray objectAtIndex:row];
    } else {
        return [self.doctorArray objectAtIndex:row];
    }
}


- (IBAction)showStudyPicker:(id)sender {
    
    // create a UIPicker view as a custom keyboard view
    UIPickerView* pickerView = [[UIPickerView alloc] init];
    [pickerView sizeToFit];
    pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    self.studyPickerView = pickerView;  //UIPickerView
    
    self.patientStudyInput.inputView = pickerView;
    
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(studyPickerDoneClicked)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    // Plug the keyboardDoneButtonView into the text field...
    self.patientStudyInput.inputAccessoryView = keyboardDoneButtonView;  
    
}


- (IBAction)showDoctorPicker:(id)sender {
    
    // create a UIPicker view as a custom keyboard view
    UIPickerView* pickerView = [[UIPickerView alloc] init];
    [pickerView sizeToFit];
    pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    self.doctorPickerView = pickerView;  //UIPickerView
    
    self.patientDoctorInput.inputView = pickerView;
    
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doctorPickerDoneClicked)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    // Plug the keyboardDoneButtonView into the text field...
    self.patientDoctorInput.inputAccessoryView = keyboardDoneButtonView;  
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // if user is not an Admin user then disable the save button
    /*
    NSString *fullURL = [[NSString alloc] initWithFormat:@"http://%@",[[SharedObject sharedTeamData] getDb_server]];
    NSURL *url = [[NSURL alloc] initWithString:fullURL];
   // NSURL *url = [[NSURL alloc] initWithString:[[SharedObject sharedTeamData] getDb_server]];
    self.manager = [RKObjectManager objectManagerWithBaseURL:url];
    self.manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    self.manager.client.username = [[SharedObject sharedTeamData] getDbUser];
    self.manager.client.password = [[SharedObject sharedTeamData] getDbPassword];
    */
    self.statusLabel.text = @"Enter Changes....";
    
    
    
        
    //NSString *myid = [[SharedObject sharedTeamData] getPatientID];
    //NSString *myname = [[SharedObject sharedTeamData] getPatientName];
    //NSLog(@"from shared object id=%@,name=%@,admin=%@",myid,myname,[[SharedObject sharedTeamData] getUserAdmin]);
    self.patientIDLabel.text = p_id;
    self.patientNameInput.text = p_name;
    self.patientStudyInput.text = p_study;
    self.patientDoctorInput.text = p_doctor;
    
    if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"N"]) {
        self.navigationItem.rightBarButtonItem = Nil;
        self.statusLabel.text = @"";
        self.patientNameInput.enabled = NO;
        self.patientNameInput.borderStyle = UITextBorderStyleNone;
        self.patientStudyInput.enabled = NO;
        self.patientStudyInput.borderStyle = UITextBorderStyleNone;
        self.patientDoctorInput.enabled = NO;
        self.patientDoctorInput.borderStyle = UITextBorderStyleNone;
    }
    if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"Y"]) {
        self.patientNameInput.textColor = [UIColor blackColor];
        self.patientStudyInput.textColor = [UIColor blackColor];
        self.patientDoctorInput.textColor = [UIColor blackColor];
    }
    [self readAllDocandStudies];
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

- (IBAction)savePatient:(UIBarButtonItem *)sender {
    if (![self.patientStudyInput.text length]) self.patientStudyInput.text = @"n/a";
    if (![self.patientDoctorInput.text length]) self.patientDoctorInput.text = @"n/a";
    NSString *temp_name = self.patientNameInput.text;
    temp_name = [temp_name stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    // set up mapping
    RKObjectMapping* myresults = [RKObjectMapping mappingForClass:[Results class]];
    [myresults mapKeyPath:@"succeed" toAttribute:@"succeed"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:myresults forKeyPath:@"team.results"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"patient_id",p_id,
                                 @"patient_name",temp_name,
                                 @"patient_study_id",self.patientStudyInput.text,
                                 @"patient_doctor",self.patientDoctorInput.text,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"updatepatient";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamupdatepatient.php" stringByAppendingQueryParameters:queryParams] delegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"scanDisplay"]) {
            NSString *myID = [NSString stringWithFormat:@"%@",self.patientIDLabel.text];
        [[SharedObject sharedTeamData] setPatientID:myID];
    }
}


@end
