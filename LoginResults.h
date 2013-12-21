//
//  LoginResults.h
//  TeamRest
//
//  Created by Tom Owen on 9/22/12.
//  Copyright (c) 2012 Tom Owen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginResults : NSObject
@property (nonatomic, retain) NSNumber* teamid;
@property (nonatomic, retain) NSString* db_server;
@property (nonatomic, retain) NSString* dbUser;
@property (nonatomic, retain) NSString* dbPassword;
@property (nonatomic, retain) NSString* imagedoc_server;
@property (nonatomic, retain) NSString* imagedocUser;
@property (nonatomic, retain) NSString* imagedocPassword;
@property (nonatomic, retain) NSString* userAdminAccess;
@property (nonatomic, retain) NSString* imageType;
@property (nonatomic, retain) NSString* docType;
@property (nonatomic, retain) NSString* companyName;
@end
