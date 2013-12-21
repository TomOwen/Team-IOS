//
//  TeamResponse.m
//  Team
//
//  Created by Tom Owen on 10/14/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "TeamResponse.h"

@interface TeamResponse ()

@end

@implementation TeamResponse
@synthesize responseXML = _responseXML;
@synthesize happyFace = _happyFace;
@synthesize nameAndScanDateLabel = _nameAndScanDateLabel;
@synthesize line1Overall = _line1Overall;
@synthesize line2TargetOverall = _line2TargetOverall;
@synthesize line3TargetBase = _line3TargetBase;
@synthesize line4TargetSmall = _line4TargetSmall;
@synthesize line5NonTargetOverall = _line5NonTargetOverall;
@synthesize line6NonTargetBase = _line6NonTargetBase;
@synthesize line7NonTargetSmall = _line7NonTargetSmall;
@synthesize tableView = _tableView;
@synthesize showHideButton = _showHideButton;
@synthesize lymphFootNote = _lymphFootNote;
@synthesize savePatientName = _savePatientName;
@synthesize lesionsHidden = _lesionsHidden;

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
    self.lymphFootNote.hidden = YES;
    self.happyFace.hidden = YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.hidden = NO;
    } else {
        self.tableView.hidden = YES;
        self.lesionsHidden = YES;
    }
    
    [self getResponse];
}
- (void) checkResponseResults:(NSArray *)objects {
    // if no objects returned ..... probably a server error
    int count = [objects count];
    //NSLog(@"object count = %d",count);
    if (count == 0) {
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
    // now lets process the first entry for all the 8 lines in header
    self.responseXML = objects;
    ResponseMap *response = [objects objectAtIndex:0];
    self.savePatientName = response.patient_name;
    // scan date will get filled in from lesion data in table load
    
    // header
    //NSLog(@"patient_name = %@",self.savePatientName);
    self.nameAndScanDateLabel.text = [[NSString alloc] initWithFormat:@"%@ - No Scans Yet",response.patient_name];
    
    // line1
    self.line1Overall.text = [[NSString alloc] initWithFormat:@"Overall Response - %@",response.overall_response_code];
    if ([response.overall_response_code isEqualToString:@"CR"]) {
        self.line1Overall.text = @"Overall Response - Complete Response";
        self.line1Overall.textColor = [UIColor greenColor]; }
    if ([response.overall_response_code isEqualToString:@"PD"]) {
        self.line1Overall.text = @"Overall Response - Progressive Disease";
        self.line1Overall.textColor = [UIColor redColor];}
    if ([response.overall_response_code isEqualToString:@"PR"]) {
        self.line1Overall.text = @"Overall Response - Partial Response";
        self.line1Overall.textColor = [UIColor yellowColor];}
    if ([response.overall_response_code isEqualToString:@"SD"]) {
        self.line1Overall.text = @"Overall Response - Stable Disease";
        self.line1Overall.textColor = [UIColor whiteColor];}
    
    // line 2
    self.line2TargetOverall.text = [[NSString alloc] initWithFormat:@"Target Response: %@",response.target_response_code];
    if ([response.target_response_code isEqualToString:@"CR"]) self.line2TargetOverall.textColor = [UIColor greenColor];
    if ([response.target_response_code isEqualToString:@"PD"]) self.line2TargetOverall.textColor = [UIColor redColor];
    if ([response.target_response_code isEqualToString:@"PR"]) self.line2TargetOverall.textColor = [UIColor yellowColor];
    if ([response.target_response_code isEqualToString:@"SD"]) self.line2TargetOverall.textColor = [UIColor whiteColor];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    
    // line 3
    NSNumber * myNumber = [f numberFromString:response.tb_percent_change];
    NSString *plusMinus = @"+";
    if ([myNumber doubleValue] < 0) plusMinus = @"";
    self.line3TargetBase.text = [[NSString alloc] initWithFormat:@"Current %@mm Baseline %@mm %@%@%% %@",response.tc_total_size,response.tb_total_size,plusMinus,response.tb_percent_change,response.tb_response];
    
    // line 4
    
    myNumber = [f numberFromString:response.ts_percent_change];
    plusMinus = @"+";
    if ([myNumber doubleValue] < 0) plusMinus = @"";
    self.line4TargetSmall.text = [[NSString alloc] initWithFormat:@"Current %@mm Smallest %@mm %@%@%% %@",response.tc_total_size,response.ts_total_size,plusMinus,response.ts_percent_change,response.ts_response];
    
    // line 5
    self.line5NonTargetOverall.text = [[NSString alloc] initWithFormat:@"Non Target Response: %@",response.non_target_response_code];
    if ([response.non_target_response_code isEqualToString:@"CR"]) self.line5NonTargetOverall.textColor = [UIColor greenColor];
    if ([response.non_target_response_code isEqualToString:@"PD"]) self.line5NonTargetOverall.textColor = [UIColor redColor];
    if ([response.non_target_response_code isEqualToString:@"PR"]) self.line5NonTargetOverall.textColor = [UIColor yellowColor];
    if ([response.non_target_response_code isEqualToString:@"SD"]) self.line5NonTargetOverall.textColor = [UIColor whiteColor];
    
    // line 6
    myNumber = [f numberFromString:response.ntb_percent_change];
    plusMinus = @"+";
    if ([myNumber doubleValue] < 0) plusMinus = @"";
    self.line6NonTargetBase.text = [[NSString alloc] initWithFormat:@"Current %@mm Baseline %@mm %@%@%% %@",response.ntc_total_size,response.ntb_total_size,plusMinus,response.ntb_percent_change,response.ntb_response];
    
    // line 7
    myNumber = [f numberFromString:response.nts_percent_change];
    plusMinus = @"+";
    if ([myNumber doubleValue] < 0) plusMinus = @"";
    self.line7NonTargetSmall.text = [[NSString alloc] initWithFormat:@"Current %@mm Smallest %@mm %@%@%% %@",response.ntc_total_size,response.nts_total_size,plusMinus,response.nts_percent_change,response.nts_response];
    
    [self.tableView reloadData];
}

-(void)getResponse
{
    // set up mapping
    RKObjectMapping* response = [RKObjectMapping mappingForClass:[ResponseMap class]];
    [response mapKeyPath:@"patient_name" toAttribute:@"patient_name"];
    [response mapKeyPath:@"patient_id" toAttribute:@"patient_id"];
    [response mapKeyPath:@"patient_doctor" toAttribute:@"patient_doctor"];
    [response mapKeyPath:@"patient_study_id" toAttribute:@"patient_study_id"];
    [response mapKeyPath:@"study_owner" toAttribute:@"study_owner"];
    [response mapKeyPath:@"study_name" toAttribute:@"study_name"];
    [response mapKeyPath:@"study_percentpr" toAttribute:@"study_percentpr"];
    [response mapKeyPath:@"study_percentpd" toAttribute:@"study_percentpd"];
    [response mapKeyPath:@"overall_response_code" toAttribute:@"overall_response_code"];
    [response mapKeyPath:@"target_response_code" toAttribute:@"target_response_code"];
    [response mapKeyPath:@"tc_total_size" toAttribute:@"tc_total_size"];
    [response mapKeyPath:@"tb_total_size" toAttribute:@"tb_total_size"];
    [response mapKeyPath:@"tb_percent_change" toAttribute:@"tb_percent_change"];
    [response mapKeyPath:@"tb_response" toAttribute:@"tb_response"];
    [response mapKeyPath:@"ts_total_size" toAttribute:@"ts_total_size"];
    [response mapKeyPath:@"ts_percent_change" toAttribute:@"ts_percent_change"];
    [response mapKeyPath:@"ts_response" toAttribute:@"ts_response"];
    [response mapKeyPath:@"non_target_response_code" toAttribute:@"non_target_response_code"];
    [response mapKeyPath:@"ntc_total_size" toAttribute:@"ntc_total_size"];
    [response mapKeyPath:@"ntb_total_size" toAttribute:@"ntb_total_size"];
    [response mapKeyPath:@"ntb_percent_change" toAttribute:@"ntb_percent_change"];
    [response mapKeyPath:@"ntb_response" toAttribute:@"ntb_response"];
    [response mapKeyPath:@"nts_total_size" toAttribute:@"nts_total_size"];
    [response mapKeyPath:@"nts_percent_change" toAttribute:@"nts_percent_change"];
    [response mapKeyPath:@"nts_response" toAttribute:@"nts_response"];
    [response mapKeyPath:@"lesion_number" toAttribute:@"lesion_number"];
    [response mapKeyPath:@"lesion_target" toAttribute:@"lesion_target"];
    [response mapKeyPath:@"current_size" toAttribute:@"current_size"];
    [response mapKeyPath:@"baseline_size" toAttribute:@"baseline_size"];
    [response mapKeyPath:@"baseline_date" toAttribute:@"baseline_date"];
    [response mapKeyPath:@"current_date" toAttribute:@"current_date"];
    [response mapKeyPath:@"baseline_percent_change" toAttribute:@"baseline_percent_change"];
    [response mapKeyPath:@"smallest_date" toAttribute:@"smallest_date"];
    [response mapKeyPath:@"smallest_size" toAttribute:@"smallest_size"];
    [response mapKeyPath:@"smallest_percent_change" toAttribute:@"smallest_percent_change"];
    [response mapKeyPath:@"new_lesion" toAttribute:@"isnew_lesion"];
    [response mapKeyPath:@"lesion_node" toAttribute:@"lesion_node"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:response forKeyPath:@"team.lesion"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"patient_id",[[SharedObject sharedTeamData] getPatientID],
                                 @"xmloption",@"Y",
                                 nil];
    self.callBack = @"getresponse";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamresponse.php" stringByAppendingQueryParameters:queryParams] delegate:self];
}


- (void)viewDidUnload
{
    [self setHappyFace:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"getresponse"]) {
        [self checkResponseResults:objects];
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
// table delagates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // number of lesions in the xml feed is count minus 1, first
    // <lesion> mapping contains overall response data
    int mycount = [self.responseXML count];
    mycount--; //
    if (mycount < 0) {
        //NSLog(@"count < 0.....");
        mycount = 0;
    }
    return mycount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor]; //must do here in willDisplayCell
    cell.textLabel.backgroundColor = [UIColor whiteColor]; //must do here in willDisplayCell
}
-(NSString *)formatLineOne:(int)section {
    //Baseline on mm/dd/yy was 25mm now +100
    ResponseMap *response = [self.responseXML objectAtIndex:section];
    NSString *checkNode = response.lesion_node;
    NSString *baseLineDate = response.baseline_date;
    NSString *currentDate = response.current_date;
    self.nameAndScanDateLabel.text = [[NSString alloc] initWithFormat:@"%@ - Current Scans On %@",self.savePatientName,currentDate];
    NSString *baseLineSize = response.baseline_size;
    NSString *percentChange = response.baseline_percent_change;
    NSString *isNew = response.isnew_lesion;
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:percentChange];
    NSString *plusMinus = @"+";
    if ([myNumber doubleValue] < 0) plusMinus = @"";
    NSString *myNode = @"*";
    if ([checkNode isEqualToString:@"N"]) {
        myNode = @"";
    }
    if ([checkNode isEqualToString:@"Y"]) {
        self.lymphFootNote.hidden = NO;
    }
    NSString *line1Format = [[NSString alloc] initWithFormat:@"Baseline on %@ was %@mm (now %@%@%%)%@",baseLineDate,baseLineSize,plusMinus,percentChange,myNode];
    if ([isNew isEqualToString:@"Y"]) {
        line1Format = @"New Lesion";
    }
    return line1Format;
}
-(NSString *)formatLineTwo:(int)section {
    //Baseline on mm/dd/yy was 25mm now +100
    ResponseMap *response = [self.responseXML objectAtIndex:section];
    NSString *isNew = response.isnew_lesion;
    NSString *formatLineTwo = @"";
    if ([isNew isEqualToString:@"Y"]) {
        formatLineTwo = @"";
    } else {
        // configure second line
        NSString *smallestDate = response.smallest_date;
        NSString *smallestSize = response.smallest_size;
        NSString *percentChange = response.smallest_percent_change;
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * myNumber = [f numberFromString:percentChange];
        NSString *plusMinus = @"+";
        if ([myNumber doubleValue] < 0) plusMinus = @"";
        NSString *checkNode = response.lesion_node;
        NSString *myNode = @"*";
        if ([checkNode isEqualToString:@"N"]) {
            myNode = @"";
        }
        if ([checkNode isEqualToString:@"Y"]) {
            self.lymphFootNote.hidden = NO;
        }
        formatLineTwo = [[NSString alloc] initWithFormat:@"Smallest on %@ was %@mm (now %@%@%%)%@",smallestDate,smallestSize,plusMinus,percentChange,myNode];
    }
    return formatLineTwo;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"teamCell";
    int myindex = indexPath.section +1; // entry into responseXML for lesion data
    int myRow = indexPath.row;
    //NSLog(@"indexpath section is %d and row is %d",myindex,myRow);
    // mysection is the entry to currentlesions
    // myrow is either 0 or 1 for line 1 or 2
    NSString *formattedString = @"";
    if (myRow == 0) {
        formattedString = [self formatLineOne:myindex];
        //formattedString = @"Baseline on 12/31/12 was 25mm now +100%";
    } else {
        formattedString = [self formatLineTwo:myindex];
        //formattedString = @"Smallest on 10/24/12 was 20mm now +100%";
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = formattedString;
    cell.textLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:14];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    // need to add one to index
    int myindex = section +1;
    ResponseMap *response = [self.responseXML objectAtIndex:myindex];
    NSString *headerString = @"Current";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        headerString = @"Current Size is";
    }
    NSString *myTarget = response.lesion_target;
    NSString *mySize = response.current_size;
    NSString *myNumber = response.lesion_number;
    NSString *typeOfLesion = @"";
    if ([myTarget isEqualToString:@"Y"]) {
        typeOfLesion = @"Target #";
    } else {
        typeOfLesion = @"Non Target #";
    }
    NSString *lesionHeader = [[NSString alloc] initWithFormat:@"%@%@ %@ %@mm", typeOfLesion,myNumber,headerString,mySize];
    
    
    //return heading2;
    UILabel *myHeader = [[UILabel alloc] init];
    myHeader.text = lesionHeader;
    
    myHeader.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:14];
    return lesionHeader;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // segue to before and after image
}
- (IBAction)showHideLesions:(UIButton *)sender {
    if (self.lesionsHidden) {
        self.lesionsHidden = NO;
        self.tableView.hidden = NO;
        [self.showHideButton setTitle:@"Hide Lesions" forState:(UIControlState)UIControlStateNormal];
    } else {
        self.lesionsHidden = YES;
        self.tableView.hidden = YES;
        [self.showHideButton setTitle:@"Show Lesions" forState:(UIControlState)UIControlStateNormal];
    }
    
}

@end
