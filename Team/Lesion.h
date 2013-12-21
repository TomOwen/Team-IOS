//
//  Lesion.h
//  Team
//
//  Created by Tom Owen on 7/12/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Lesion : NSManagedObject

@property (nonatomic, retain) NSString * lesion_comment;
@property (nonatomic, retain) NSString * lesion_media_online;
@property (nonatomic, retain) NSString * lesion_media_type;
@property (nonatomic, retain) NSNumber * lesion_number;
@property (nonatomic, retain) NSString * lesion_patient_id;
@property (nonatomic, retain) NSDate * lesion_scan_date;
@property (nonatomic, retain) NSNumber * lesion_size;
@property (nonatomic, retain) NSString * lesion_target;
@property (nonatomic, retain) NSString * lesion_node;

@end
