//
//  PatientAdd.m
//  Team
//
//  Created by Tom Owen on 5/30/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "PatientAdd.h"


@interface PatientAdd ()

@end

@implementation PatientAdd
@synthesize manager = _manager;
@synthesize studyPickerView = _studyPickerView;
@synthesize doctorPickerView = _doctorPickerView;
@synthesize studyInput = _studyInput;
@synthesize doctorInput = _doctorInput;
@synthesize studyArray = _studyArray;
@synthesize doctorArray = _doctorArray;
@synthesize fetchData = _fetchData;
@synthesize patientName = _patientName;
@synthesize patientID = _patientID;
@synthesize statusNewLabel = _statusNewLabel;

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"getdocandstudy"]) {
        [self checkDocStudyResults:objects];
        return;
    }
    if ([self.callBack isEqualToString:@"addpatient"]) {
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
        if ([myType isEqualToString:@"1"]) {
            [self.doctorArray addObject:myString];
        }
        if ([myType isEqualToString:@"2"]) {
            [self.studyArray addObject:myString];
        }
    }
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
                       initWithTitle: @"That patient ID already exist."
                       message:@"Please try a different ID number"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;

    }
    NSString *display = [NSString stringWithFormat:@"%@ successfully added",self.patientName.text];
    [self.statusNewLabel setText:display];
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
    [self.studyInput resignFirstResponder];
}
-(void)doctorPickerDoneClicked {
    [self.doctorInput resignFirstResponder];
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
        self.studyInput.text = [self.studyArray objectAtIndex:row];
    }
    if (pickerView == self.doctorPickerView) {
        self.doctorInput.text = [self.doctorArray objectAtIndex:row];
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
    
    self.studyInput.inputView = pickerView;
    
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
    self.studyInput.inputAccessoryView = keyboardDoneButtonView;  
    
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
    
    self.doctorInput.inputView = pickerView;
    
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
    self.doctorInput.inputAccessoryView = keyboardDoneButtonView;  
    
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
    // Do any additional setup after loading the view.
    //NSURL *url = [[NSURL alloc] initWithString:[[SharedObject sharedTeamData] getDb_server]];
    /*
    NSString *fullURL = [[NSString alloc] initWithFormat:@"http://%@",[[SharedObject sharedTeamData] getDb_server]];
    NSURL *url = [[NSURL alloc] initWithString:fullURL];
    self.manager = [RKObjectManager objectManagerWithBaseURL:url];
    self.manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    self.manager.client.username = [[SharedObject sharedTeamData] getDbUser];
    self.manager.client.password = [[SharedObject sharedTeamData] getDbPassword];
    */
    self.statusNewLabel.text = @"Enter Next Patient";
    [self readAllDocandStudies];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
}
- (void)viewDidUnload
{
    [self setPatientName:nil];
    [self setPatientID:nil];
    [self setStatusNewLabel:nil];
    [self setStudyInput:nil];
    [self setDoctorInput:nil];
    [self setPatientName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (BOOL)doesIDAlreadyExist:(NSManagedObjectContext *)context
{
    NSEntityDescription *entityDesc = 
    [NSEntityDescription entityForName:@"Patient" 
                inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(patient_id = %@)", 
                         self.patientID.text];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request 
                                              error:&error];
    if ([objects count] == 0) {
        return NO;
    }
    return YES;
}

- (IBAction)saveNewPatient:(UIBarButtonItem *)sender {
    // check if ID is entered (mandatory) field
    
    if ([self.patientID.text length] < 1) { 
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Patient ID must be at least 2 characters" 
                       message:@"Please Re-enter the ID" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    NSRange result = [self.patientID.text rangeOfString:@" "];
    if (result.location != NSNotFound) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Patient ID must not contain any spaces" 
                       message:@"Please Re-enter the ID" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    if ([self.studyInput.text isEqualToString:@""]) self.studyInput.text = @"n/a";
    if ([self.doctorInput.text isEqualToString:@""]) self.doctorInput.text = @"n/a";
    NSString *temp_name = self.patientName.text;
    temp_name = [temp_name stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSString *temp_id = self.patientID.text;
    temp_id = [temp_id stringByReplacingOccurrencesOfString:@"'" withString:@""];
// ok now run teamaddpatient.php recieve 0 fail or 1 ok
    // set up mapping
    RKObjectMapping* docandstudy = [RKObjectMapping mappingForClass:[DocandStudyMap class]];
    [docandstudy mapKeyPath:@"teamid" toAttribute:@"teamid"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:docandstudy forKeyPath:@"team.patient"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"patient_id",temp_id,
                                 @"patient_name",temp_name,
                                 @"patient_study_id",self.studyInput.text,
                                 @"patient_doctor",self.doctorInput.text,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"addpatient";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamaddpatient.php" stringByAppendingQueryParameters:queryParams] delegate:self];
    
}

@end
