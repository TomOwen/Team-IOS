//
//  StudyMap.h
//  Team
//
//  Created by Tom Owen on 9/29/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudyMap : NSObject
@property (nonatomic, retain) NSNumber* studyTeamid;
@property (nonatomic, retain) NSString* studyID;
@property (nonatomic, retain) NSString* studyOwner;
@property (nonatomic, retain) NSString* studyName;
@property (nonatomic, retain) NSString* studyURL;
@property (nonatomic, retain) NSNumber* studyPercentPR;
@property (nonatomic, retain) NSNumber* studyPercentPD;
@property (nonatomic, retain) NSNumber* studySeats;

@end
