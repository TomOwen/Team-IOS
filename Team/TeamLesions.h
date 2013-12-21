//
//  TeamLesions.h
//  Team
//
//  Created by Tom Owen on 6/14/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SharedObject.h"

@interface TeamLesions : UIViewController
-(NSMutableArray *)getCurrentLesions:(NSString *) allLesions;
-(NSMutableArray *)getSmallestLesions:(NSMutableArray *)currentLesions;
-(NSMutableArray *)getBaseLineLesions:(NSMutableArray *)currentLesions;
@property (strong, nonatomic)NSMutableArray *tempLesionNumberArray;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) NSString *patientID;
@property (strong,nonatomic) NSDate *currentScanDate;
@property (strong, nonatomic)NSMutableArray *currentLesions;
@property (strong,nonatomic) NSDate * baseDate;
@end
