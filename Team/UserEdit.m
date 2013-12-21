//
//  UserEdit.m
//  Team
//
//  Created by Tom Owen on 6/23/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "UserEdit.h"

@interface UserEdit ()

@end

@implementation UserEdit
@synthesize managedObjectContext = _managedObjectContext;
@synthesize statusLabel = _statusLabel;
@synthesize userNameLabel = _userNameLabel;
@synthesize userPasswordInput = _userPasswordInput;
@synthesize userEmailInput = _userEmailInput;
@synthesize userAdminInput = _userAdminInput;
@synthesize s_name = _s_name;
@synthesize s_password = _s_password;
@synthesize s_email = _s_email;
@synthesize s_admin = _s_admin;


- (void)setName:(NSString *)userName setPassword:(NSString *)userPassword setEmail:(NSString *)userEmail setAdmin:(NSString *)userAdmin
{
    NSLog(@"got %@, %@, %@,%@",userName,userPassword,userEmail,userAdmin);
    self.s_name = userName;
    self.s_password = userPassword;
    self.s_email = userEmail;
    self.s_admin = userAdmin;
}

- (IBAction)saveUser:(UIBarButtonItem *)sender {
        if ([self.userPasswordInput.text length] < 1) { 
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
    if ([self.userEmailInput.text length] < 1) { 
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
    
    // read user
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Users" 
                inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(user_name = %@)",self.s_name];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request 
                                              error:&error];
    if ([objects count] == 0) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"I could not find the user" 
                       message:@"Maybe some deleted it already" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;

    }
    NSManagedObject *matches = nil;
    matches = [objects objectAtIndex:0];
    [matches setValue:self.userPasswordInput.text forKey:@"user_password"];
    [matches setValue:self.userEmailInput.text forKey:@"user_email"];
    //NSString *adminOn = [[NSString alloc] init];
    NSString *adminOn = @"N";
    if (self.userAdminInput.on) adminOn = @"Y";
    [matches setValue:adminOn forKey:@"user_admin_access"];
    // Save the context.
    NSError *error2 = nil;
    if (![context save:&error2]) {
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
    NSString *display = [NSString stringWithFormat:@"%@ successfully saved",self.userNameLabel.text];
    [self.statusLabel setText:display];

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
    self.userNameLabel.text = self.s_name;
    self.userPasswordInput.text = self.s_password;
    self.userEmailInput.text = self.s_email;
    [self.userAdminInput setOn:NO animated:YES];
    if ([self.s_admin  isEqualToString:@"Y"]) {
        [self.userAdminInput setOn:YES animated:YES];
    }
    if ([self.s_name isEqualToString:@"admin"]) {
        self.userAdminInput.hidden = YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewDidUnload
{
    [self setStatusLabel:nil];
    [self setUserNameLabel:nil];
    [self setUserPasswordInput:nil];
    [self setUserEmailInput:nil];
    [self setUserAdminInput:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
