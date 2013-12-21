//
//  DoctorEdit.h
//  Team
//
//  Created by Tom Owen on 10/19/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Studies.h"
#import "StudyURLDisplay.h"
#import "StudyMap.h"
#import "Results.h"
@interface DoctorEdit : UIViewController <UITextFieldDelegate,RKObjectLoaderDelegate>

@property (nonatomic, strong) RKObjectManager *manager;
@property (weak, nonatomic) NSString *callBack;
- (void)doctorName:(NSString *)drname doctorInfo:(NSString *)drinfo;
- (IBAction)saveDoctor:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *drName;

@property (weak, nonatomic) IBOutlet UITextField *drInfo;


@end
