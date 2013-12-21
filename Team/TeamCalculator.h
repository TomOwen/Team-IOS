//
//  TeamCalculator.h
//  Team
//
//  Created by Tom Owen on 6/10/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SharedObject.h"
#import "TeamLesions.h"
#import "ViewAndPrintDetails.h"

@interface TeamCalculator : UIViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSNumber *studyPercentPR;
@property (strong, nonatomic) NSNumber *studyPercentPD;
@property (strong, nonatomic) NSString *studyPercents1;
@property (strong, nonatomic) NSString *studyPercents2;
@property (weak, nonatomic) IBOutlet UILabel *line1Overall;
@property (weak, nonatomic) IBOutlet UILabel *line2TargetOverall;
@property (weak, nonatomic) IBOutlet UILabel *line3TargetBase;
@property (weak, nonatomic) IBOutlet UILabel *line4TargetSmall;
@property (weak, nonatomic) IBOutlet UILabel *line5NonTargetOverall;
@property (weak, nonatomic) IBOutlet UILabel *line6NonTargetBase;
@property (weak, nonatomic) IBOutlet UILabel *line7NonTargetSmall;

@property (assign,nonatomic) BOOL getTargetResponse;
@property (strong, nonatomic) NSString *overallResponseCode;
@property (strong, nonatomic) NSString *targetBaselineResponseCode;
@property (strong, nonatomic) NSString *targetSmallestResponseCode;
@property (strong, nonatomic) NSString *nonTargetBaselineResponseCode;
@property (strong, nonatomic) NSString *nonTargetSmallestResponseCode;

@property (strong, nonatomic) NSString *overallResponse;
@property (strong, nonatomic) NSString *headerTarget;
@property (strong, nonatomic) NSString *targetBaseline;
@property (strong, nonatomic) NSString *targetSmallest;
@property (strong, nonatomic) NSString *headerNonTarget;
@property (strong, nonatomic) NSString *nonTargetBaseline;
@property (strong, nonatomic) NSString *nonTargetSmallest;

@property (assign,nonatomic) BOOL userShowedOnlyTargets;
- (IBAction)prepareForDetailPrint:(UIButton *)sender;
@property (assign,nonatomic) BOOL isThisInitalScan;
@property (weak, nonatomic) IBOutlet UIImageView *happyFace;
@property (weak, nonatomic) IBOutlet UILabel *summaryResponseLabel;
@property (weak,nonatomic) NSString *tumorResponse;
@property (weak, nonatomic) IBOutlet UILabel *lymphFootNote;
@property (weak, nonatomic) IBOutlet UILabel *nameAndScanDateLabel;
@property (assign,nonatomic) BOOL patientHasLymphNode;
@property (assign,nonatomic) BOOL lesionsHidden;
@property (strong,nonatomic) NSMutableArray *currentLesions;
@property (strong,nonatomic) NSMutableArray *smallestLesions;
@property (strong,nonatomic) NSMutableArray *baseLineLesions;
@property (strong,nonatomic) NSDate *currentScanDate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UILabel *overallStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *overallStatusLabel1;
@property (weak,nonatomic) NSMutableArray *listOfDates;
@property (weak, nonatomic) NSNumber *totalSizeOfLesions;
@property (weak, nonatomic) NSNumber *percentageChanged;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)showHideLesions:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *showHideButton;
@property (assign,nonatomic) BOOL userClickedFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *targetOnlyButton;
@property (weak, nonatomic) IBOutlet UIButton *allLessionsButton;
@property (assign,nonatomic) BOOL targetPresent;
@property (assign,nonatomic) BOOL nonTargetPresent;
@property (weak, nonatomic) NSString *patientID;
@property (assign) BOOL includeAllLesions;
- (IBAction)performCalculationWithTargetsOnly:(UIButton *)sender;
- (IBAction)performCalculationWithAllLesions:(UIButton *)sender;

@end
