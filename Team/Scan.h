//
//  Scan.h
//  Team
//
//  Created by Tom Owen on 6/29/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Scan : NSManagedObject

@property (nonatomic, retain) NSDate * scan_date;
@property (nonatomic, retain) NSString * scan_patient_id;
@property (nonatomic, retain) NSString * scan_report_online;

@end
