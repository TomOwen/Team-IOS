//
//  LesionAdd.m
//  Team
//
//  Created by Tom Owen on 6/6/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "LesionAdd.h"

@interface LesionAdd ()

@end

@implementation LesionAdd
@synthesize manager = _manager;
@synthesize callBack = _callBack;
@synthesize mediaInput = _mediaInput;
@synthesize mediaArray = _mediaArray;
@synthesize mediaPickerView = _mediaPickerView;
@synthesize patientName = _patientName;
@synthesize scanDate = _scanDate;
@synthesize lesionNumber = _lesionNumber;
@synthesize lesionSize = _lesionSize;
@synthesize lesionComment = _lesionComment;
@synthesize targetLesion = _targetLesion;
@synthesize lesionMediaOnline = _lesionMediaOnline;
@synthesize lesionLymphNode = _lesionLymphNode;
@synthesize statusNewLabel = _statusNewLabel;
@synthesize fileNameLabel = _fileNameLabel;
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"addlesion"]) {
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
    Results* lesion = [objects objectAtIndex:0];
    if ([lesion.succeed isEqualToString:@"0"]) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"That lesion already exist."
                       message:@"Please try a different ID number"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
    }
    NSString *display = [NSString stringWithFormat:@"Lesion %@ successfully added",self.lesionNumber.text];
    [self.statusNewLabel setText:display];
}


-(void)createAndSetFileName {
    NSString *myID = [[SharedObject sharedTeamData] getPatientID];
    NSDateFormatter *outputFormatter2 = [[NSDateFormatter alloc] init];
    [outputFormatter2 setDateFormat:@"MMddyy"];
    NSString *newDateString2 = [outputFormatter2 stringFromDate:[[SharedObject sharedTeamData] getScanDate]];
    self.fileNameLabel.text = [[NSString alloc] initWithFormat:@"Image/File Name %@-%@-%@.%@",myID,newDateString2,self.lesionNumber.text,self.mediaInput.text];
}
- (IBAction)lesionNumberValueChanged:(UIStepper *)sender {
    double value = [sender value];
    
    [self.lesionNumber setText:[NSString stringWithFormat:@"%d", (int)value]];
    [self createAndSetFileName];
}
- (IBAction)lesionSizeValueChanged:(UIStepper *)sender {
    [self.lesionSize setText:[NSString stringWithFormat:@"%1.1f",[sender value]]];
}
- (IBAction)showMediaPicker:(UITextField *)sender {
    // create a UIPicker view as a custom keyboard view
    UIPickerView* pickerView = [[UIPickerView alloc] init];
    [pickerView sizeToFit];
    pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    self.mediaPickerView = pickerView;  //UIPickerView
    
    self.mediaInput.inputView = pickerView;
    
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(mediaPickerDoneClicked)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    // Plug the keyboardDoneButtonView into the text field...
    self.mediaInput.inputAccessoryView = keyboardDoneButtonView; 
}
-(void)mediaPickerDoneClicked {
    [self.mediaInput resignFirstResponder];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"row selected %d",row);
    if (pickerView == self.mediaPickerView) {
        self.mediaInput.text = [self.mediaArray objectAtIndex:row];
        [self createAndSetFileName];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [self.mediaArray count];
 
      
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [self.mediaArray objectAtIndex:row];
}



- (IBAction)saveNewLesion:(UIBarButtonItem *)sender {
    // check if ID is entered (mandatory) field
    
    if ([self.lesionNumber.text length] < 1) { 
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Please enter the new Target Lesion Number" 
                       message:@"Please Re-enter the Number" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    if ([self.lesionComment.text length] < 1) self.lesionComment.text = @"n/a";
    NSString *comment = self.lesionComment.text;
    comment = [comment stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    
    NSString *temp1 = self.lesionNumber.text;
    // validate temp with NSNumberFormatter numberFromString
    NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
    NSNumber *number1 = [formatter1 numberFromString:temp1];
    if (number1 == Nil) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Target Lesion Number is not numeric"
                       message:@"Please enter a valid lesion number"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }

    
    NSString *temp = self.lesionSize.text;
    // validate temp with NSNumberFormatter numberFromString
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:temp];
    if (number == Nil) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Target Lesion Size is not numeric" 
                       message:@"Please enter a valid lesion size" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;

    }
    NSString *targetLesionOn = @"N";
    if (self.targetLesion.on) targetLesionOn = @"Y";
    NSString *mediaOn = @"N";
    if (self.lesionMediaOnline.on) mediaOn = @"Y";
    NSString *myNode = @"N";
    if (self.lesionLymphNode.on) myNode = @"Y";
    
    // if lesion is a lymph node and size is < 15 give a warning
    int mysize = [number intValue];
    if ( (mysize < 15) && (self.lesionLymphNode.on) ) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Warning - Lymph nodes normally need to be at least 15mm."
                       message:@"Lymph node will still be recorded with your size."
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
    }
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *myNumber = [f numberFromString:self.lesionNumber.text];
    NSNumberFormatter * f2 = [[NSNumberFormatter alloc] init];
    [f2 setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *myNumber2 = [f2 numberFromString:self.lesionSize.text];
    NSString *media = self.mediaInput.text;
    media = [media stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [outputFormatter stringFromDate:[[SharedObject sharedTeamData] getScanDate]];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    RKObjectMapping* myresults = [RKObjectMapping mappingForClass:[Results class]];
    [myresults mapKeyPath:@"succeed" toAttribute:@"succeed"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:myresults forKeyPath:@"team.results"];

    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"patient_id",[[SharedObject sharedTeamData] getPatientID],
                                 @"scan_date",newDateString,
                                 @"lesion_number",myNumber,
                                 @"lesion_size",[myNumber2 description],
                                 @"lesion_comment",comment,
                                 @"lesion_target",targetLesionOn,
                                 @"lesion_media_type",media,
                                 @"lesion_media_online",mediaOn,
                                 @"lesion_node",myNode,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"addlesion";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamaddlesion.php" stringByAppendingQueryParameters:queryParams] delegate:self];
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
    self.patientName.text = [[SharedObject sharedTeamData] getPatientName];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM/dd/yy"];
    NSString *newDateString = [outputFormatter stringFromDate:[[SharedObject sharedTeamData] getScanDate]];
    self.scanDate.text = newDateString;
    self.mediaInput.text = @"jpg";
    self.lesionMediaOnline.on = NO;
    self.lesionLymphNode.on = NO;
    // set the filename 
    NSString *myID = [[SharedObject sharedTeamData] getPatientID];
    NSDateFormatter *outputFormatter2 = [[NSDateFormatter alloc] init];
    [outputFormatter2 setDateFormat:@"MMddyy"];
    NSString *newDateString2 = [outputFormatter2 stringFromDate:[[SharedObject sharedTeamData] getScanDate]];
    self.fileNameLabel.text = [[NSString alloc] initWithFormat:@"Image/File Name %@-%@-X.jpg",myID,newDateString2];
    // setup mediaArray for picker for file type (jpg, png, mov etc.
    self.mediaArray = [[NSMutableArray alloc] initWithObjects:@"Choose Image Type",@"jpg",@"png",@"pdf",@"doc", nil];
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
    [self setPatientName:nil];
    [self setScanDate:nil];
    [self setLesionNumber:nil];
    [self setLesionSize:nil];
    [self setLesionComment:nil];
    [self setTargetLesion:nil];
    [self setFileNameLabel:nil];
    [self setLesionMediaOnline:nil];
    [self setMediaInput:nil];
    [self setLesionLymphNode:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
