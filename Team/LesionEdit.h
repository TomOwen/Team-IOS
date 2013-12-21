//
//  LesionEdit.h
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
#import "LesionMap.h"

@interface LesionEdit : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,RKObjectLoaderDelegate>
@property (nonatomic, strong) RKObjectManager *manager;
@property (strong, nonatomic) NSString *callBack;
- (IBAction)showMediaPicker:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *lesionMediaOnline;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *lesionLymphNode;

@property UIPickerView * mediaPickerView;
@property (weak, nonatomic) IBOutlet UITextField *mediaInput;
@property (strong, nonatomic) NSMutableArray *mediaArray;
@property (weak, nonatomic) IBOutlet UISwitch *targetLesion;
@property (weak, nonatomic) IBOutlet UILabel *statusNewLabel;
- (IBAction)saveLesion:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UILabel *patientName;
@property (weak, nonatomic) IBOutlet UILabel *scanDate;
- (IBAction)imageMovieSwichPressed:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UILabel *lesionNumber;
@property (weak, nonatomic) IBOutlet UITextField *lesionSize;
@property (weak, nonatomic) IBOutlet UITextField *lesionComment;
@property (weak, nonatomic) IBOutlet UILabel *fileTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lymphNodeLabel;
- (IBAction)lesionSizeValueChanged:(UIStepper *)sender;
@property (weak, nonatomic) IBOutlet UILabel *targetLesionLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageLesionLabek;
@property (weak, nonatomic) IBOutlet UIButton *viewMovieButton;
@property (weak, nonatomic) IBOutlet UIStepper *lesionStepper;
@property (weak, nonatomic) IBOutlet UIButton *viewImageButton;


@end
