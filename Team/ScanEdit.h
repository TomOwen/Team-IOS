//
//  ScanEdit.h
//  Team
//
//  Created by Tom Owen on 6/6/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SharedObject.h"
#import "ReportParamsMap.h"
#import "LesionMap.h"
#import "Results.h"
#import "AppDelegate.h"
@interface ScanEdit : UIViewController <UIActionSheetDelegate,RKObjectLoaderDelegate>
@property (nonatomic, strong) RKObjectManager *manager;
@property (strong, nonatomic) NSString *callBack;
@property (nonatomic, strong) NSArray *currentLesions;
@property (weak, nonatomic) IBOutlet UISwitch *onlineScanReport;
@property (weak, nonatomic) IBOutlet UILabel *scanReportLabel;
- (IBAction)userSetOnlineReport:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UIButton *viewReportButton;
@property (weak, nonatomic) IBOutlet UILabel *scanReportFileName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
