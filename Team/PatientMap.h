//
//  PatientMap.h
//  Team
//
//  Created by Tom Owen on 9/28/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientMap : NSObject
@property (nonatomic, retain) NSNumber* patientTeamid;
@property (nonatomic, retain) NSString* patientID;
@property (nonatomic, retain) NSString* patientName;
@property (nonatomic, retain) NSString* patientStudyID;
@property (nonatomic, retain) NSString* patientDoctor;
@end
