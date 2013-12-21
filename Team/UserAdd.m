//
//  UserAdd.m
//  Team
//
//  Created by Tom Owen on 6/24/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "UserAdd.h"

@interface UserAdd ()

@end

@implementation UserAdd
@synthesize managedObjectContext = _managedObjectContext;
@synthesize userName = _userName;
@synthesize userPassword = _userPassword;
@synthesize userEmail = _userEmail;
@synthesize userAdmin = _userAdmin;
@synthesize statusNewLabel = _statusNewLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)doesUserAlreadyExist:(NSManagedObjectContext *)context
{
    NSEntityDescription *entityDesc = 
    [NSEntityDescription entityForName:@"Users" 
                inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(user_name = %@)", 
                         self.userName.text];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request 
                                              error:&error];
    if ([objects count] == 0) {
        return NO;
    }
    return YES;
}

- (IBAction)saveNewUser:(UIBarButtonItem *)sender {
    // check if ID is entered (mandatory) field
    
    if ([self.userName.text length] < 1) { 
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Please enter the New User's Login name" 
                       message:@"Please Re-enter the Name" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    if ([self.userPassword.text length] < 1) { 
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"A password is required" 
                       message:@"Please enter a password" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    if ([self.userEmail.text length] < 1) { 
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"An email is required for Lost password retrieival" 
                       message:@"Please enter an email address" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }

    // set up context
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    
    
    NSManagedObjectContext *context = _managedObjectContext; 
    
    // check to see if ID already exists
    if ([self doesUserAlreadyExist:context]) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"User already exists" 
                       message:@"Please enter a different name" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
        
    }
    
    //NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
    
    
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    
    [newManagedObject setValue:self.userName.text forKey:@"user_name"];
    [newManagedObject setValue:self.userPassword.text forKey:@"user_password"];
    [newManagedObject setValue:self.userEmail.text forKey:@"user_email"];
    //NSString *adminOn = [[NSString alloc] init];
    NSString *adminOn = @"N";
    if (self.userAdmin.on) adminOn = @"Y";
    [newManagedObject setValue:adminOn forKey:@"user_admin_access"];
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"TEAM had a System Problem Saving User Data" 
                       message:@"The TEAM App will log the error and terminate. Check your network/iCloud settings and contact support for further help" 
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    NSString *display = [NSString stringWithFormat:@"%@ successfully added",self.userName.text];
    [self.statusNewLabel setText:display];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setUserName:nil];
    [self setUserPassword:nil];
    [self setUserEmail:nil];
    [self setUserAdmin:nil];
    [self setStatusNewLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
