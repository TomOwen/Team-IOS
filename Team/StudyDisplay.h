//
//  StudyDisplay.h
//  Team
//
//  Created by Tom Owen on 5/30/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyEdit.h"
#import "SharedObject.h"
#import "StudyMap.h"
#import "Results.h"
@interface StudyDisplay : UIViewController <RKObjectLoaderDelegate>
@property (nonatomic, strong) RKObjectManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong,nonatomic) NSArray *currentStudies;
@property (strong, nonatomic) NSString *callBack;
@end

static NSString *studyOwner = nil;
static NSString *studyID = nil;
static NSString *studyName = nil;
static NSString *studyURL = nil;
static NSNumber *studyPR = nil;
static NSNumber *studyPD = nil;
static NSNumber *studySeats = nil;
