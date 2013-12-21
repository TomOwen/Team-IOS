//
//  ScanEdit.m
//  Team
//
//  Created by Tom Owen on 6/6/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "ScanEdit.h"

@interface ScanEdit ()

@end

@implementation ScanEdit
@synthesize currentLesions = _currentLesions;
@synthesize callBack = _callBack;
@synthesize manager = _manager;
@synthesize onlineScanReport = _onlineScanReport;
@synthesize scanReportLabel = _scanReportLabel;
@synthesize viewReportButton = _viewReportButton;
@synthesize scanReportFileName = _scanReportFileName;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"getreportparams"]) {
        [self checkReportResults:objects];
        return;
    }
    if ([self.callBack isEqualToString:@"getlesions"]) {
        [self checkLesionResults:objects];
        return;
    }
    if ([self.callBack isEqualToString:@"deletelesion"]) {
        [self checkDeleteResults:objects];
        return;
    }
    if ([self.callBack isEqualToString:@"updatereport"]) {
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
}

- (void) checkReportResults:(NSArray *)objects {
    int count = [objects count];
    if (count) {
        ReportParamsMap* scan = [objects objectAtIndex:0];
        if ([scan.teamid isEqualToNumber:[NSNumber numberWithInt:0]]) {
            return;
        } else {
            // get onlineindicator from xmln
            NSString *onlineIndicator = scan.scanReportOnline;
            self.onlineScanReport.on = NO;
            self.viewReportButton.hidden = YES;
            if ([onlineIndicator isEqualToString:@"Y"]) {
                self.onlineScanReport.on = YES;
                self.viewReportButton.hidden = NO;
            }
            NSString *docType = scan.docType;
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"MMddyy"];
            NSString *newDateString = [outputFormatter stringFromDate:[[SharedObject sharedTeamData] getScanDate]];
            NSString *filename = [[NSString alloc] initWithFormat:@"File Name:%@-%@.%@",[[SharedObject sharedTeamData] getPatientID],newDateString,docType];
            self.scanReportFileName.text = filename;
            if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"N"]) {
                self.scanReportFileName.text = @"";
            }

            return;
        }
    }
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"Could not reach the TEAM server!"
                   message:@"Please contact TEAM support or check your internet connection"
                   delegate: nil
                   cancelButtonTitle: @"Ok"
                   otherButtonTitles: nil];
    [alertDialog show];
}

- (void) checkLesionResults:(NSArray *)objects {
    int count = [objects count];
    if (count) {
        LesionMap* lesion = [objects objectAtIndex:0];
        if ([lesion.lesionTeamid isEqualToNumber:[NSNumber numberWithInt:0]]) {
            self.currentLesions = Nil;
            [self.tableView reloadData];
            self.tableView.allowsSelection = YES;
            self.tableView.scrollEnabled = YES;
            [self getReportParams];
            return;
        } else {
            self.currentLesions = objects;
            [self.tableView reloadData];
            self.tableView.allowsSelection = YES;
            self.tableView.scrollEnabled = YES;
            [self getReportParams];
            return;
        }
    }
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"Could not reach the TEAM server!"
                   message:@"Please contact TEAM support or check your internet connection"
                   delegate: nil
                   cancelButtonTitle: @"Ok"
                   otherButtonTitles: nil];
    [alertDialog show];
}
- (void) checkDeleteResults:(NSArray *)objects {
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
                       initWithTitle: @"Could not delete that scan"
                       message:@"Patient may have been deleted, or maybe a TEAM DB problem."
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
        
    }
    [self readAllLesions];
}
- (void)getReportParams {
    // set up mapping
    RKObjectMapping* reportmap = [RKObjectMapping mappingForClass:[ReportParamsMap class]];
    [reportmap mapKeyPath:@"report_teamid" toAttribute:@"teamid"];
    [reportmap mapKeyPath:@"scan_report_online" toAttribute:@"scanReportOnline"];
    [reportmap mapKeyPath:@"doc_type" toAttribute:@"docType"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:reportmap forKeyPath:@"team.report"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [outputFormatter stringFromDate:[[SharedObject sharedTeamData] getScanDate]];

    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"patient_id",[[SharedObject sharedTeamData] getPatientID],
                                 @"scan_date",newDateString,
                                 nil];
    self.callBack = @"getreportparams";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamgetreportparams.php" stringByAppendingQueryParameters:queryParams] delegate:self];
}

- (void)readAllLesions {
    // set up mapping
    RKObjectMapping* lesionMapping = [RKObjectMapping mappingForClass:[LesionMap class]];
    [lesionMapping mapKeyPath:@"lesion_teamid" toAttribute:@"lesionTeamid"];
    [lesionMapping mapKeyPath:@"lesion_patient_id" toAttribute:@"lesionPatientID"];
    [lesionMapping mapKeyPath:@"lesion_scan_date" toAttribute:@"lesionScanDate"];
    [lesionMapping mapKeyPath:@"lesion_number" toAttribute:@"lesionNumber"];
    [lesionMapping mapKeyPath:@"lesion_size" toAttribute:@"lesionSize"];
    [lesionMapping mapKeyPath:@"lesion_comment" toAttribute:@"lesionComment"];
    [lesionMapping mapKeyPath:@"lesion_target" toAttribute:@"lesionTarget"];
    [lesionMapping mapKeyPath:@"lesion_media_type" toAttribute:@"lesionMediaType"];
    [lesionMapping mapKeyPath:@"lesion_media_onlne" toAttribute:@"lesionMediaOnline"];
    [lesionMapping mapKeyPath:@"lesion_node" toAttribute:@"lesionNode"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:lesionMapping forKeyPath:@"team.lesion"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [outputFormatter stringFromDate:[[SharedObject sharedTeamData] getScanDate]];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"patient_id",[[SharedObject sharedTeamData] getPatientID],
                                 @"scan_date",newDateString,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"getlesions";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamgetlesions.php" stringByAppendingQueryParameters:queryParams] delegate:self];
}
-(void)viewDidAppear:(BOOL)animated{
    [self readAllLesions];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    /*
    NSString *fullURL = [[NSString alloc] initWithFormat:@"http://%@",[[SharedObject sharedTeamData] getDb_server]];
    NSURL *url = [[NSURL alloc] initWithString:fullURL];
    //NSURL *url = [[NSURL alloc] initWithString:[[SharedObject sharedTeamData] getDb_server]];
    self.manager = [RKObjectManager objectManagerWithBaseURL:url];
    self.manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    self.manager.client.username = [[SharedObject sharedTeamData] getDbUser];
    self.manager.client.password = [[SharedObject sharedTeamData] getDbPassword];
    */

    if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"N"]) {
        self.navigationItem.rightBarButtonItem = Nil;
        self.onlineScanReport.hidden = YES;
        self.scanReportLabel.text = @"";
    }
    //[self readAllLesions];
    //NSString *image_type = [[SharedObject sharedTeamData] getMediaType];
    //NSLog(@"image_type scan edit=%@",image_type);
    
}
#pragma mark - Scan Table delagates
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    LesionMap* lesion = [self.currentLesions objectAtIndex:indexPath.row];
    
    NSString *subTitle1 = [lesion.lesionNumber description];
    NSString *subTitle2 = [lesion.lesionSize description];
    NSString *subTitle3 = lesion.lesionComment;
    NSString *target = lesion.lesionTarget;
    NSString *typeOfLesion = @"NT"; // non target
    //NSLog(@"start typeoflesion at NT for #%@",subTitle1);
    if ([target isEqualToString:@"Y"]) {
        //NSLog(@"set typeoflesion to T");
        typeOfLesion = @"T";
    }
    //NSLog(@"after test typeoflesion is %@",typeOfLesion);
    cell.textLabel.text = [[NSString alloc] initWithFormat: @"Lesion %@%@ Size of Tumor %@ mm", typeOfLesion,subTitle1, subTitle2];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat: @"%@",subTitle3];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return [self.currentLesions count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"lesionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"N"]) {
        return NO;
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
        LesionMap* lesion = [self.currentLesions objectAtIndex:indexPath.row];
        
        RKObjectMapping* myresults = [RKObjectMapping mappingForClass:[Results class]];
        [myresults mapKeyPath:@"succeed" toAttribute:@"succeed"];
        [[RKObjectManager sharedManager].mappingProvider setMapping:myresults forKeyPath:@"team.results"];
        // get date
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *newDateString = [outputFormatter stringFromDate:[[SharedObject sharedTeamData] getScanDate]];
        //NSLog(@"Deleting lesion %@ for teamid %@,date %@",[lesion.lesionNumber description],myid,newDateString);
        NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                     @"teamid",myid,
                                     @"patient_id",[[SharedObject sharedTeamData] getPatientID],
                                     @"scan_date",newDateString,
                                     @"lesion_number",[lesion.lesionNumber description],
                                     @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                     nil];
        self.callBack = @"deletelesion";
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamdeletelesion.php" stringByAppendingQueryParameters:queryParams] delegate:self];
    }   
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM/dd/yy"];
    NSString *newDateString = [outputFormatter stringFromDate:[[SharedObject sharedTeamData] getScanDate]];
    NSString *heading = [[SharedObject sharedTeamData] getPatientName];
    NSString *heading2 = [[NSString alloc] initWithFormat:@"%@ on %@", heading,newDateString]; 
    return heading2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LesionMap* lesion = [self.currentLesions objectAtIndex:indexPath.row];
    // set lesion_number
    NSNumber *myNumber = lesion.lesionNumber;
    [[SharedObject sharedTeamData] setLesionNumber:myNumber];
    [self performSegueWithIdentifier:@"editLesion" sender:self];
    
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setOnlineScanReport:nil];
    [self setViewReportButton:nil];
    [self setScanReportLabel:nil];
    [self setScanReportFileName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)userSetOnlineReport:(UISwitch *)sender {
        // update db
        NSString *onlineIndicator = @"N";
        self.viewReportButton.hidden = YES;
        if (self.onlineScanReport.on) {
            onlineIndicator = @"Y";
            self.viewReportButton.hidden = NO;
        }
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    RKObjectMapping* myresults = [RKObjectMapping mappingForClass:[Results class]];
    [myresults mapKeyPath:@"succeed" toAttribute:@"succeed"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:myresults forKeyPath:@"team.results"];
    // get date
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [outputFormatter stringFromDate:[[SharedObject sharedTeamData] getScanDate]];
    //NSLog(@"Updating repor flag for teamid %@,date %@",myid,newDateString);
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"patient_id",[[SharedObject sharedTeamData] getPatientID],
                                 @"scan_date",newDateString,
                                 @"scan_report_online",onlineIndicator,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"updatereport";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamupdatereport.php" stringByAppendingQueryParameters:queryParams] delegate:self];
       
    
}
@end
