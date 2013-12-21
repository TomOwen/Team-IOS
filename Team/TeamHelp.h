//
//  TeamHelp.h
//  Team
//
//  Created by Tom Owen on 7/8/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AppDelegate.h"
#import "HTMLHelpView.h"
int indexChosen = 0;
@interface TeamHelp : UIViewController <MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableDictionary *helpFiles;
@property (strong, nonatomic) NSMutableDictionary *helpLabels;
@property (strong, nonatomic) NSMutableDictionary *helpImages;
@property (weak, nonatomic) IBOutlet UITableView *helpTableView;

- (IBAction)quit:(UIButton *)sender;


- (IBAction)contactUs:(id)sender;
@end
