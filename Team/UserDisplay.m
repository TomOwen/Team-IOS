//
//  UserDisplay.m
//  Team
//
//  Created by Tom Owen on 6/23/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "UserDisplay.h"
#import "Users.h"

@interface UserDisplay ()

@end

@implementation UserDisplay
@synthesize userName = _userName;
@synthesize userPassword = _userPassword;
@synthesize userEmail = _userEmail;
@synthesize userAdmin = _userAdmin;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize myTableView = _myTableView;
@synthesize fetchedResultsController = __fetchedResultsController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)readAllUsers {
    // set up context
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    [NSFetchedResultsController deleteCacheWithName:nil];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"user_name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    //    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    [self.myTableView reloadData];
    self.myTableView.allowsSelection = YES;
    self.myTableView.scrollEnabled = YES;
}

- (void)userHitSave {
    //    [self readAllStudies];
}
#pragma mark - Scan Table delagates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"userCell";
    
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
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        
        NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSString *loginToDelete =    [[object valueForKey:@"user_name"] description];
        NSLog(@"deleting %@",loginToDelete);
        if ([loginToDelete isEqualToString:@"admin"]) {
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc] 
                           initWithTitle: @"Sorry you can not delete the admin account!" 
                           message:@"Please check with support if this is a problem. Go to the HELP screen tab" 
                           delegate: nil
                           cancelButtonTitle: @"Ok"
                           otherButtonTitles: nil];
            [alertDialog show];
            return;
        }
        
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        // reload the table
        [self readAllUsers];
        [self.myTableView reloadData];
    }   
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // read all studies for display in table
    [self readAllUsers];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self readAllUsers];
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
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"User Login: %@",[[object valueForKey:@"user_name"] description]];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat: @"Password: %@ Email: %@",[[object valueForKey:@"user_password"] description],[[object valueForKey:@"user_email"] description]];
    
    // set color
    cell.detailTextLabel.textColor = [UIColor blueColor];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.userName =       [[object valueForKey:@"user_name"] description];
    self.userPassword =    [[object valueForKey:@"user_password"] description];
    self.userEmail =     [[object valueForKey:@"user_email"] description];
    self.userAdmin =      [[object valueForKey:@"user_admin_access"] description];
    [self performSegueWithIdentifier:@"editUser" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editUser"]) {
       //UserEdit *editUser = segue.destinationViewController;
       [[segue destinationViewController] setName:self.userName setPassword:self.userPassword setEmail:self.userEmail setAdmin:self.userAdmin];
    }
}

@end
