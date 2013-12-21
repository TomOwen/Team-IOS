//
//  UserDisplay.h
//  Team
//
//  Created by Tom Owen on 6/23/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UserEdit.h"
#import "SharedObject.h"

@interface UserDisplay : UIViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak,nonatomic) NSString *userName;
@property (weak,nonatomic) NSString *userPassword;
@property (weak,nonatomic) NSString *userEmail;
@property (weak,nonatomic) NSString *userAdmin;
@end
