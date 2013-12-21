//
//  StudyAdd.h
//  Team
//
//  Created by Tom Owen on 5/30/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocandStudyMap.h"
#import "AppDelegate.h"
#import "SharedObject.h"

@interface StudyAdd : UIViewController <UITextFieldDelegate,RKObjectLoaderDelegate>
@property (nonatomic, strong) RKObjectManager *manager;
@property (strong, nonatomic) NSString *callBack;
@property (weak, nonatomic) IBOutlet UITextField *studySeats;

@property (weak, nonatomic) IBOutlet UITextField *studyPercentPR;
@property (weak, nonatomic) IBOutlet UITextField *studyPercentPD;
@property (weak, nonatomic) IBOutlet UITextField *studyIDInput;
@property (weak, nonatomic) IBOutlet UITextField *studyOwnerInput;
@property (weak, nonatomic) IBOutlet UITextField *studyNameInput;
@property (weak, nonatomic) IBOutlet UITextField *studyURLInput;
@property (weak, nonatomic) IBOutlet UILabel *statusNewLabel;
- (IBAction)saveNewStudy:(UIBarButtonItem *)sender;
@end
