//
//  StudyDisplay.m
//  Team
//
//  Created by Tom Owen on 5/30/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "StudyDisplay.h"
#import "AppDelegate.h"
#import "Studies.h"


@interface StudyDisplay ()


@end

@implementation StudyDisplay
@synthesize manager = _manager;
@synthesize callBack = _callBack;
@synthesize myTableView = _myTableView;
@synthesize currentStudies = _currentStudies;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"getstudies"]) {
        [self checkStudyResults:objects];
        return;
    }
    if ([self.callBack isEqualToString:@"deletestudy"]) {
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
- (void) checkStudyResults:(NSArray *)objects {
    int count = [objects count];
    if (count) {
        StudyMap* study = [objects objectAtIndex:0];
        if ([study.studyTeamid isEqualToNumber:[NSNumber numberWithInt:0]]) {
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: @"No Study Records found"
                           message:@"Try again"
                           delegate: nil
                           cancelButtonTitle: @"Ok"
                           otherButtonTitles: nil];
            [alertDialog show];
            self.currentStudies = Nil;
            [self.myTableView reloadData];
            self.myTableView.allowsSelection = YES;
            self.myTableView.scrollEnabled = YES;
            return;
        } else {
            self.currentStudies = objects;
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
                       initWithTitle: @"Could not delete that study"
                       message:@"Study may have been deleted, or maybe a TEAM DB problem."
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
        
    }
    [self readAllStudies];
    [self.myTableView reloadData];
}


- (void)readAllStudies {
    // read studies for teamid, 1st get shared teamid
    // set up mapping
    RKObjectMapping* studyMapping = [RKObjectMapping mappingForClass:[StudyMap class]];
    [studyMapping mapKeyPath:@"study_teamid" toAttribute:@"studyTeamid"];
    [studyMapping mapKeyPath:@"study_id" toAttribute:@"studyID"];
    [studyMapping mapKeyPath:@"study_owner" toAttribute:@"studyOwner"];
    [studyMapping mapKeyPath:@"study_name" toAttribute:@"studyName"];
    [studyMapping mapKeyPath:@"study_url" toAttribute:@"studyURL"];
    [studyMapping mapKeyPath:@"study_percentpr" toAttribute:@"studyPercentPR"];
    [studyMapping mapKeyPath:@"study_percentpd" toAttribute:@"studyPercentPD"];
    [studyMapping mapKeyPath:@"study_seats" toAttribute:@"studySeats"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:studyMapping forKeyPath:@"team.studies"];
    NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"user_name",[[SharedObject sharedTeamData] getUser_name],nil];
    self.callBack = @"getstudies";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamgetstudies.php" stringByAppendingQueryParameters:queryParams] delegate:self];
}

#pragma mark - Scan Table delagates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.currentStudies count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"studyCell";
    
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
        // delete the study
        NSNumber *myid = [[SharedObject sharedTeamData] getTeamID];
        StudyMap* study = [self.currentStudies objectAtIndex:indexPath.row];
        studyID =       study.studyID;
        //NSLog(@"Deleting Study %@ for teamid %@",studyID,myid);
        RKObjectMapping* myresults = [RKObjectMapping mappingForClass:[Results class]];
        [myresults mapKeyPath:@"succeed" toAttribute:@"succeed"];
        [[RKObjectManager sharedManager].mappingProvider setMapping:myresults forKeyPath:@"team.results"];
        NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                     @"teamid",myid,
                                     @"study_id",studyID,
                                     @"user_name",[[SharedObject sharedTeamData] getUser_name],
                                     nil];
        self.callBack = @"deletestudy";
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamdeletestudy.php" stringByAppendingQueryParameters:queryParams] delegate:self];
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
    // read all studies for display in table
    if ([[[SharedObject sharedTeamData] getUserAdmin] isEqualToString:@"N"]) {
       self.navigationItem.rightBarButtonItem = Nil;
    }
    [self readAllStudies];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self readAllStudies];
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
    // get study data from currentStudies
    StudyMap* study = [self.currentStudies objectAtIndex:indexPath.row];
    NSString *subTitle1 = study.studyName;
    NSString *subTitle2 = study.studyOwner;
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat: @"%@ (%@)", subTitle1, subTitle2];
    cell.textLabel.text = study.studyID;
    
    // set color
    cell.detailTextLabel.textColor = [UIColor blueColor];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // get data from current Studies
    StudyMap* study = [self.currentStudies objectAtIndex:indexPath.row];
    studyID =       study.studyID;
    studyOwner =    study.studyOwner;
    studyName =     study.studyName;
    studyURL =      study.studyURL;
    studyPR = study.studyPercentPR;
    studyPD = study.studyPercentPD;
    studySeats = study.studySeats;
    [self performSegueWithIdentifier:@"editStudy" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editStudy"]) {
        //StudyEdit *editStudy = segue.destinationViewController;
        //editStudy.delegate = self;
        [[segue destinationViewController] setID:studyID setStudy:studyOwner setName:studyName setURL:studyURL setPR:studyPR setPD:studyPD setSeats:studySeats];
    }
}

@end
