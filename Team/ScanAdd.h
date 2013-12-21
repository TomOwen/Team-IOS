//
//  ScanAdd.h
//  Team
//
//  Created by Tom Owen on 6/4/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scan.h"
#import "SharedObject.h"
#import "TeamLesions.h"
#import "DocandStudyMap.h"
@interface ScanAdd : UIViewController <RKObjectLoaderDelegate>
@property (nonatomic, strong) RKObjectManager *manager;
@property (strong, nonatomic) NSString *callBack;
@property (nonatomic) NSString *scanPatientID;
@property (weak, nonatomic) IBOutlet UITextField *scanDateInput;
@property (weak, nonatomic) IBOutlet UILabel *statusNewLabel;
@property UIDatePicker *datePickerView;
- (IBAction)saveButtonHit:(UIBarButtonItem *)sender;
@end
