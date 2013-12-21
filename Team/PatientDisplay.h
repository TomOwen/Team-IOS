//
//  PatientDisplay.h
//  Team
//
//  Created by Tom Owen on 5/30/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientEdit.h"
#import "SharedObject.h"
#import "PatientMap.h"
#import "Results.h"

@interface PatientDisplay : UIViewController <EditPatientDelegate,UISearchBarDelegate, UITableViewDataSource,UIActionSheetDelegate,RKObjectLoaderDelegate>;
@property (nonatomic, strong) RKObjectManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *theSearchBar;
@property (weak,nonatomic) NSMutableArray *scansToDelete;
@property (weak,nonatomic) NSMutableArray *lesionsToDelete;
@property (strong,nonatomic) NSArray *currentPatients;
@property (strong, nonatomic) NSString *callBack;
@property (strong, nonatomic) NSString *option;
@property (strong, nonatomic) NSString *search;
@property (strong, nonatomic) NSNumber *teamid;
- (IBAction)allPatients:(UIButton *)sender;
- (IBAction)byDoctor:(id)sender;
- (IBAction)byStudy:(UIButton *)sender;
@end
static NSString *patientID = nil;
static NSString *patientName = nil;
static NSString *patientStudy = nil;
static NSString *patientDoctor = nil;
