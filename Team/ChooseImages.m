//
//  ChooseImages.m
//  Team
//
//  Created by Tom Owen on 6/8/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "ChooseImages.h"

@interface ChooseImages ()

@end

@implementation ChooseImages
@synthesize manager = _manager;
@synthesize callBack = _callBack;
@synthesize currentLesions = _currentLesions;
@synthesize labelText = _labelText;
@synthesize image1Label = _image1Label;
@synthesize image2Label = _image2Label;
@synthesize image1TableView = _image1TableView;
@synthesize image2TableView = _image2TableView;
@synthesize image1Selected = _image1Selected;
@synthesize image2Selected = _image2Selected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    if ([self.callBack isEqualToString:@"getlesions"]) {
        [self checkLesionResults:objects];
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
    if (count) {
        LesionMap* lesion = [objects objectAtIndex:0];
        if ([lesion.lesionTeamid isEqualToNumber:[NSNumber numberWithInt:0]]) {
            self.currentLesions = Nil;
            [self.image1TableView reloadData];
            [self.image2TableView reloadData];
            self.image1TableView.allowsSelection = YES;
            self.image2TableView.allowsSelection = YES;
            self.image1TableView.scrollEnabled = YES;
            self.image2TableView.scrollEnabled = YES;
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: @"No online images for this patient"
                           message:@"Upload scan screen shots to the image server"
                           delegate: nil
                           cancelButtonTitle: @"Ok"
                           otherButtonTitles: nil];
            [alertDialog show];
            return;
        } else {
            self.currentLesions = objects;
            [self.image1TableView reloadData];
            [self.image2TableView reloadData];
            self.image1TableView.allowsSelection = YES;
            self.image2TableView.allowsSelection = YES;
            self.image1TableView.scrollEnabled = YES;
            self.image2TableView.scrollEnabled = YES;
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

-(void)readAllLesions
{
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
    NSDictionary *queryParams = [NSDictionary dictionaryWithKeysAndObjects:
                                 @"teamid",myid,
                                 @"patient_id",[[SharedObject sharedTeamData] getPatientID],
                                 nil];
    self.callBack = @"getlesions";
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[@"/teamgetonlinelesions.php" stringByAppendingQueryParameters:queryParams] delegate:self];
}
#pragma mark - Scan Table delagates
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
    static NSString *CellIdentifier = @"cellLesion";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }  
    */

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
    self.image2Selected = NO;
    self.image1Selected = NO;
    NSString *patientName = [[SharedObject sharedTeamData] getPatientName];
    self.labelText.text = [[NSString alloc] initWithFormat:@"Images for %@",patientName];
    /*
    NSString *fullURL = [[NSString alloc] initWithFormat:@"http://%@",[[SharedObject sharedTeamData] getDb_server]];
    NSURL *url = [[NSURL alloc] initWithString:fullURL];
    //NSURL *url = [[NSURL alloc] initWithString:[[SharedObject sharedTeamData] getDb_server]];
    self.manager = [RKObjectManager objectManagerWithBaseURL:url];
    self.manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    self.manager.client.username = [[SharedObject sharedTeamData] getDbUser];
    self.manager.client.password = [[SharedObject sharedTeamData] getDbPassword];
    */
    
    [self readAllLesions];
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    LesionMap* lesion = [self.currentLesions objectAtIndex:indexPath.row];
    
    NSDate *date = lesion.lesionScanDate;
    NSNumber *size = lesion.lesionSize;
    NSNumber *number = lesion.lesionNumber;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM/dd/yy"];
    NSString *newDateString = [outputFormatter stringFromDate:date];
    //NSLog(@"date is %@",newDateString);
    NSString *tableText = [[NSString alloc ] initWithFormat:@"%@ #%@ (%@mm)",newDateString,number,size]; 
    cell.textLabel.text = tableText;
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"Size %@",size];
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //studyID =       [[object valueForKey:@"study_id"] description];
    //studyOwner =    [[object valueForKey:@"study_owner"] description];
    //doctorName =     [[object valueForKey:@"doctor_name"] description];
    //studyURL =      [[object valueForKey:@"study_url"] description];
    //[self performSegueWithIdentifier:@"editScan" sender:self];
    LesionMap* lesion = [self.currentLesions objectAtIndex:indexPath.row];
    NSDate *date = lesion.lesionScanDate;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM/dd/yy"];
    NSString *newDateString = [outputFormatter stringFromDate:date];
    NSNumber *number = lesion.lesionNumber;
    NSString *mediaType = lesion.lesionMediaType;
    if (tableView.tag == 1) {
        self.image1Selected = YES;
        self.image1Label.text = [[NSString alloc] initWithFormat:@"%@ Lesion #%@",newDateString,number];
        [[SharedObject sharedTeamData] setScanDate:date];
        [[SharedObject sharedTeamData] setLesionNumber:number];
        [[SharedObject sharedTeamData] setImageExt1:mediaType];
    } else {
        self.image2Selected = YES;
       self.image2Label.text = [[NSString alloc] initWithFormat:@"%@ Lesion #%@",newDateString,number];
        [[SharedObject sharedTeamData] setScanDate2:date];
        [[SharedObject sharedTeamData] setLesionNumber2:number];
        [[SharedObject sharedTeamData] setImageExt2:mediaType];
    }
}

- (void)viewDidUnload
{
    [self setLabelText:nil];
    [self setImage1TableView:nil];
    [self setImage2TableView:nil];
    [self setImage1Label:nil];
    [self setImage2Label:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)displayBothImages:(UIButton *)sender {
    if ( (!self.image1Selected) || (!self.image2Selected) ) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"You must selected both before and after images" 
                       message:@"Please try again" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    [self performSegueWithIdentifier:@"compareImages" sender:self];
}
@end
