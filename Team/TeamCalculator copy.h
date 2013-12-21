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

@interface TeamCalculator : UIViewController <NSFetchedResultsControllerDelegate>
@property (strong,nonatomic) NSMutableArray *currentLesions;
@property (strong,nonatomic) NSMutableArray *smallestLesions;
@property (strong,nonatomic) NSMutableArray *baseLineLesions;
@property (strong,nonatomic) NSMutableArray *tempBase;
@property (strong,nonatomic) NSDate *currentScanDate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UILabel *overallStatusLabel;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak,nonatomic) NSMutableArray *listOfDates;
@property (weak, nonatomic)NSMutableArray *targetScanDateArray;
@property (strong, nonatomic)NSMutableArray *targetLesionNumberArray;
@property (weak, nonatomic)NSMutableArray *targetLesionSizeArray;
@property (weak, nonatomic)NSMutableArray *baseScanDateArray;
@property (strong, nonatomic)NSMutableArray *baseLesionNumberArray;
@property (strong, nonatomic)NSMutableArray *tempLesionNumberArray;
@property (weak, nonatomic)NSMutableArray *baseLesionSizeArray;
@property (weak, nonatomic)NSMutableArray *percentIncreaseArray;
@property (weak, nonatomic) NSNumber *totalSizeOfLesions;
@property (weak, nonatomic) NSNumber *percentageChanged;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) NSString *patientID;
@property (assign) BOOL includeAllLesions;
- (IBAction)performCalculationWithTargetsOnly:(UIButton *)sender;
- (IBAction)performCalculationWithAllLesions:(UIButton *)sender;

@end
