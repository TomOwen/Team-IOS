//
//  RetrieveSettings.h
//  Team
//
//  Created by Tom Owen on 6/9/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"

@interface RetrieveSettings : NSObject

+(NSArray *)readSettings;

@property (nonatomic,retain) NSArray *settingsArray;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
