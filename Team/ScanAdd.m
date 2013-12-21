//
//  ScanAdd.m
//  Team
//
//  Created by Tom Owen on 6/4/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "ScanAdd.h"
#import "AppDelegate.h"

@interface ScanAdd ()

@end

@implementation ScanAdd
@synthesize manager = _manager;
@synthesize callBack = _callBack;
@synthesize scanPatientID = _scanPatientID;
@synthesize scanDateInput = _scanDateInput;
@synthesize statusNewLabel = _stausNewLabel;
@synthesize datePickerView = _datePickerView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    //NSLog(@"rest did load");
    if ([self.callBack isEqualToString:@"addscan"]) {
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
    if ([docstudy.teamid isEqualToNumber:[NSNumber numberWithInt:1]]) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"That Scan Date already exists."
                       message:@"Please try a different Date."
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
        
    }
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"Added Scan Date"
                   message:@"Copied any/all lesions from latest Scan Date"
                   delegate: nil
                   cancelButtonTitle: @"Ok"
                   otherButtonTitles: nil];
    [alertDialog show];
    //NSLog(@"added scan");

}

- (void)changeDateInLabel:(id)sender{
   // NSLog(@"something changed");
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	//df.dateStyle = NSDateFormatterShortStyle;
    
    // convert to yyyy-MM-dd
    [df setDateFormat:@"yyyy-MM-dd"];
	self.scanDateInput.text = [NSString stringWithFormat:@"%@",
                  [df stringFromDate:self.datePickerView.date]];
}
- (void)studyPickerDoneClicked{
    //NSLog(@"done clicked");
    [self.scanDateInput resignFirstResponder];
}
- (void)showDatePicker:(id)sender {
    //NSLog(@"showing date picker");
    // create a UIPicker view as a custom keyboard view
    UIDatePicker* pickerView = [[UIDatePicker alloc] init];
    [pickerView sizeToFit];
    pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    //pickerView.delegate = self;
    //pickerView.dataSource = self;
    //pickerView.showsSelectionIndicator = YES;
    self.datePickerView = pickerView;  //UIPickerView
    pickerView.datePickerMode = UIDatePickerModeDate;
    
    self.scanDateInput.inputView = pickerView;
    [pickerView addTarget:self
                   action:@selector(changeDateInLabel:)
         forControlEvents:UIControlEventValueChanged];
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
    self.scanDateInput.inputAccessoryView = keyboardDoneButtonView;  
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSLog(@"view did load");
    [self showDatePicker:self];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterShortStyle;
    [df setDateFormat:@"yyyy-MM-dd"];
	self.scanDateInput.text = [NSString stringWithFormat:@"%@",
                               [df stringFromDate:self.datePickerView.date]];
    // get patientID from shared object
    self.scanPatientID = [[SharedObject sharedTeamData] getPatientID];
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
    //NSLog(@"cancel all reuests");
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
}
- (void)viewDidUnload
{
    [self setScanDateInput:nil];
    [self setStatusNewLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    //NSLog(@"did unload");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (IBAction)saveButtonHit:(UIBarButtonItem *)sender {

    // check if date is entered (mandatory) field
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateInput = [dateFormatter dateFromString:self.scanDateInput.text];
    if (dateInput == Nil) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Invalid Date (yyyy-MM-dd)" 
                       message:@"Please Re-enter the Date" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    
    if ([self.scanDateInput.text length] < 1) { 
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Please enter the scan date" 
                       message:@"Please Re-enter the Date" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    //NSLog(@"save button hit");
    //NSString *name = [self htmlEntityEncode:self.doctorNameInput.text];
    RKObjectMapping* docandstudy = [RKObjectMapping mappingForClass:[DocandStudyMap class]];
    [docandstudy mapKeyPath:@"teamid" toAttribute:@"teamid"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:docandstudy forKeyPath:@"team.scan"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    self.scanPatientID = [[SharedObject sharedTeamData] getPatientID];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"patient_id",self.scanPatientID,
                                 @"scan_date",self.scanDateInput.text,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"addscan";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamaddscan.php" stringByAppendingQueryParameters:queryParams] delegate:self];
    //NSLog(@"called add scan");
}

@end
