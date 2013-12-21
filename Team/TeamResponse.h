//
//  TeamResponse.h
//  Team
//
//  Created by Tom Owen on 10/14/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ResponseMap.h"
#import "SharedObject.h"

@interface TeamResponse : UIViewController <RKObjectLoaderDelegate>
@property (nonatomic, strong) RKObjectManager *manager;
@property (strong, nonatomic) NSString *callBack;
@property (strong,nonatomic) NSArray *responseXML;
@property (strong, nonatomic) NSString *savePatientName;
@property (weak, nonatomic) IBOutlet UIImageView *happyFace;
@property (weak, nonatomic) IBOutlet UILabel *nameAndScanDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *line1Overall;
@property (weak, nonatomic) IBOutlet UILabel *line2TargetOverall;
@property (weak, nonatomic) IBOutlet UILabel *line3TargetBase;
@property (weak, nonatomic) IBOutlet UILabel *line4TargetSmall;
@property (weak, nonatomic) IBOutlet UILabel *line5NonTargetOverall;
@property (weak, nonatomic) IBOutlet UILabel *line6NonTargetBase;
@property (weak, nonatomic) IBOutlet UILabel *line7NonTargetSmall;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lymphFootNote;

- (IBAction)showHideLesions:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *showHideButton;
@property (assign,nonatomic) BOOL lesionsHidden;
@end
