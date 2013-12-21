//
//  LesionEdit.m
//  Team
//
//  Created by Tom Owen on 6/6/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "LesionEdit.h"

@interface LesionEdit ()

@end

@implementation LesionEdit
@synthesize callBack = _callBack;
@synthesize manager = _manager;
@synthesize targetLesionLabel = _targetLesionLabel;
@synthesize imageLesionLabek = _imageLesionLabek;
@synthesize viewMovieButton = _viewMovieButton;
@synthesize lesionStepper = _lesionStepper;
@synthesize viewImageButton = _viewImageButton;
@synthesize lesionMediaOnline = _lesionMediaOnline;
@synthesize fileNameLabel = _fileNameLabel;
@synthesize lesionLymphNode = _lesionLymphNode;
@synthesize mediaPickerView = _mediaPickerView;
@synthesize mediaArray = _mediaArray;
@synthesize scanDate = _scanDate;
@synthesize patientName = _patientName;
@synthesize lesionNumber = _lesionNumber;
@synthesize lesionSize = _lesionSize;
@synthesize lesionComment = _lesionComment;
@synthesize fileTypeLabel = _fileTypeLabel;
@synthesize lymphNodeLabel = _lymphNodeLabel;
@synthesize mediaInput = _mediaInput;
@synthesize targetLesion = _targetLesion;
@synthesize statusNewLabel = _statusNewLabel;

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)setImageAndMovieButtonState{
    if (!self.lesionMediaOnline.on) {
        self.viewImageButton.hidden = YES;
        self.viewMovieButton.hidden = YES;
        return;
    }
    // determine which button to show based upon media type
    if ([self.mediaInput.text isEqualToString:@"jpg"] ||
        [self.mediaInput.text isEqualToString:@"png"] ||
        [self.mediaInput.text isEqualToString:@"pdf"] ||
        [self.mediaInput.text isEqualToString:@"doc"]) {
        self.viewImageButton.hidden = NO;
        self.viewMovieButton.hidden = YES;
    }
    if ([self.mediaInput.text isEqualToString:@"mov"] ||
        [self.mediaInput.text isEqualToString:@"mp4"] ||
        [self.mediaInput.text isEqualToString:@"mpv"] ||
        [self.mediaInput.text isEqualToString:@"mp3"]) {
        self.viewImageButton.hidden = YES;
        self.viewMovieButton.hidden = NO;
    }
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"getonelesion"]) {
        [self checkLesionResults:objects];
        return;
    }
    if ([self.callBack isEqualToString:@"updatelesion"]) {
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
- (void) checkLesionResults:(NSArray *)objects {
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
    LesionMap* lesion = [objects objectAtIndex:0];
    //NSLog(@"lesion Teamid is %@",lesion.lesionTeamid);
    if ([lesion.lesionTeamid isEqualToNumber:[NSNumber numberWithInt:0]]) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Could not retrieve that lesion"
                       message:@"Lesion may have been deleted, or maybe a TEAM DB problem."
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
        
    }
    // now display all that lesion data
    NSNumber *mySize = lesion.lesionSize;
    NSString *myTarget = lesion.lesionTarget;
    [self.targetLesion setOn:NO animated:YES];
    //NSLog(@"mytarget = *%@*",myTarget);
    if ([myTarget isEqualToString:@"Y"]) {
        [self.targetLesion setOn:YES animated:YES];
        //NSLog(@"set switch on");
    } else {
        [self.targetLesion setOn:NO animated:YES];
        //NSLog(@"set switch off");
    }
    NSString *myNode = lesion.lesionNode;
    [self.lesionLymphNode setOn:NO animated:YES];
    //NSLog(@"mytarget = *%@*",myTarget);
    if ([myNode isEqualToString:@"Y"]) {
        [self.lesionLymphNode setOn:YES animated:YES];
        //NSLog(@"set switch on");
    } else {
        [self.lesionLymphNode setOn:NO animated:YES];
        //NSLog(@"set switch off");
    }
    
    
    NSString *mediaTypeIn = lesion.lesionMediaType;
    
    // set this in singleton as mediatypetodisplay
    
    
    self.mediaInput.text = mediaTypeIn;
    [[SharedObject sharedTeamData] setImageExt1:mediaTypeIn];
    NSString *mediaOnline = lesion.lesionMediaOnline;
    if ([mediaOnline isEqualToString:@"Y"]) {
        [self.lesionMediaOnline setOn:YES animated:YES];
    } else {
        [self.lesionMediaOnline setOn:NO animated:YES];
    }
    
    // set uistepper
    self.lesionStepper.value = [mySize doubleValue];
   // NSString *myComment = lesion.lesionComment;
    
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *formattedNumberString = [numberFormatter stringFromNumber:mySize];
    
    //NSLog(@"formattedNumberString: %@", formattedNumberString);
    self.lesionSize.text = formattedNumberString;
    
    
    
    //self.lesionSize.text = [[objects valueForKey:@"lesion_size"] objectAtIndex:0];
    self.lesionComment.text = lesion.lesionComment;
    //NSString *temp1 = [[objects valueForKey:@"lesion_size"] objectAtIndex:0];
    //NSLog(@"temp1 = %@",temp1);
    
    //NSLog(@"setting size and comment,%@,%@",mySize,myComment);
    [self createAndSetFileName];

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
                       initWithTitle: @"Could not update that scan"
                       message:@"Scan may have been deleted, or maybe a TEAM DB problem."
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
        
    }
    NSString *display = [NSString stringWithFormat:@"Lesion %@ successfully changed",[[SharedObject sharedTeamData] getLesionNumber]];
    [self.statusNewLabel setText:display];
    [[SharedObject sharedTeamData] setImageExt1:self.mediaInput.text];
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
    [self createAndSetFileName];
    [[SharedObject sharedTeamData] setMediaType:self.mediaInput.text];
    }
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSLog(@"row selected %d",row);
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
-(void)createAndSetFileName{
    // set the filename 
    NSString *myID = [[SharedObject sharedTeamData] getPatientID];
    NSDateFormatter *outputFormatter2 = [[NSDateFormatter alloc] init];
    [outputFormatter2 setDateFormat:@"MMddyy"];
    NSString *newDateString2 = [outputFormatter2 stringFromDate:[[SharedObject sharedTeamData] getScanDate]];
    
    NSNumber *mynumber = [[SharedObject sharedTeamData] getLesionNumber];
    NSString *mynum = [[NSString alloc] initWithFormat:@"%@",mynumber];
    //self.lesionNumber.text = [NSString stringWithFormat:@"Lesion #%@",[mynumber description]];
    
    self.fileNameLabel.text = [[NSString alloc] initWithFormat:@"Image/File Name %@-%@-%@.%@",myID,newDateString2,mynum,self.mediaInput.text];
    [self setImageAndMovieButtonState];
}
-(void)setSizeAndComment{
    // teamgetlesion.php
    //NSPredicate *pred = [NSPredicate predicateWithFormat:@"(lesion_patient_id = %@) and (lesion_scan_date = %@) and (lesion_number = %@)", lesionPatientId,lesionScanDate,lesionNumber];
    NSNumber *mynumber = [[SharedObject sharedTeamData] getLesionNumber];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    RKObjectMapping* lesion = [RKObjectMapping mappingForClass:[LesionMap class]];
    [lesion mapKeyPath:@"lesion_teamid" toAttribute:@"lesionTeamid"];
    [lesion mapKeyPath:@"lesion_number" toAttribute:@"lesionNumber"];
    [lesion mapKeyPath:@"lesion_size" toAttribute:@"lesionSize"];
    [lesion mapKeyPath:@"lesion_comment" toAttribute:@"lesionComment"];
    [lesion mapKeyPath:@"lesion_target" toAttribute:@"lesionTarget"];
    [lesion mapKeyPath:@"lesion_media_type" toAttribute:@"lesionMediaType"];
    [lesion mapKeyPath:@"lesion_media_online" toAttribute:@"lesionMediaOnline"];
    [lesion mapKeyPath:@"lesion_node" toAttribute:@"lesionNode"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:lesion forKeyPath:@"team.lesion"];
    // get date
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [outputFormatter stringFromDate:[[SharedObject sharedTeamData] getScanDate]];
    //NSLog(@"Updating repor flag for teamid %@,date %@,number %@",myid,newDateString,mynumber);
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"patient_id",[[SharedObject sharedTeamData] getPatientID],
                                 @"scan_date",newDateString,
                                 @"lesion_number",mynumber,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"getonelesion";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamgetonelesion.php" stringByAppendingQueryParameters:queryParams] delegate:self];
}
- (IBAction)saveLesion:(UIBarButtonItem *)sender {
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
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSNumber *mynumber = [[SharedObject sharedTeamData] getLesionNumber];
    RKObjectMapping* myresults = [RKObjectMapping mappingForClass:[Results class]];
    [myresults mapKeyPath:@"succeed" toAttribute:@"succeed"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:myresults forKeyPath:@"team.results"];
    // get date
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [outputFormatter stringFromDate:[[SharedObject sharedTeamData] getScanDate]];
    //NSLog(@"Updating lesion for teamid %@,date %@",myid,newDateString);
    NSString *targetLesionOn = @"N";
    if (self.targetLesion.on) targetLesionOn = @"Y";
    NSString *mediaOn = @"N";
    if (self.lesionMediaOnline.on) mediaOn = @"Y";
    NSString *myNode = @"N";
    if (self.lesionLymphNode.on) myNode = @"Y";
    
        
    
    if ([self.lesionComment.text length] < 1) self.lesionComment.text = @"n/a";
    if ([self.mediaInput.text length] < 1) self.mediaInput.text = @"n/a";
    NSString *comment = self.lesionComment.text;
    comment = [comment stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSString *media = self.mediaInput.text;
    media = [media stringByReplacingOccurrencesOfString:@"'" withString:@" "];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"patient_id",[[SharedObject sharedTeamData] getPatientID],
                                 @"scan_date",newDateString,
                                 @"lesion_number",mynumber,
                                 @"lesion_size",self.lesionSize.text,
                                 @"lesion_comment",comment,
                                 @"lesion_target",targetLesionOn,
                                 @"lesion_media_type",media,
                                 @"lesion_media_online",mediaOn,
                                 @"lesion_node",myNode,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"updatelesion";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamupdatelesion.php" stringByAppendingQueryParameters:queryParams] delegate:self];
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
    NSNumber *mynumber = [[SharedObject sharedTeamData] getLesionNumber];
    self.lesionNumber.text = [NSString stringWithFormat:@"Lesion #%@",[mynumber description]];
    
    
    
    
    // setup mediaArray for picker for file type (jpg, png, mov etc.
    self.mediaArray = [[NSMutableArray alloc] initWithObjects:@"Choose Image Type",@"jpg",@"png",@"pdf",@"doc", nil];
    //[[SharedObject sharedTeamData] setMediaType:self.mediaInput.text];
    // change view for non admin users
    if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"N"]) {
        self.navigationItem.rightBarButtonItem = Nil;
        self.statusNewLabel.text = @"";
        self.lesionComment.enabled = NO;
        self.lesionComment.borderStyle = UITextBorderStyleNone;
        self.lesionSize.enabled = NO;
        self.lesionSize.borderStyle = UITextBorderStyleNone;
        self.lesionStepper.hidden = YES;
        self.targetLesionLabel.text = @"This is a Non Target Lesion";
        if (self.targetLesion.isOn) {
            self.targetLesionLabel.text = @"This is a Target Lesion";
        }
        self.lesionLymphNode.hidden = YES;
        self.lymphNodeLabel.text = @"";
        if (self.lesionLymphNode.isOn) {
                self.lymphNodeLabel.text = @"This is a Lymph Node";
        }
        
        self.targetLesion.hidden = YES;
        self.imageLesionLabek.hidden = YES;
        self.lesionMediaOnline.hidden = YES;
        self.fileNameLabel.hidden = YES;
        self.mediaInput.hidden = YES;
        self.fileTypeLabel.hidden = YES;
        
    }
    if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"Y"]) {
        self.mediaInput.textColor = [UIColor blackColor];
        self.lesionSize.textColor = [UIColor blackColor];
        self.lesionComment.textColor = [UIColor blackColor];
    }
    /*
    NSString *fullURL = [[NSString alloc] initWithFormat:@"http://%@",[[SharedObject sharedTeamData] getDb_server]];
    NSURL *url = [[NSURL alloc] initWithString:fullURL];
    //NSURL *url = [[NSURL alloc] initWithString:[[SharedObject sharedTeamData] getDb_server]];
    self.manager = [RKObjectManager objectManagerWithBaseURL:url];
    self.manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    self.manager.client.username = [[SharedObject sharedTeamData] getDbUser];
    self.manager.client.password = [[SharedObject sharedTeamData] getDbPassword];
    */
    /*
    RKLogConfigureByName("RestKit", RKLogLevelWarning);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    */
    [self setSizeAndComment];
    //NSString *image_type = [[SharedObject sharedTeamData] getMediaType];
    //NSLog(@"image_type lesion edit=%@",image_type);
    
}
-(void)viewDidAppear:(BOOL)animated
{
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
    [self setLesionNumber:nil];
    [self setLesionStepper:nil];
    [self setTargetLesion:nil];
    [self setMediaInput:nil];
    [self setLesionMediaOnline:nil];
    [self setFileNameLabel:nil];
    [self setViewImageButton:nil];
    [self setViewMovieButton:nil];
    [self setTargetLesionLabel:nil];
    [self setImageLesionLabek:nil];
    [self setFileTypeLabel:nil];
    [self setLesionLymphNode:nil];
    [self setLymphNodeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (IBAction)imageMovieSwichPressed:(UISwitch *)sender {
    if (!self.lesionMediaOnline.on) {
        self.viewImageButton.hidden = YES;
        self.viewMovieButton.hidden = YES;
    }
    [self setImageAndMovieButtonState];

}

@end
