//
//  SettingsMap.h
//  TeamRest
//
//  Created by Tom Owen on 9/25/12.
//  Copyright (c) 2012 Tom Owen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsMap : NSObject
@property (nonatomic, retain) NSNumber* teamid;
@property (nonatomic, retain) NSString* companyName;
@property (nonatomic, retain) NSString* dbServer;
@property (nonatomic, retain) NSString* imageDocServer;
@property (nonatomic, retain) NSString* imageType;
@property (nonatomic, retain) NSString* docType;

@end
