//
//  PatientEdit.h
//  Team
//
//  Created by Tom Owen on 5/30/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"
#import "Studies.h"
#import "Doctor.h"
#import "SharedObject.h"
#import "TeamLesions.h"
#import "Results.h"
#import "DocandStudyMap.h"
@class PatientEdit;
@protocol EditPatientDelegate
- (void)userHitSave;
@end
@interface PatientEdit : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,RKObjectLoaderDelegate>

@property (nonatomic, weak) id <EditPatientDelegate> delegate;
@property (nonatomic, strong) RKObjectManager *manager;
- (IBAction)teamCalculator:(UIButton *)sender;
- (void)setID:(NSString *)patientID setName:(NSString *)patientName setStudyID:(NSString *)patientStudyID setDoctor:(NSString *)patientDoctor;
- (IBAction)savePatient:(UIBarButtonItem *)sender;
@property (strong,nonatomic) NSMutableArray *studyArray;
@property (strong,nonatomic) NSMutableArray *doctorArray;
@property UIPickerView *studyPickerView;
@property UIPickerView *doctorPickerView;
@property (strong, nonatomic) NSString *callBack;
@property (strong, nonatomic) NSNumber *teamid;
- (IBAction)showStudyPicker:(id)sender;
- (IBAction)showDoctorPicker:(id)sender;
@property (weak, nonatomic) NSMutableArray *currentLesions;
@property (weak, nonatomic) IBOutlet UILabel *patientIDLabel;
@property (weak, nonatomic) IBOutlet UITextField *patientNameInput;
@property (weak, nonatomic) IBOutlet UITextField *patientStudyInput;
@property (weak, nonatomic) IBOutlet UITextField *patientDoctorInput;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
