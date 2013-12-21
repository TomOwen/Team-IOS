//
//  ScanMap.h
//  Team
//
//  Created by Tom Owen on 10/6/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanMap : NSObject
@property (nonatomic, retain) NSNumber* scanTeamid;
@property (nonatomic, retain) NSString* scanPatientID;
@property (nonatomic, retain) NSDate* scanDate;
@property (nonatomic, retain) NSString* scanReportOnline;

@end
