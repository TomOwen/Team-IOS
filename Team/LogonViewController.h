//
//  LogonViewController.h
//  Team
//
//  Created by Tom Owen on 5/30/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SharedObject.h"
#import "UICheckbox.h"
#import "LoginResults.h"
#import "Results.h"
#import "Reachability.h"
@interface LogonViewController : UIViewController <UITextFieldDelegate,RKObjectLoaderDelegate>
{
    UIActivityIndicatorView *activityIndicator;
}
@property (weak, nonatomic) IBOutlet UILabel *initializing;
@property (nonatomic, strong) RKObjectManager *manager;
@property(nonatomic, weak)IBOutlet UICheckbox *checkbox;
@property (strong,nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *userPassword;
@property (strong, nonatomic) NSString *callBack;
@property (strong, nonatomic) UITextField *saveEmail;
- (IBAction)userLogin:(UIButton *)sender;
- (IBAction)forgotPassword:(id)sender;
- (IBAction)tryTeamDemo:(UIButton *)sender;


@end
