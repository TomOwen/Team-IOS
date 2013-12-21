//
//  Users.h
//  Team
//
//  Created by Tom Owen on 6/23/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Users : NSManagedObject

@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSString * user_password;
@property (nonatomic, retain) NSString * user_email;
@property (nonatomic, retain) NSString * user_admin_access;

@end
