//
//  ScanDisplay.m
//  Team
//
//  Created by Tom Owen on 6/4/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "ScanDisplay.h"
#import "AppDelegate.h"
#import "Scan.h"


@interface ScanDisplay ()

@end

@implementation ScanDisplay
@synthesize manager = _manager;
@synthesize currentScans = _currentScans;
@synthesize callBack = _callBack;
@synthesize lesionsToDelete = _lesionsToDelete;
@synthesize patientID = _patientID;
@synthesize deleteChoice = _deleteChoice;
@synthesize myTableView = _myTableView;

static NSIndexPath *indexPathForDelete = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
   // NSLog(@"didloadobjects");
    if ([self.callBack isEqualToString:@"getscans"]) {
        [self checkScanResults:objects];
        return;
    }
    if ([self.callBack isEqualToString:@"deletescan"]) {
        [self checkDeleteResults:objects];
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
- (void) checkScanResults:(NSArray *)objects {
    //NSLog(@"checkscanresults");
    int count = [objects count];
    if (count) {
        ScanMap* scan = [objects objectAtIndex:0];
        if ([scan.scanTeamid isEqualToNumber:[NSNumber numberWithInt:0]]) {
            self.currentScans = Nil;
            [self.myTableView reloadData];
            self.myTableView.allowsSelection = YES;
            self.myTableView.scrollEnabled = YES;
            return;
        } else {
            self.currentScans = objects;
            [self.myTableView reloadData];
            self.myTableView.allowsSelection = YES;
            self.myTableView.scrollEnabled = YES;
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
    [self.myTableView reloadData];
    self.myTableView.allowsSelection = YES;
    self.myTableView.scrollEnabled = YES;
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
    [self readAllScans];
    [self.myTableView reloadData];
}

- (void)readAllScans {
    // first cancel all requests
    //NSLog(@"cancel requests first");
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
    // set up mapping
    //NSLog(@"readallscans");
    RKObjectMapping* scanMapping = [RKObjectMapping mappingForClass:[ScanMap class]];
    [scanMapping mapKeyPath:@"scan_teamid" toAttribute:@"scanTeamid"];
    [scanMapping mapKeyPath:@"scan_patient_id" toAttribute:@"scanPatientID"];
    [scanMapping mapKeyPath:@"scan_date" toAttribute:@"scanDate"];
    [scanMapping mapKeyPath:@"scan_report_online" toAttribute:@"scanReportOnline"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:scanMapping forKeyPath:@"team.scan"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"scan_patient_id",self.patientID,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                nil];
    self.callBack = @"getscans";
    //NSLog(@"call getscans");
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamgetscans.php" stringByAppendingQueryParameters:queryParams] delegate:self];
    //NSLog(@"aftercall getscans");
}

#pragma mark - Scan Table delagates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return [self.currentScans count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"scanCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    
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
- (void)readAndDeleteLesions:(NSString *)patient:(NSDate *)date{
    // read all lesions for this patient and date and delete them
    // set up context
    }
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
	//NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
       // NSLog(@"button is %d",buttonIndex);

    if (buttonIndex != 0) {
        return;
    }
    //NSLog(@"Deleting scan date and all lesions");
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    ScanMap* scan = [self.currentScans objectAtIndex:indexPathForDelete.row];
    
    RKObjectMapping* myresults = [RKObjectMapping mappingForClass:[Results class]];
    [myresults mapKeyPath:@"succeed" toAttribute:@"succeed"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:myresults forKeyPath:@"team.results"];
    // get date
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [outputFormatter stringFromDate:scan.scanDate];
    //NSLog(@"Deleting scan %@ for teamid %@,date %@",scan.scanPatientID,myid,newDateString);
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"scan_patient_id",scan.scanPatientID,
                                 @"scan_date",newDateString,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"deletescan";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamdeletescan.php" stringByAppendingQueryParameters:queryParams] delegate:self];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScanMap* scan = [self.currentScans objectAtIndex:indexPath.row];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM/dd/yy"];
    NSString *newDateString = [outputFormatter stringFromDate:scan.scanDate];
    NSString *title = [[NSString alloc] initWithFormat:@"Delete %@ and Lesions",newDateString];
    // prompt for delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIActionSheet *actionSheet;
        actionSheet=[[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"Cancel" 
                              destructiveButtonTitle:title
                                   otherButtonTitles:nil];
        actionSheet.actionSheetStyle=UIBarStyleBlackTranslucent;
        indexPathForDelete = indexPath;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];


    }
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}
- (void)viewWillAppear:(BOOL)animated{
    //NSLog(@"viewwillappear");
    [self readAllScans];
    [self.myTableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    //NSLog(@"viewwilldisappear");
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"viewdidload");
	// Do any additional setup after loading the view.
    if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"N"]) {
            //self.navigationItem.rightBarButtonItem = Nil;
    }

    // read all studies for display in table
    /*
    NSString *fullURL = [[NSString alloc] initWithFormat:@"http://%@",[[SharedObject sharedTeamData] getDb_server]];
    NSURL *url = [[NSURL alloc] initWithString:fullURL];
    //NSURL *url = [[NSURL alloc] initWithString:[[SharedObject sharedTeamData] getDb_server]];
    self.manager = [RKObjectManager objectManagerWithBaseURL:url];
    self.manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    self.manager.client.username = [[SharedObject sharedTeamData] getDbUser];
    self.manager.client.password = [[SharedObject sharedTeamData] getDbPassword];
    */
    // read all studies for display in table
    if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"N"]) {
        self.navigationItem.rightBarButtonItem = Nil;
    }
    self.patientID = [[SharedObject sharedTeamData] getPatientID];
    [self readAllScans];
    [self.myTableView reloadData];
    //NSString *image_type = [[SharedObject sharedTeamData] getMediaType];
    //NSLog(@"image_type from scan dispaly=%@",image_type);
    
}

- (void)viewDidAppear:(BOOL)animated{
    //NSLog(@"viewdidappear");
    //[self readAllScans];
    [super viewWillAppear:YES];
    [super viewWillAppear:animated];
    
}

- (void)viewDidUnload
{
    //NSLog(@"didunload");
    [self setMyTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ScanMap* scan = [self.currentScans objectAtIndex:indexPath.row];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    NSString *newDateString = [outputFormatter stringFromDate:scan.scanDate];
    //NSLog(@"date is %@",newDateString);
    cell.textLabel.text = newDateString;
    // set color
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScanMap* scan = [self.currentScans objectAtIndex:indexPath.row];
    [[SharedObject sharedTeamData] setScanDate:scan.scanDate];
    //NSLog(@"ScanDisplay row selected %@",[[SharedObject sharedTeamData] getScanDate]);
    [self performSegueWithIdentifier:@"editScan" sender:self];
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    NSString *heading = [[SharedObject sharedTeamData] getPatientName];
    NSString *heading2 = [[NSString alloc] initWithFormat:@"Scans Dates for %@", heading]; 
    return heading2;
}
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
       NSLog(@"ScanDisplay segue scandate is %@",[[SharedObject sharedTeamData] getScanDate]);
}
*/

@end
