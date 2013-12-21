//
//  RetrieveSettings.m
//  Team
//
//  Created by Tom Owen on 6/9/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "RetrieveSettings.h"

@interface RetrieveSettings ()

@end

@implementation RetrieveSettings
@synthesize settingsArray = _settingsArray;
@synthesize managedObjectContext = _managedObjectContext;

+(NSArray *)readSettings {
    //NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
    NSManagedObjectContext *moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSManagedObjectContext *context = moc;  
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:moc];   
    
    // Setup the fetch request  
    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity:entity];   
    
    // Define how we will sort the records  
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"server_url" ascending:NO];  
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];  
    [request setSortDescriptors:sortDescriptors];    
    
    // Fetch the records and handle an error  
    NSError *error;  
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];   
    
    if (!mutableFetchResults) {  
        NSLog(@"Failed to read settings");
    }   
    return mutableFetchResults;
}

@end
