//
//  ChooseImages.h
//  Team
//
//  Created by Tom Owen on 6/8/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedObject.h"
#import "AppDelegate.h"
#import "LesionMap.h"

@interface ChooseImages : UIViewController <RKObjectLoaderDelegate>
@property (nonatomic, strong) RKObjectManager *manager;
@property (strong, nonatomic) NSString *callBack;
@property (nonatomic, strong) NSArray *currentLesions;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UILabel *image1Label;
@property (weak, nonatomic) IBOutlet UILabel *image2Label;
@property (weak, nonatomic) IBOutlet UITableView *image1TableView;
@property (weak, nonatomic) IBOutlet UITableView *image2TableView;
- (IBAction)displayBothImages:(UIButton *)sender;
@property (assign,nonatomic) BOOL image1Selected;
@property (assign,nonatomic) BOOL image2Selected;

@end
