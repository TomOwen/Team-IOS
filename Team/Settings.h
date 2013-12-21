//
//  Settings.h
//  Team
//
//  Created by Tom Owen on 8/19/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Settings : NSManagedObject

@property (nonatomic, retain) NSString * doc_type;
@property (nonatomic, retain) NSString * image_type;
@property (nonatomic, retain) NSString * server_url;
@property (nonatomic, retain) NSString * company_name;

@end
