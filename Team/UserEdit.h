//
//  UserEdit.h
//  Team
//
//  Created by Tom Owen on 6/23/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDisplay.h"
#import "AppDelegate.h"

@interface UserEdit : UIViewController
- (void)setName:(NSString *)userName setPassword:(NSString *)userPassword setEmail:(NSString *)userEmail setAdmin:(NSString *)userAdmin;
- (IBAction)saveUser:(UIBarButtonItem *)sender;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordInput;
@property (weak, nonatomic) IBOutlet UITextField *userEmailInput;
@property (weak, nonatomic) IBOutlet UISwitch *userAdminInput;
@property (weak,nonatomic) NSString *s_name;
@property (weak,nonatomic) NSString *s_password;
@property (weak,nonatomic) NSString *s_email;
@property (weak,nonatomic) NSString *s_admin;
@end

