//
//  DoctorDisplay.h
//  Team
//
//  Created by Tom Owen on 6/2/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyEdit.h"
#import "DoctorEdit.h"
#import "DoctorMap.h"
#import "SharedObject.h"
@interface DoctorDisplay : UIViewController <RKObjectLoaderDelegate>
@property (nonatomic, strong) RKObjectManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong,nonatomic) NSArray *currentDoctors;
@property (strong, nonatomic) NSString *callBack;
@end



static NSString *doctorName = nil;
static NSString *doctorInfo = nil;
