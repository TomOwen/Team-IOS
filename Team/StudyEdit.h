//
//  StudyEdit.h
//  Team
//
//  Created by Tom Owen on 5/31/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Studies.h"
#import "StudyURLDisplay.h"
#import "StudyMap.h"
#import "Results.h"
#import "SharedObject.h"
@class StudyEdit;
@protocol EditStudyDelegate
- (void)userHitSave;
@end
@interface StudyEdit : UIViewController <UITextFieldDelegate,RKObjectLoaderDelegate>

@property (nonatomic, weak) id <EditStudyDelegate> delegate;
@property (nonatomic, strong) RKObjectManager *manager;
@property (weak, nonatomic) IBOutlet UITextField *studySeats;
@property (weak, nonatomic) NSString *callBack;
@property (weak, nonatomic) IBOutlet UITextField *studyPercentPR;
@property (weak, nonatomic) IBOutlet UITextField *studyPercentPD;
- (IBAction)viewStudyDocument:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *studyViewButton;
- (IBAction)viewGraph:(UIButton *)sender;
- (IBAction)viewPie:(UIButton *)sender;

- (void)setID:(NSString *)studyID setStudy:(NSString *)study setName:(NSString *)studyName setURL:(NSString *)studyURL setPR:(NSNumber *)studyPR setPD:(NSNumber *)studyPD setSeats:(NSNumber *)studySeats;
- (IBAction)saveStudy:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UILabel *studyIDLabel;
@property (weak, nonatomic) IBOutlet UITextField *studyOwnerInput;
@property (weak, nonatomic) IBOutlet UITextField *studyNameInput;
@property (weak, nonatomic) IBOutlet UITextField *studyURLInput;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
