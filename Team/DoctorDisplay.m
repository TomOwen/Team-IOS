//
//  DoctorDisplay.m
//  Team
//
//  Created by Tom Owen on 6/2/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "DoctorDisplay.h"
#import "AppDelegate.h"
#import "Doctor.h"
#import "ScanAdd.h"


@interface DoctorDisplay ()

@end

@implementation DoctorDisplay
@synthesize manager = _manager;
@synthesize callBack = _callBack;
@synthesize myTableView = _myTableView;
@synthesize currentDoctors = _currentDoctors;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"getdoctors"]) {
        [self checkDoctorResults:objects];
        return;
    }
    if ([self.callBack isEqualToString:@"deletedoctor"]) {
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
- (void) checkDoctorResults:(NSArray *)objects {
    int count = [objects count];
    if (count) {
        DoctorMap* doctor = [objects objectAtIndex:0];
        if ([doctor.doctorTeamid isEqualToNumber:[NSNumber numberWithInt:0]]) {
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: @"No Doctor Records found"
                           message:@"Try again"
                           delegate: nil
                           cancelButtonTitle: @"Ok"
                           otherButtonTitles: nil];
            [alertDialog show];
            self.currentDoctors = Nil;
            [self.myTableView reloadData];
            self.myTableView.allowsSelection = YES;
            self.myTableView.scrollEnabled = YES;
            return;
        } else {
            self.currentDoctors = objects;
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
                       initWithTitle: @"Could not delete that doctor"
                       message:@"Doctor may have been deleted, or maybe a TEAM DB problem."
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
        
    }
    [self readAllDoctors];
    [self.myTableView reloadData];
}


- (void)readAllDoctors {
    // read patients for teamid, 1st get shared teamid
    // set up mapping
    RKObjectMapping* doctorMapping = [RKObjectMapping mappingForClass:[DoctorMap class]];
    [doctorMapping mapKeyPath:@"doctor_teamid" toAttribute:@"doctorTeamid"];
    [doctorMapping mapKeyPath:@"doctor_name" toAttribute:@"doctorName"];
    [doctorMapping mapKeyPath:@"doctor_info" toAttribute:@"doctorInfo"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:doctorMapping forKeyPath:@"team.doctor"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                    @"teamid",myid,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],nil];
    self.callBack = @"getdoctors";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamgetdoctors.php" stringByAppendingQueryParameters:queryParams] delegate:self];
}

#pragma mark - Scan Table delagates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.currentDoctors count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"doctorCell";
    
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
        // delete the doctor
        NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
        DoctorMap* doctor = [self.currentDoctors objectAtIndex:indexPath.row];
        NSLog(@"delete dr=%@,teamid=%@",doctor.doctorName,myid);
        RKObjectMapping* myresults = [RKObjectMapping mappingForClass:[Results class]];
        [myresults mapKeyPath:@"succeed" toAttribute:@"succeed"];
        [[RKObjectManager sharedManager].mappingProvider setMapping:myresults forKeyPath:@"team.results"];
        NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                     @"teamid",myid,
                                     @"doctor_name",doctor.doctorName,
                                     @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                     nil];
        self.callBack = @"deletedoctor";
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamdeletedoctor.php" stringByAppendingQueryParameters:queryParams] delegate:self];
    }
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
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
    if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"N"]) {
        self.navigationItem.rightBarButtonItem = Nil;
    }
    // read all studies for display in table
    [self readAllDoctors];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self readAllDoctors];
    [super viewWillAppear:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
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
    // get doctor info fro display
     DoctorMap* doctor = [self.currentDoctors objectAtIndex:indexPath.row];
    NSString *temp = doctor.doctorInfo;
    NSString *dash = @"-";
    if ([temp isEqualToString:@"n/a"]) {
        temp = @"";
        dash = @"";
    }
    NSString *label = [[NSString alloc] initWithFormat:@"%@ %@ %@",doctor.doctorName,dash,temp];
    cell.textLabel.text = label;
    // set color
    cell.textLabel.textColor = [UIColor blueColor];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //studyID =       [[object valueForKey:@"study_id"] description];
    //studyOwner =    [[object valueForKey:@"study_owner"] description];
    
    // doctor name from currentDoctors
    DoctorMap* doctor = [self.currentDoctors objectAtIndex:indexPath.row];
    doctorName =  doctor.doctorName;
    doctorInfo = doctor.doctorInfo;
    
    //studyURL =      [[object valueForKey:@"study_url"] description];
    [self performSegueWithIdentifier:@"editDoctor" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"editDoctor"]) {
        //DoctorEdit *editDoctor = segue.destinationViewController;
        //editDoctor.delegate = self;
        [[segue destinationViewController] doctorName:doctorName doctorInfo:doctorInfo];
    }

}

@end
