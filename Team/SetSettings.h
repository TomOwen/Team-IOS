//
//  SetSettings.h
//  Team
//
//  Created by Tom Owen on 6/9/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SetSettings : UIViewController <UITextFieldDelegate,UIActionSheetDelegate>
- (IBAction)loadDemoFiles:(UIButton *)sender;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSMutableArray *settingsArray;
@property (weak, nonatomic) IBOutlet UITextField *serverInputURL;
@property (weak, nonatomic) IBOutlet UITextField *imageType;
@property (weak, nonatomic) IBOutlet UITextField *docType;
@property (weak, nonatomic) IBOutlet UILabel *saveStatusLabel;
- (IBAction)saveSettings:(UIBarButtonItem *)sender;

@end
