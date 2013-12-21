//
//  LesionAdd.h
//  Team
//
//  Created by Tom Owen on 6/6/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedObject.h"
#import "AppDelegate.h"
#import "Scan.h"
#import "Results.h"

@interface LesionAdd : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,RKObjectLoaderDelegate>
@property (nonatomic, strong) RKObjectManager *manager;
@property (strong, nonatomic) NSString *callBack;
@property (weak, nonatomic) IBOutlet UISwitch *targetLesion;
@property (weak, nonatomic) IBOutlet UISwitch *lesionMediaOnline;
@property (weak, nonatomic) IBOutlet UISwitch *lesionLymphNode;
@property (weak, nonatomic) IBOutlet UILabel *statusNewLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property UIPickerView * mediaPickerView;
- (IBAction)showMediaPicker:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UITextField *mediaInput;
@property (strong, nonatomic) NSMutableArray *mediaArray;
- (IBAction)saveNewLesion:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *patientName;
@property (weak, nonatomic) IBOutlet UILabel *scanDate;
@property (weak, nonatomic) IBOutlet UITextField *lesionNumber;
@property (weak, nonatomic) IBOutlet UITextField *lesionSize;
@property (weak, nonatomic) IBOutlet UITextField *lesionComment;
- (IBAction)lesionNumberValueChanged:(UIStepper *)sender;
- (IBAction)lesionSizeValueChanged:(UIStepper *)sender;
@end
