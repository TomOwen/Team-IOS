//
//  ViewAndPrintDetails.h
//  Team
//
//  Created by Tom Owen on 8/10/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RetrieveSettings.h"

@interface ViewAndPrintDetails : UIViewController
- (void)setPatientID:(NSString *)patientID setLine1:(NSString *)line1 setLine2:(NSString *)line2 setLine3:(NSString *)line3 setLine4:(NSString *)line4 setLine5:(NSString *)line5 setLine6:(NSString *)line6 setLine7:(NSString *)line7 setPR:(NSString *)percentPR setPD:(NSString *)percentPD;
@property (strong, nonatomic) NSString *pline1;
@property (strong, nonatomic) NSString *pline2;
@property (strong, nonatomic) NSString *pline3;
@property (strong, nonatomic) NSString *pline4;
@property (strong, nonatomic) NSString *pline5;
@property (strong, nonatomic) NSString *pline6;
@property (strong, nonatomic) NSString *pline7;
@property (strong, nonatomic) NSString *plinePR;
@property (strong, nonatomic) NSString *plinePD;
@property (weak, nonatomic) NSString  *companyName;
@property (weak, nonatomic) NSString  *lesion_target;
@property (weak, nonatomic) NSString  *lymph_node;
@property (weak, nonatomic) NSString  *comment;
@property (weak, nonatomic) NSNumber  *lesion_number;
@property (weak, nonatomic) NSNumber  *lesion_size;
@property (weak, nonatomic) NSMutableArray *objects;
@property (weak, nonatomic) NSDate  *scan_date;
@property (weak, nonatomic) NSString  *patient_doctor;
@property (weak, nonatomic) NSString  *patient_name;
@property (weak, nonatomic) NSString  *study_name;
@property (weak, nonatomic) NSString  *study_owner;
@property (weak, nonatomic) NSString  *patient_study_id;
@property (strong, nonatomic) NSString  *report;
@property (weak, nonatomic) NSString  *printPatientID;
@property (weak, nonatomic) NSString  *printSummaryLine;
@property (weak, nonatomic) NSString  *printLine1;
@property (weak, nonatomic) NSString  *printLine2;
- (IBAction)printDetails:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
