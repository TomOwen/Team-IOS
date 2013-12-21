//
//  DoctorAdd.h
//  Team
//
//  Created by Tom Owen on 6/2/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//
 
#import <UIKit/UIKit.h>
#import "SharedObject.h"
#import "AppDelegate.h"
#import "DocandStudyMap.h"

@interface DoctorAdd : UIViewController <UITextFieldDelegate,RKObjectLoaderDelegate>
@property (nonatomic, strong) RKObjectManager *manager;
@property (strong, nonatomic) NSString *callBack;
@property (weak, nonatomic) IBOutlet UITextField *doctorNameInput;
@property (weak, nonatomic) IBOutlet UITextField *doctorInfoInput;
@property (weak, nonatomic) IBOutlet UILabel *statusNewLabel;
- (IBAction)saveNewDoctor:(UIBarButtonItem *)sender;

@end
