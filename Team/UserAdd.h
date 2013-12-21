//
//  UserAdd.h
//  Team
//
//  Created by Tom Owen on 6/24/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserAdd : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (IBAction)saveNewUser:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UISwitch *userAdmin;
@property (weak, nonatomic) IBOutlet UILabel *statusNewLabel;
@end
