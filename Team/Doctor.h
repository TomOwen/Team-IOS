//
//  Doctor.h
//  Team
//
//  Created by Tom Owen on 6/2/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Doctor : NSManagedObject

@property (nonatomic, retain) NSString * doctor_name;
@property (nonatomic, retain) NSString * doctor_info;

@end
