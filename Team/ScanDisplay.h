//
//  ScanDisplay.h
//  Team
//
//  Created by Tom Owen on 6/4/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyEdit.h"
#import "SharedObject.h"
#import "ScanMap.h"
#import "Results.h"
@interface ScanDisplay : UIViewController <RKObjectLoaderDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) RKObjectManager *manager;
@property (weak,nonatomic) NSMutableArray *lesionsToDelete;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak,nonatomic) NSString *patientID;
@property (weak,nonatomic) NSString *deleteChoice;
@property (strong, nonatomic) NSString *callBack;
@property (strong,nonatomic) NSArray *currentScans;
@end
