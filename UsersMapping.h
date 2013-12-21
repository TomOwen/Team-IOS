//
//  UsersMapping.h
//  TeamRest
//
//  Created by Tom Owen on 9/24/12.
//  Copyright (c) 2012 Tom Owen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsersMapping : NSObject
@property (nonatomic, retain) NSNumber* userTeamid;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* userPassword;
@property (nonatomic, retain) NSString* userEmail;
@property (nonatomic, retain) NSString* userAdminAccess;
@end
