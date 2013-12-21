//
//  Patient.h
//  Team
//
//  Created by Tom Owen on 6/21/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Patient : NSManagedObject

@property (nonatomic, retain) NSString * patient_doctor;
@property (nonatomic, retain) NSString * patient_id;
@property (nonatomic, retain) NSString * patient_name;
@property (nonatomic, retain) NSString * patient_study_id;

@end
