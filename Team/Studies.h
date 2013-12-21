//
//  Studies.h
//  Team
//
//  Created by Tom Owen on 5/30/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Studies : NSManagedObject

@property (nonatomic, retain) NSString * study_id;
@property (nonatomic, retain) NSString * study_owner;
@property (nonatomic, retain) NSString * study_name;
@property (nonatomic, retain) NSString * study_url;

@end
