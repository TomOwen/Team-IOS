//
//  PatientDisplay.m
//  Team
//
//  Created by Tom Owen on 5/30/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "PatientDisplay.h"
#import "AppDelegate.h"
#import "Patient.h"
#import "SharedObject.h"
@interface PatientDisplay ()

@end

@implementation PatientDisplay
@synthesize manager = _manager;
@synthesize option = _option;
@synthesize search = _search;
@synthesize teamid = _teamid;
@synthesize callBack = _callBack;
@synthesize currentPatients = _currentPatients;
@synthesize tableView = _tableView;
@synthesize theSearchBar = _theSearchBar;
@synthesize scansToDelete = _scansToDelete;
@synthesize lesionsToDelete = _lesionsToDelete;
static NSIndexPath *indexPathForDelete = 0;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)userHitSave {
    //    [self readAllStudies];
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"getpatients"]) {
        [self checkPatientResults:objects];
        return;
    }
    if ([self.callBack isEqualToString:@"deletepatient"]) {
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
- (void) checkPatientResults:(NSArray *)objects {
    int count = [objects count];
    if (count) {
        PatientMap* patient = [objects objectAtIndex:0];
        if ([patient.patientTeamid isEqualToNumber:[NSNumber numberWithInt:0]]) {
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: @"No Patient Records found"
                           message:@"Try again"
                           delegate: nil
                           cancelButtonTitle: @"Ok"
                           otherButtonTitles: nil];
            [alertDialog show];
            self.currentPatients = Nil;
            [self.tableView reloadData];
            self.tableView.allowsSelection = YES;
            self.tableView.scrollEnabled = YES;
            return;
        } else {
            self.currentPatients = objects;
            [self.tableView reloadData];
            self.tableView.allowsSelection = YES;
            self.tableView.scrollEnabled = YES;
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
                       initWithTitle: @"Could not delete that patient"
                       message:@"Patient may have been deleted, or maybe a TEAM DB problem."
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
        
    }
    [self readAllPatients];
    [self.tableView reloadData];
}


- (void)readAllPatients {
    // read patients for teamid, 1st get shared teamid
    // set up mapping
    RKObjectMapping* patientMapping = [RKObjectMapping mappingForClass:[PatientMap class]];
    [patientMapping mapKeyPath:@"patient_teamid" toAttribute:@"patientTeamid"];
    [patientMapping mapKeyPath:@"patient_id" toAttribute:@"patientID"];
    [patientMapping mapKeyPath:@"patient_name" toAttribute:@"patientName"];
    [patientMapping mapKeyPath:@"patient_study_id" toAttribute:@"patientStudyID"];
    [patientMapping mapKeyPath:@"patient_doctor" toAttribute:@"patientDoctor"];
    
    //[self.manager.mappingProvider setMapping:patientMapping forKeyPath:@"team.patient"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:patientMapping forKeyPath:@"team.patient"];
    //NSString *user = [[SharedObject sharedTeamData] getUser_name];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",self.teamid,
                                 @"option",self.option,
                                 @"search",self.search,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"getpatients";
    //[[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamgetpatients.php" stringByAppendingQueryParameters:queryParams] delegate:self];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamgetpatients.php" stringByAppendingQueryParameters:queryParams] delegate:self];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[[[RKObjectManager sharedManager] client] requestQueue] cancelRequestsWithDelegate:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self readAllPatients];
    
    for (id subview in self.theSearchBar.subviews) {
        if ([subview respondsToSelector:@selector(setEnablesReturnKeyAutomatically:)]) {
            [subview setEnablesReturnKeyAutomatically:NO];
            break;
        }
    }


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    NSString *fullURL = [[NSString alloc] initWithFormat:@"http://%@",[[SharedObject sharedTeamData] getDb_server]];
    //NSURL *url = [[NSURL alloc] initWithString:[[SharedObject sharedTeamData] getDb_server]];
    NSURL *url = [[NSURL alloc] initWithString:fullURL];
    self.manager = [RKObjectManager objectManagerWithBaseURL:url];
    self.manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    self.manager.client.username = [[SharedObject sharedTeamData] getDbUser];
    self.manager.client.password = [[SharedObject sharedTeamData] getDbPassword];
    */
	// Do any additional setup after loading the view.
    if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"N"]) {
        self.navigationItem.rightBarButtonItem = Nil;
    }
    self.teamid = [[SharedObject sharedTeamData] getTeamID];
    self.option = @"1";
    self.search = @"";
    [self readAllPatients];
    [self.tableView reloadData];
    //NSString *image_type = [[SharedObject sharedTeamData] getMediaType];
    //NSLog(@"image_type=%@",image_type);

}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.currentPatients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"patientcell"];
    [self configureCell:cell atIndexPath:indexPath];
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
- (void)readAndDeletePatient:(NSString *)patient{
    // delete all scans, and lesions for this patient/teamid 
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
	//NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    //NSLog(@"button is %d",buttonIndex);
    
    if (buttonIndex != 0) {
		return;
    }
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    PatientMap* patient = [self.currentPatients objectAtIndex:indexPathForDelete.row];
    patientID =       patient.patientID;
    //NSLog(@"Deleting Patient %@ for teamid %@",patientID,myid);
    RKObjectMapping* myresults = [RKObjectMapping mappingForClass:[Results class]];
    [myresults mapKeyPath:@"succeed" toAttribute:@"succeed"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:myresults forKeyPath:@"team.results"];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"patient_id",patientID,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                 nil];
    self.callBack = @"deletepatient";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamdeletepatient.php" stringByAppendingQueryParameters:queryParams] delegate:self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // prompt for delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIActionSheet *actionSheet;
        actionSheet=[[UIActionSheet alloc] initWithTitle:@""
                                                delegate:self
                                       cancelButtonTitle:@"Cancel" 
                                  destructiveButtonTitle:@"Delete Patient & All of his Scans and Lesions"
                                       otherButtonTitles:nil];
        actionSheet.actionSheetStyle=UIActionSheetStyleDefault;
        indexPathForDelete = indexPath;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }

}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get values from currentPatients
    PatientMap* patient = [self.currentPatients objectAtIndex:indexPath.row];
    patientID =       patient.patientID;
    patientName =     patient.patientName;
    patientStudy =    patient.patientStudyID;
    patientDoctor =   patient.patientDoctor;

    [[SharedObject sharedTeamData] setPatientID:patientID];
    [[SharedObject sharedTeamData] setPatientName:patientName];
    [self performSegueWithIdentifier:@"editPatient" sender:self];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editPatient"]) {
        PatientEdit *editPatient = segue.destinationViewController;
        editPatient.delegate = self;
        [[segue destinationViewController] setID:patientID setName:patientName setStudyID:patientStudy setDoctor:patientDoctor];
        
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //NSLog(@"search bar clicked and %@ was entered",searchBar.text);
    // try to search
    
    self.search = searchBar.text;
    self.option = @"2";
    [searchBar resignFirstResponder];
    [self readAllPatients];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar {
    aSearchBar.showsCancelButton = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    //[searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    //self.tableView.allowsSelection = YES;
    //self.tableView.scrollEnabled = YES;
    //[self readAllPatients];
    //[self.tableView reloadData];
}


- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // get data for display line2 from indexpath.row into currentPatients
    PatientMap* patient = [self.currentPatients objectAtIndex:indexPath.row];
    NSString *myname = patient.patientName;
    NSString *myid = patient.patientID;
    NSString *mydoc = patient.patientDoctor;
    NSString *line1 = [[NSString alloc] initWithFormat:@"%@ - ID# %@",myname,myid];
    cell.textLabel.text = line1;
    
    NSString *mytrial = patient.patientStudyID;
    NSString *line2 = [[NSString alloc] initWithFormat:@"%@ / %@",mydoc,mytrial];

    cell.detailTextLabel.text = line2;
    cell.detailTextLabel.textColor = [UIColor blueColor];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)allPatients:(UIButton *)sender {
    self.option = @"1";
    self.search = @"";
    [self readAllPatients];
    
}

- (IBAction)byDoctor:(id)sender {
    self.option = @"3";
    self.search = @"";
    [self readAllPatients];
}

- (IBAction)byStudy:(UIButton *)sender {
    self.option = @"4";
    self.search = @"";
    [self readAllPatients];
}
@end
