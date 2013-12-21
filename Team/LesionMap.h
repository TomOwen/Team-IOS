//
//  LesionMap.h
//  Team
//
//  Created by Tom Owen on 10/7/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LesionMap : NSObject
@property (nonatomic, retain) NSNumber* lesionTeamid;
@property (nonatomic, retain) NSString* lesionPatientID;
@property (nonatomic, retain) NSDate* lesionScanDate;
@property (nonatomic, retain) NSNumber* lesionNumber;
@property (nonatomic, retain) NSNumber* lesionSize;
@property (nonatomic, retain) NSString* lesionComment;
@property (nonatomic, retain) NSString* lesionTarget;
@property (nonatomic, retain) NSString* lesionMediaType;
@property (nonatomic, retain) NSString* lesionMediaOnline;
@property (nonatomic, retain) NSString* lesionNode;

@end
