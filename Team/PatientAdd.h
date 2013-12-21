//
//  PatientAdd.h
//  Team
//
//  Created by Tom Owen on 5/30/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"
#import "Studies.h"
#import "Doctor.h"
#import "AppDelegate.h"
#import "DocandStudyMap.h"
#import "SharedObject.h"

@interface PatientAdd : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,RKObjectLoaderDelegate>
@property (nonatomic, strong) RKObjectManager *manager;
@property (weak, nonatomic) IBOutlet UITextField *studyInput;
@property (weak, nonatomic) IBOutlet UITextField *doctorInput;
@property (strong,nonatomic) NSMutableArray *studyArray;
@property (strong,nonatomic) NSMutableArray *doctorArray;
@property (strong,nonatomic) NSArray *currentDoctors;
@property (strong,nonatomic) NSArray *currentStudies;
@property UIPickerView *studyPickerView;
@property UIPickerView *doctorPickerView;


@property (strong, nonatomic) NSString *callBack;
@property (retain,nonatomic) NSArray *fetchData;

@property (weak, nonatomic) IBOutlet UITextField *patientName;

@property (weak, nonatomic) IBOutlet UITextField *patientID;

- (IBAction)saveNewPatient:(UIBarButtonItem *)sender;
- (IBAction)showStudyPicker:(id)sender;
- (IBAction)showDoctorPicker:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *statusNewLabel;
@end
