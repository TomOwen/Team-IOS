//
//  DocandStudyMap.h
//  Team
//
//  Created by Tom Owen on 9/29/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocandStudyMap : NSObject
@property (nonatomic, retain) NSNumber* teamid;
// 1 is doctor, 2 is study
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* string;
@end
