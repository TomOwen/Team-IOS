//
//  TeamCalculator.m
//  Team
//
//  Created by Tom Owen on 6/10/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "TeamCalculator.h"

@interface TeamCalculator ()

@end

@implementation TeamCalculator
@synthesize studyPercentPD = _studyPercentPD;
@synthesize studyPercentPR = _studyPercentPR;
@synthesize studyPercents1 = _studyPercents1;
@synthesize studyPercents2 = _studyPercents2;
@synthesize lesionsHidden = _lesionsHidden;
@synthesize line1Overall = _line1Overall;
@synthesize line2TargetOverall = _line2TargetOverall;
@synthesize line3TargetBase = _line3TargetBase;
@synthesize line4TargetSmall = _line4TargetSmall;
@synthesize line5NonTargetOverall = _line5NonTargetOverall;
@synthesize line6NonTargetBase = _line6NonTargetBase;
@synthesize line7NonTargetSmall = _line7NonTargetSmall;
@synthesize getTargetResponse = _getTargetResponse;
@synthesize overallResponseCode = _overallResponseCode;
@synthesize targetBaselineResponseCode = _targetBaselineResponseCode;
@synthesize targetSmallestResponseCode = _targetSmallestResponseCode;
@synthesize nonTargetBaselineResponseCode = _nonTargetBaselineResponseCode;
@synthesize nonTargetSmallestResponseCode = _nonTargetSmallestResponseCode;
@synthesize overallResponse = _overallResponse;
@synthesize headerTarget = _headerTarget;
@synthesize targetBaseline = _targetBaseline;
@synthesize targetSmallest = _targetSmallest;
@synthesize headerNonTarget = _headerNonTarget;
@synthesize nonTargetBaseline = _nonTargetBaseline;
@synthesize nonTargetSmallest = _nonTargetSmallest;
@synthesize userShowedOnlyTargets = _userShowedOnlyTargets;
@synthesize patientHasLymphNode = _patientHasLymphNode;
@synthesize isThisInitalScan = _isThisInitalScan;
@synthesize tumorResponse = _tumorResponse;
@synthesize lymphFootNote = _lymphFootNote;
@synthesize nameAndScanDateLabel = _nameAndScanDateLabel;
@synthesize nonTargetPresent = _nonTargetPresent;
@synthesize targetPresent = _targetPresent;
@synthesize showHideButton = _showHideButton;
@synthesize userClickedFilterButton = _userClickedFilterButton;
@synthesize happyFace = _happyFace;
@synthesize summaryResponseLabel = _summaryResponseLabel;
@synthesize currentLesions = _currentLesions;
@synthesize smallestLesions = _smallestLesions;
@synthesize baseLineLesions = _baseLineLesions;
@synthesize tableView = _tableView;
@synthesize targetOnlyButton = _targetOnlyButton;
@synthesize allLessionsButton = _allLessionsButton;
@synthesize currentScanDate = _currentScanDate;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize overallStatusLabel = _overallStatusLabel;
@synthesize overallStatusLabel1 = _overallStatusLabel1;
@synthesize patientID = _patientID;
@synthesize includeAllLesions = _includeAllLesions;
@synthesize totalSizeOfLesions = _totalSizeOfLesions;
@synthesize percentageChanged = _percentageChanged;
@synthesize listOfDates = _listOfDates;
static float totalOfAllCurrentLesions = 0.0;
static float totalOfAllSmallestLesions = 0.0;
static float totalOfAllBaseLineLesions = 0.0;
static float totalPercentChanged = 0.0;
static float totalPercentChanged1 = 0.0;
static bool patientHadNewLesion = NO;
- (void)setColorsOnLabels{
    // line1Overall
    if ([self.line1Overall.text isEqualToString:@"Overall Response - Complete Response"]) self.line1Overall.textColor = [UIColor greenColor];
    if ([self.line1Overall.text isEqualToString:@"Overall Response - Progressive Disease"]) self.line1Overall.textColor = [UIColor redColor];
    if ([self.line1Overall.text isEqualToString:@"Overall Response - Progressive Disease - New Lesion"]) self.line1Overall.textColor = [UIColor redColor];
    if ([self.line1Overall.text isEqualToString:@"Overall Response - Partial Response"]) self.line1Overall.textColor = [UIColor yellowColor];
    if ([self.line1Overall.text isEqualToString:@"Overall Response - Stable Disease"]) self.line1Overall.textColor = [UIColor whiteColor];
    
    if ([self.line2TargetOverall.text isEqualToString:@"Target Response: Complete Response"]) self.line2TargetOverall.textColor = [UIColor greenColor];
    if ([self.line2TargetOverall.text isEqualToString:@"Target Response: Partial Response"]) self.line2TargetOverall.textColor = [UIColor yellowColor];
    if ([self.line2TargetOverall.text isEqualToString:@"Target Response: Stable Disease"]) self.line2TargetOverall.textColor = [UIColor whiteColor];
    if ([self.line2TargetOverall.text isEqualToString:@"Target Response: Progressive Disease (New)"]) self.line2TargetOverall.textColor = [UIColor redColor];
    if ([self.line2TargetOverall.text isEqualToString:@"Target Response: Progressive Disease"]) self.line2TargetOverall.textColor = [UIColor redColor];
    if ([self.line2TargetOverall.text isEqualToString:@"Target Response: Initial Baseline Scan"]) self.line2TargetOverall.textColor = [UIColor whiteColor];
    
    if ([self.line5NonTargetOverall.text isEqualToString:@"Non Target Resp: Complete Response"]) self.line5NonTargetOverall.textColor = [UIColor greenColor];
    if ([self.line5NonTargetOverall.text isEqualToString:@"Non Target Resp: Partial Response"]) self.line5NonTargetOverall.textColor = [UIColor yellowColor];
    if ([self.line5NonTargetOverall.text isEqualToString:@"Non Target Resp: Stable Disease"]) self.line5NonTargetOverall.textColor = [UIColor whiteColor];
    if ([self.line5NonTargetOverall.text isEqualToString:@"Non Target Resp: Progressive Disease (New)"]) self.line5NonTargetOverall.textColor = [UIColor redColor];
    if ([self.line5NonTargetOverall.text isEqualToString:@"Non Target Resp: Progressive Disease"]) self.line5NonTargetOverall.textColor = [UIColor redColor];
    if ([self.line5NonTargetOverall.text isEqualToString:@"Non Target Resp: Initial Baseline Scan"]) self.line5NonTargetOverall.textColor = [UIColor whiteColor];
    if ([self.line5NonTargetOverall.text isEqualToString:@"Non Target Resp: No Non-Target Lesions"]) self.line5NonTargetOverall.textColor = [UIColor whiteColor];

}
-(NSString *) calculateOverallResponseCode:(NSString *)targetBase: (NSString *)targetSmall: (NSString *)nonTargetBase: (NSString *)nonTargetSmall {
    // response values
    // PD New Lesion
    // PD 
    // CR
    // PR
    // SD
    // if any are PD return "Overall Response - Progressive Disease"
    // if any are PD New Lesion return "Overall Response - Progressive Disease - New Lesion"
    if ([targetBase isEqualToString:@"PD"]) return @"Overall Response - Progressive Disease";
    if ([targetSmall isEqualToString:@"PD"]) return @"Overall Response - Progressive Disease";
    if ([nonTargetBase isEqualToString:@"PD"]) return @"Overall Response - Progressive Disease";
    if ([nonTargetSmall isEqualToString:@"PD"]) return @"Overall Response - Progressive Disease";
    if ([targetBase isEqualToString:@"PD New Lesion"]) return @"Overall Response - Progressive Disease - New Lesion";
    if ([targetSmall isEqualToString:@"PD New Lesion"]) return @"Overall Response - Progressive Disease - New Lesion";
    if ([nonTargetBase isEqualToString:@"PD New Lesion"]) return @"Overall Response - Progressive Disease - New Lesion";
    if ([nonTargetSmall isEqualToString:@"PD New Lesion"]) return @"Overall Response - Progressive Disease - New Lesion";
    NSString *response1 = @"PR";
    if ( ([targetBase isEqualToString:@"CR"]) && ([targetSmall isEqualToString:@"CR"]) ) response1 = @"CR";
    if ( ([targetBase isEqualToString:@"SD"]) && ([targetSmall isEqualToString:@"SD"]) ) response1 = @"SD";
    NSString *response2 = @"PR";
    if ( ([nonTargetBase isEqualToString:@"CR"]) && ([nonTargetSmall isEqualToString:@"CR"]) ) response2 = @"CR";
    if ( ([nonTargetBase isEqualToString:@"SD"]) && ([nonTargetSmall isEqualToString:@"SD"]) ) response2 = @"SD";
    NSString *overallresponse = @"Overall Response - Partial Response";
    if ( ([response1 isEqualToString:@"CR"]) && ([response2 isEqualToString:@"CR"]) ) overallresponse = @"Overall Response - Complete Response";
    if ( ([response1 isEqualToString:@"SD"]) && ([response2 isEqualToString:@"SD"]) ) overallresponse = @"Overall Response - Stable Disease";
    
    if ( ([response1 isEqualToString:@"SD"]) && ([response2 isEqualToString:@"CR"]) ) overallresponse = @"Overall Response - Stable Disease";
    if ( ([response1 isEqualToString:@"CR"]) && ([response2 isEqualToString:@"SD"]) ) overallresponse = @"Overall Response - Stable Disease";
    
    return overallresponse;
}
// The TeamCalculator will determine disease status by comparing the baseline
// lesions against the previous smallest version of that lesion in a previous scan date.
// response values
// PD New Lesion
// PD
// CR
// PR
// SD
-(NSString *)determineSummaryResponse:(float)percent:(float)currentTotal:(float)compareTotal{
    for (id object in self.currentLesions) {
        NSDictionary *currentObject = (NSDictionary *)object;
        NSString *target = [currentObject valueForKey:@"lesion_target"];
        if ([target isEqualToString:@"X"]) {
            NSLog(@"Found X");
            return @"PD New Lesion"; 
        } 
        NSString *lymph = [currentObject valueForKey:@"lesion_node"];
        if ([lymph isEqualToString:@"Y"]) {
            self.lymphFootNote.hidden = NO;
        }
    }
    for (id object in self.smallestLesions) {
        NSDictionary *currentObject = (NSDictionary *)object;
        NSString *target = [currentObject valueForKey:@"lesion_target"];
        if ([target isEqualToString:@"X"]) {
            NSLog(@"Found X");
            return @"PD New Lesion";
        }
    }
    int i = 0;
    for (id object in self.baseLineLesions) {
        NSDictionary *currentObject = (NSDictionary *)object;
        NSString *target = [currentObject valueForKey:@"lesion_target"];
        if ([target isEqualToString:@"X"]) {
            // now check the current lesion - if > 0 then still New
            id currentObject = [self.currentLesions objectAtIndex:i];
            NSNumber *currentSize = [currentObject valueForKey:@"lesion_size"];
            float myfloat = [currentSize floatValue];
            if (myfloat > 0) return @"PD New Lesion";
        }
    i++;
    }  
    float percentPD = 20;
    float percentPR = 30;
    // set from data base
    percentPR = [self.studyPercentPR floatValue];
    percentPD = [self.studyPercentPD floatValue];
    
    percentPD = percentPD - .01;
    percentPR = (percentPR - .01) * -1.0;
    
    float difference = currentTotal - compareTotal;
    if ((percent > percentPD) && (difference > 4.99)) return @"PD";
    if ((currentTotal == 0.0) || (currentTotal < 0.0)) return @"CR";
    if (percent < percentPR) return @"PR";
    return @"SD";
}
-(void)performCalculationsOnPatient{
    totalOfAllCurrentLesions = 0.0;
    totalOfAllSmallestLesions = 0.0;
    totalOfAllBaseLineLesions = 0.0;
    self.totalSizeOfLesions = 0;
    self.percentageChanged = 0;
    self.happyFace.hidden = YES;
    self.lymphFootNote.hidden = YES;
    self.patientHasLymphNode = NO;
        
// now count the total size and difference and percentage and set Response
    for (id object in self.currentLesions) {
        NSDictionary *currentObject = (NSDictionary *)object;
        NSNumber *mySize = [currentObject valueForKey:@"lesion_size"];
        totalOfAllCurrentLesions = totalOfAllCurrentLesions + [mySize floatValue];
        // if lesion was a lymph node subtract out the 10mm size of the actual node
        // normal lymph must be <10mm, so subtract 9.99 from size, if its negative make it 0
        NSString *isItNode = [currentObject valueForKey:@"lesion_node"];
        if ([isItNode isEqualToString:@"Y"]) {
            totalOfAllCurrentLesions = totalOfAllCurrentLesions - 9.99;
        }
        NSLog(@"currentLesion %2.2f, totalCurrent %2.2f",[mySize floatValue],totalOfAllCurrentLesions);
    }
    for (id object in self.smallestLesions) {
        NSDictionary *currentObject = (NSDictionary *)object;
        NSNumber *mySize = [currentObject valueForKey:@"lesion_size"];
        totalOfAllSmallestLesions = totalOfAllSmallestLesions + [mySize floatValue];
        // if lesion was a lymph node subtract out the 10mm size of the actual node
        // normal lymph must be <10mm, so subtract 9.99 from size, if its negative make it 0
        NSString *isItNode = [currentObject valueForKey:@"lesion_node"];
        if ([isItNode isEqualToString:@"Y"]) {
            totalOfAllSmallestLesions = totalOfAllSmallestLesions - 9.99;
        }
        NSLog(@"smalllesion %2.2f, totalsmall %2.2f",[mySize floatValue],totalOfAllSmallestLesions);
    }
    for (id object in self.baseLineLesions) {
        NSDictionary *currentObject = (NSDictionary *)object;
        NSNumber *mySize = [currentObject valueForKey:@"lesion_size"];
        totalOfAllBaseLineLesions = totalOfAllBaseLineLesions + [mySize floatValue];
        // if lesion was a lymph node subtract out the 10mm size of the actual node
        // normal lymph must be <10mm, so subtract 9.99 from size, if its negative make it 0
        NSString *isItNode = [currentObject valueForKey:@"lesion_node"];
        if ([isItNode isEqualToString:@"Y"]) {
            totalOfAllBaseLineLesions = totalOfAllBaseLineLesions - 9.99;
        }
        NSLog(@"baselesion %2.2f, totalbase %2.2f",[mySize floatValue],totalOfAllBaseLineLesions);
    }
    
    // create the summary line showing response of current against baseline
    float difference = totalOfAllCurrentLesions - totalOfAllBaseLineLesions;
    if (totalOfAllBaseLineLesions > 0) {
        totalPercentChanged = difference / totalOfAllBaseLineLesions *100.0;
    } else {
        totalPercentChanged = 0.0;
    }
    if (totalPercentChanged < -100.0) {totalPercentChanged = -100.0;}
    NSString *response = [self determineSummaryResponse:totalPercentChanged:totalOfAllCurrentLesions:totalOfAllBaseLineLesions];
    
    if (totalPercentChanged < 0.0) totalPercentChanged = totalPercentChanged * -1.0;
    
    //if (totalPercentChanged < -100.0) {totalPercentChanged = -100.0;}
    
    NSString *plusMinus = @"+";
    if (totalOfAllBaseLineLesions > totalOfAllCurrentLesions) {
        plusMinus = @"-";
    }   
    if (totalOfAllCurrentLesions < 0.0) {
        totalOfAllCurrentLesions = 0.0;
    }
    
    
    
    NSString *line1 = [[NSString alloc] initWithFormat:@"Current %2.1fmm Baseline %2.1fmm %@%2.0f%% %@",totalOfAllCurrentLesions,totalOfAllBaseLineLesions,plusMinus,totalPercentChanged,response];
    self.overallStatusLabel1.text = line1;
    
    // create the summary line2 showing response of current against baseline
    float difference2 = totalOfAllCurrentLesions - totalOfAllSmallestLesions;
    if (totalOfAllSmallestLesions > 0) {
        totalPercentChanged1 = difference2 / totalOfAllSmallestLesions *100.0;
    } else {
        totalPercentChanged1 = 0.0;
    }
    if (totalPercentChanged1 < -100.0) {totalPercentChanged1 = -100.0;}
    NSString *response2 = [self determineSummaryResponse:totalPercentChanged1 :totalOfAllCurrentLesions :totalOfAllSmallestLesions];
    
    if (self.getTargetResponse) {
        self.targetBaselineResponseCode = response;
        self.targetSmallestResponseCode = response2;
    } else {
        self.nonTargetBaselineResponseCode = response;
        self.nonTargetSmallestResponseCode = response2;
    }
    
    if (totalPercentChanged1 < 0.0) totalPercentChanged1 = totalPercentChanged1 * -1.0;
    
    //if (totalPercentChanged1 < -100.0) {totalPercentChanged1 = -100.0;}
    
    NSString *plusMinus1 = @"+";
    if (totalOfAllSmallestLesions > totalOfAllCurrentLesions) {
        plusMinus1 = @"-";
    }  
    
    NSString *line2 = [[NSString alloc] initWithFormat:@"Current %2.1fmm Smallest %2.1fmm %@%2.0f%% %@",totalOfAllCurrentLesions,totalOfAllSmallestLesions,plusMinus1,totalPercentChanged1,response2];
    self.overallStatusLabel.text = line2;
    
    if ([response isEqualToString:@"CR"] && [response2 isEqualToString:@"CR"]) {
        self.happyFace.hidden = NO;
    }
    // set text color on baseline and smallest
    self.overallStatusLabel1.textColor = [UIColor blueColor];
    self.overallStatusLabel.textColor = [UIColor blueColor];
    self.summaryResponseLabel.text = @"Mixed Response";
    self.summaryResponseLabel.textColor = [UIColor whiteColor];
    
    if ([response isEqualToString:@"CR"]) {
        self.overallStatusLabel1.textColor = [UIColor greenColor];
    }
    if ([response isEqualToString:@"PD"]) {
        self.overallStatusLabel1.textColor = [UIColor redColor];
    }
    if ([response isEqualToString:@"PD New Lesion"]) {
        self.overallStatusLabel1.textColor = [UIColor redColor];
    }
    if ([response isEqualToString:@"SD"]) {
        self.overallStatusLabel1.textColor = [UIColor whiteColor];
    }
    if ([response isEqualToString:@"PR"]) {
        self.overallStatusLabel1.textColor = [UIColor yellowColor];
    }
    if ([response isEqualToString:@"PD"]) {
        self.overallStatusLabel1.textColor = [UIColor redColor];
    }
    
    
    if ([response2 isEqualToString:@"CR"]) {
        self.overallStatusLabel.textColor = [UIColor greenColor];
    }
    if ([response2 isEqualToString:@"PD"]) {
        self.overallStatusLabel.textColor = [UIColor redColor];
    }
    if ([response2 isEqualToString:@"PD New Lesion"]) {
        self.overallStatusLabel.textColor = [UIColor redColor];
    }
    if ([response2 isEqualToString:@"SD"]) {
        self.overallStatusLabel.textColor = [UIColor whiteColor];
    }
    if ([response2 isEqualToString:@"PR"]) {
        self.overallStatusLabel.textColor = [UIColor yellowColor];
    }
    if ([response2 isEqualToString:@"PD"]) {
        self.overallStatusLabel.textColor = [UIColor redColor];
    }
    
    // set summaryresponse text and color
    if ( ([response2 isEqualToString:@"PR"]) && ([response isEqualToString:@"PR"]) ) {
        self.summaryResponseLabel.textColor = [UIColor yellowColor];
        self.summaryResponseLabel.text = @"RECIST Summary: Partial Response";
    }
    if ( ([response2 isEqualToString:@"SD"]) && ([response isEqualToString:@"SD"]) ) {
        self.summaryResponseLabel.textColor = [UIColor whiteColor];
        self.summaryResponseLabel.text = @"RECIST Summary: Stable Disease";
    }
    if ( ([response2 isEqualToString:@"PD New Lesion"]) && ([response isEqualToString:@"PD New Lesion"]) ) {
        self.summaryResponseLabel.textColor = [UIColor redColor];
        self.summaryResponseLabel.text = @"RECIST Summary: Progressive Disease (New)";
    }
    if ( ([response2 isEqualToString:@"PD"]) && ([response isEqualToString:@"PD"]) ) {
        self.summaryResponseLabel.textColor = [UIColor redColor];
        self.summaryResponseLabel.text = @"RECIST Summary: Progressive Disease";
    }
    if ( ([response2 isEqualToString:@"PD"]) && ([response isEqualToString:@"PD"]) ) {
        self.summaryResponseLabel.textColor = [UIColor redColor];
        self.summaryResponseLabel.text = @"RECIST Summary: Progressive Disease";
    }
    if ( ([response2 isEqualToString:@"CR"]) && ([response isEqualToString:@"CR"]) ) {
        self.summaryResponseLabel.textColor = [UIColor greenColor];
        self.summaryResponseLabel.text = @"RECIST Summary: Complete Response";
    }
    
    if (self.isThisInitalScan) {
        self.summaryResponseLabel.text = @"RECIST Summary: Initial Baseline Scan";
        self.summaryResponseLabel.textColor = [UIColor whiteColor];
        self.overallStatusLabel1.textColor = [UIColor whiteColor];
        self.overallStatusLabel.textColor = [UIColor whiteColor];
    }

    
    
    // determine which buttons to display, if all lesions are Target Lesions then hide both buttons
    self.targetOnlyButton.hidden = YES;
    self.allLessionsButton.hidden = YES;
    self.targetPresent = NO;
    self.nonTargetPresent = NO;
    for (id object in self.currentLesions) {
        NSDictionary *currentObject = (NSDictionary *)object;
        NSString *target = [currentObject valueForKey:@"lesion_target"];
        if ([target isEqualToString:@"Y"]) {
            self.targetPresent = YES;
            NSLog(@"found T");
        }
        if ([target isEqualToString:@"N"]) {
            self.nonTargetPresent = YES;
            NSLog(@"found NT");
        }
    }
    if (self.targetPresent && self.nonTargetPresent) {
        self.targetOnlyButton.hidden = NO;
        self.allLessionsButton.hidden = NO;
    }
    if (self.userClickedFilterButton) {
        self.targetOnlyButton.hidden = NO;
        self.allLessionsButton.hidden = NO;
    }
    
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setHeaderForResponse{
     id scanObject = [self.currentLesions objectAtIndex:0];
     NSDate *date = (NSDate*) [scanObject valueForKey:@"lesion_scan_date"];
     NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
     [outputFormatter setDateFormat:@"MM/dd/yy"];
     NSString *newDateString = [outputFormatter stringFromDate:date];
     NSString *heading = [[SharedObject sharedTeamData] getPatientName];
     self.nameAndScanDateLabel.text = [[NSString alloc] initWithFormat:@"%@ - Current Scans on %@", heading,newDateString];
}
- (void) getStudyPercents {
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    NSManagedObjectContext *context = _managedObjectContext;
    // Define our table/entity to use  
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext:context];   
    
    // Setup the fetch request  
    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity:entity];   
    
    // set predicate for this patient
    NSPredicate *pred = nil;
    pred = [NSPredicate predicateWithFormat:@"(patient_id = %@)",self.patientID];
    [request setPredicate:pred];
    
    // Fetch the records and handle an error  
    NSError *error;  
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {  
        // Handle the error.  
        // This is a serious error and should advise the user to restart the application  
    }  
    if (![mutableFetchResults count]) {
        // here if no patient..... not good
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Could not find this patient" 
                       message:@"Please contact support for further help" 
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return;
    }
    id scanObject = [mutableFetchResults objectAtIndex:0];
    NSString *studyID = [scanObject valueForKey:@"patient_study_id"];
    NSLog(@"study_id = %@",studyID);
    // lets get the study percentages
    // Define our table/entity to use  
    entity = [NSEntityDescription entityForName:@"Studies" inManagedObjectContext:context];   
    
    // Setup the fetch request  
    request = [[NSFetchRequest alloc] init];  
    [request setEntity:entity];   
    
    // set predicate for this patient
    pred = nil;
    pred = [NSPredicate predicateWithFormat:@"(study_id = %@)",studyID];
    [request setPredicate:pred];
    
    // Fetch the records and handle an error  
    //NSError *error;  
    NSMutableArray *mutableFetchResults2 = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults2) {  
        // Handle the error.  
        // This is a serious error and should advise the user to restart the application  
    }  
    if (![mutableFetchResults2 count]) {
        // here if no study just set to default 30 and 20
        self.studyPercentPR = [NSNumber numberWithInt:30];
        self.studyPercentPD = [NSNumber numberWithInt:20];
        self.studyPercents1 = [[NSString alloc] initWithFormat:@"Partial Response %@%% or less",self.studyPercentPR];
        self.studyPercents2 = [[NSString alloc] initWithFormat:@"Progressive Disease %@%% or more",self.studyPercentPD];
        return;
    }
    id scanObject2 = [mutableFetchResults2 objectAtIndex:0];
    self.studyPercentPR = [scanObject2 valueForKey:@"study_percentpr"];
    self.studyPercentPD = [scanObject2 valueForKey:@"study_percentpd"];
    NSLog(@"study PR/PD = %@/%@",self.studyPercentPR,self.studyPercentPD);
    self.studyPercents1 = [[NSString alloc] initWithFormat:@"Partial Response %@%% or less",self.studyPercentPR];
    self.studyPercents2 = [[NSString alloc] initWithFormat:@"Progressive Disease %@%% or more",self.studyPercentPD];
    return;
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // iboutlets from old code need to keep but hide for now
    self.summaryResponseLabel.hidden = YES;
    self.overallStatusLabel.hidden = YES;
    self.overallStatusLabel1.hidden = YES;
    
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        // hide tableview
        self.tableView.hidden = YES;
        self.lesionsHidden = YES;
    }
    
    self.happyFace.hidden = YES;
    self.userClickedFilterButton = NO;
    self.userShowedOnlyTargets = NO;
    self.patientID = [[SharedObject sharedTeamData] getPatientID];
    [self getStudyPercents];
    TeamLesions *team1 = [[TeamLesions alloc] init]; 
    self.currentLesions = [team1 getCurrentLesions:@"Y"];
    self.smallestLesions = [team1 getSmallestLesions:self.currentLesions];
    self.baseLineLesions = [team1 getBaseLineLesions:self.currentLesions];
    [self.tableView reloadData];
    [self performCalculationsOnPatient];
    [self setHeaderForResponse];
    // print out header values
    NSLog(@"All self.summaryResponseLabel = %@",self.summaryResponseLabel.text);
    NSLog(@"All self.overallStatusLabel = %@",self.overallStatusLabel.text);
    NSLog(@"All self.overallStatusLabel1 = %@",self.overallStatusLabel1.text);
    // get Target Only
    self.getTargetResponse = YES;
    self.currentLesions = [team1 getCurrentLesions:@"T"];
    self.smallestLesions = [team1 getSmallestLesions:self.currentLesions];
    self.baseLineLesions = [team1 getBaseLineLesions:self.currentLesions];
    [self performCalculationsOnPatient];
    self.headerTarget = self.summaryResponseLabel.text;
    self.targetBaseline = self.overallStatusLabel1.text;
    self.targetSmallest = self.overallStatusLabel.text;
    NSLog(@"Target:%@",self.headerTarget);
    NSLog(@"Target:%@",self.targetBaseline);
    NSLog(@"Target:%@",self.targetSmallest);
    // get Non Target Only
    self.getTargetResponse = NO;
    self.currentLesions = [team1 getCurrentLesions:@"N"];
    if ([self.currentLesions count]) {
        self.smallestLesions = [team1 getSmallestLesions:self.currentLesions];
        self.baseLineLesions = [team1 getBaseLineLesions:self.currentLesions];
        [self performCalculationsOnPatient];
        self.headerNonTarget = self.summaryResponseLabel.text;
        self.nonTargetBaseline = self.overallStatusLabel1.text;
        self.nonTargetSmallest = self.overallStatusLabel.text;
    } else {
        self.headerNonTarget = @"RECIST Summary: No Non-Target Lesions";
        self.nonTargetBaseline = @" ";
        self.nonTargetSmallest = @" ";
        self.nonTargetBaselineResponseCode = @"CR";
        self.nonTargetSmallestResponseCode = @"CR";
    }
    NSLog(@"Non Target:%@",self.headerNonTarget);
    NSLog(@"Non Target:%@",self.nonTargetBaseline);
    NSLog(@"Non Target:%@",self.nonTargetSmallest); 
    
    // reset table with all lesions
    self.currentLesions = [team1 getCurrentLesions:@"Y"];
    self.smallestLesions = [team1 getSmallestLesions:self.currentLesions];
    self.baseLineLesions = [team1 getBaseLineLesions:self.currentLesions];
    NSLog(@"targetBaselineResponseCode=%@",self.targetBaselineResponseCode);
    NSLog(@"targetSmallestResponseCode=%@",self.targetSmallestResponseCode);
    NSLog(@"nonTargetBaselineResponseCode=%@",self.nonTargetBaselineResponseCode);
    NSLog(@"nonTargetSmallestResponseCode=%@",self.nonTargetSmallestResponseCode);
    self.overallResponseCode = [self calculateOverallResponseCode:self.targetBaselineResponseCode :self.targetSmallestResponseCode :self.nonTargetBaselineResponseCode :self.nonTargetSmallestResponseCode];
    NSLog(@"overallResponseCode=%@",self.overallResponseCode);
    
    // set 7 lines of response
    self.line1Overall.text = self.overallResponseCode;
    self.headerTarget = [self.headerTarget stringByReplacingOccurrencesOfString:@"RECIST Summary"
                                         withString:@"Target Response"];
    self.headerNonTarget = [self.headerNonTarget stringByReplacingOccurrencesOfString:@"RECIST Summary"
                                                                     withString:@"Non Target Resp"];
    self.line2TargetOverall.text = self.headerTarget;
    self.line3TargetBase.text = self.targetBaseline;
    self.line4TargetSmall.text = self.targetSmallest;
    self.line5NonTargetOverall.text = self.headerNonTarget;
    self.line6NonTargetBase.text = self.nonTargetBaseline;
    self.line7NonTargetSmall.text = self.nonTargetSmallest;
    [self setColorsOnLabels];
    
    
}

- (void)viewDidUnload
{
    [self setOverallStatusLabel:nil];
    [self setOverallStatusLabel1:nil];
    [self setHappyFace:nil];
    [self setTargetOnlyButton:nil];
    [self setAllLessionsButton:nil];
    [self setSummaryResponseLabel:nil];
    [self setLymphFootNote:nil];
    [self setNameAndScanDateLabel:nil];
    [self setLine1Overall:nil];
    [self setLine2TargetOverall:nil];
    [self setLine3TargetBase:nil];
    [self setLine4TargetSmall:nil];
    [self setLine5NonTargetOverall:nil];
    [self setLine6NonTargetBase:nil];
    [self setLine7NonTargetSmall:nil];
    [self setShowHideButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (IBAction)performCalculationWithAllLesions:(UIButton *)sender {
    self.userShowedOnlyTargets = NO;
    self.userClickedFilterButton = YES;
    patientHadNewLesion = NO;
    TeamLesions *team1 = [[TeamLesions alloc] init]; 
    self.currentLesions = [team1 getCurrentLesions:@"Y"];
    NSLog(@"currentLesions in MainTeam is %@",[self.currentLesions valueForKey:@"lesion_scan_date"]);
    self.smallestLesions = [team1 getSmallestLesions:self.currentLesions];
    NSLog(@"smallestLesions in MainTeam is %@",[self.smallestLesions valueForKey:@"lesion_target"]);
    self.baseLineLesions = [team1 getBaseLineLesions:self.currentLesions];
    NSLog(@"baseLineLesions in MainTeam is %@",[self.baseLineLesions valueForKey:@"lesion_target"]);
    self.includeAllLesions = YES;
    [self.tableView reloadData];
    [self performCalculationsOnPatient];
        
}
- (IBAction)performCalculationWithTargetsOnly:(UIButton *)sender {
    self.userShowedOnlyTargets = YES;
    self.userClickedFilterButton = YES;
    self.includeAllLesions = NO;
    patientHadNewLesion = NO;
    TeamLesions *team1 = [[TeamLesions alloc] init]; 
    self.currentLesions = [team1 getCurrentLesions:@"T"];
    self.smallestLesions = [team1 getSmallestLesions:self.currentLesions];
    self.baseLineLesions = [team1 getBaseLineLesions:self.currentLesions];
    [self.tableView reloadData];
    [self performCalculationsOnPatient];
}
- (NSString *)decideResponseFromBaseLine:(NSNumber *)baseLineSize:(NSNumber *)currentSize:(float)percentage{
    return @"";
}
#pragma mark - Scan Table delagates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    //return 1;
    return [self.currentLesions count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //return [self.currentLesions count];
    return 2;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor]; //must do here in willDisplayCell
    cell.textLabel.backgroundColor = [UIColor whiteColor]; //must do here in willDisplayCell
}
-(NSString *)formatLineOne:(int)section {
    //Baseline on mm/dd/yy was 25mm now +100
    id checkCurrentObject = [self.currentLesions objectAtIndex:section];
    NSString *checkNode = [checkCurrentObject valueForKey:@"lesion_node"];
    id baseLineObject = [self.baseLineLesions objectAtIndex:section];
    NSString *baseLineLesionIndicator = [baseLineObject valueForKey:@"lesion_target"];
    NSString *nodeOrNoNode = @"New Lesion*";
    if ([checkNode isEqualToString:@"N"]) {
        nodeOrNoNode = @"New Lesion";
    } 
    if ([baseLineLesionIndicator isEqualToString:@"X"]) {
        return nodeOrNoNode;
    }
    id currentObject = [self.currentLesions objectAtIndex:section];
    NSDate *baseLineDate = [baseLineObject valueForKey:@"lesion_scan_date"];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM/dd/yy"];
    NSString *newDateString = [outputFormatter stringFromDate:baseLineDate];
    NSNumber *baseLineSize = [baseLineObject valueForKey:@"lesion_size"];
    NSNumber *currentSize = [currentObject valueForKey:@"lesion_size"];
    // calculate difference and percentage
    static float percentChange = 0.0;
    float difference = [currentSize floatValue] - [baseLineSize floatValue];
    if ([baseLineSize doubleValue] > 0) {
        percentChange = difference / [baseLineSize floatValue] *100;
        //NSLog(@"percent is calc %2.2f",percentChange);
    } else {
        percentChange = 0.0;
    } 
    if (percentChange < 0.0) percentChange = percentChange * -1.0;
    NSString *plusMinus = @"+";
    //NSLog(@"baseline is %@, currentSize is %@",baseLineSize,currentSize);
    if ([baseLineSize compare:currentSize] == NSOrderedDescending) {
        plusMinus = @"-";
    }

    NSString *myNode = @"*";
    if ([checkNode isEqualToString:@"N"]) {
        myNode = @"";
    } 
    if ([checkNode isEqualToString:@"Y"]) {
        self.lymphFootNote.hidden = NO;
    }
    
    NSString *line1Format = [[NSString alloc] initWithFormat:@"Baseline on %@ was %@mm (now %@%1.0f%%)%@",newDateString,baseLineSize,plusMinus,percentChange,myNode];
    if ((baseLineDate = Nil)) {
        line1Format = @"New Lesion";
        self.lymphFootNote.hidden = NO;
    }
    return line1Format;
}
-(NSString *)formatLineTwo:(int)section {
    //Baseline on mm/dd/yy was 25mm now +100
    id currentObject = [self.currentLesions objectAtIndex:section];
    NSNumber *currentSize = [currentObject valueForKey:@"lesion_size"];
    id baseLineObject = [self.baseLineLesions objectAtIndex:section];
    NSString *baseLineLesionIndicator = [baseLineObject valueForKey:@"lesion_target"];
    NSString *formatLineTwo = @"";
    if ([baseLineLesionIndicator isEqualToString:@"X"]) {
        formatLineTwo = @"";
    } else {
        // configure second line
        NSString *newDateString = nil;
        id smallestObject = [self.smallestLesions objectAtIndex:section];
        //NSNumber *smallestSize = [smallestObject valueForKey:@"lesion_size"];
        NSDate *smallestDate = [smallestObject valueForKey:@"lesion_scan_date"];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"MM/dd/yy"];
        newDateString = [outputFormatter stringFromDate:smallestDate];
        NSNumber *smallestSize = [smallestObject valueForKey:@"lesion_size"];
        // calculate differnece and percentage
        float percentChange = 0.0;
        float difference = [currentSize floatValue] - [smallestSize floatValue];
        if ([smallestSize doubleValue] > 0) {
            percentChange = difference / [smallestSize floatValue] *100;
            //NSLog(@"percent is calc %2.2f",percentChange);
        } else {
            percentChange = 0.0;
        } 
        if (percentChange < 0.0) percentChange = percentChange * -1.0;
        //response = [self decideResponseFromBaseLine:baseLineSize :currentSize :percentChange];
        NSString *plusMinus1 = @"+";
        if ([smallestSize compare:currentSize] == NSOrderedDescending) {
            plusMinus1 = @"-";
        }
        id checkCurrentObject = [self.currentLesions objectAtIndex:section];
        NSString *checkNode = [checkCurrentObject valueForKey:@"lesion_node"];
        NSString *myNode = @"*";
        if ([checkNode isEqualToString:@"N"]) {
            myNode = @"";
        }
        if ([checkNode isEqualToString:@"Y"]) {
            self.lymphFootNote.hidden = NO;
        }
        formatLineTwo = [[NSString alloc] initWithFormat:@"Smallest on %@ was %@mm (now %@%1.0f%%)%@",newDateString,smallestSize,plusMinus1,percentChange,myNode];
        
        
        
        
    /*    
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"On %@ was %@mm now %@mm %@%2.0f%% %@",newDateString,smallestSize,currentSize,plusMinus1,percentChange,response];
        
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@%@: %@mm %@%1.0f%% Smallest %@ %@mm",typeOfLesion,currentNumber,currentSize,plusMinus1,percentChange,newDateString,smallestSize];
        
        cell.detailTextLabel.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:pointsize];
        cell.detailTextLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:pointsize];
        
        cell.detailTextLabel.textColor = [UIColor blueColor];
     */
        self.isThisInitalScan = NO;
        if (smallestDate == nil) {
            formatLineTwo = @"Inital Baseline Scan";
            self.isThisInitalScan = YES;
            self.summaryResponseLabel.text = @"RECIST Summary: Initial Baseline Scan";
            self.summaryResponseLabel.textColor = [UIColor whiteColor];
            self.overallStatusLabel1.textColor = [UIColor whiteColor];
            self.overallStatusLabel.textColor = [UIColor whiteColor];
        }
        
    }

    return formatLineTwo;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"teamCell";
    
    int mySection = indexPath.section;
    int myRow = indexPath.row;
    NSLog(@"indexpath section is %d and row is %d",mySection,myRow);
    // mysection is the entry to currentlesions
    // myrow is either 0 or 1 for line 1 or 2
    NSString *formattedString = @"";
    if (myRow == 0) {
        formattedString = [self formatLineOne:mySection];
        //formattedString = @"Baseline on 12/31/12 was 25mm now +100%";
    } else {
        formattedString = [self formatLineTwo:mySection];
        //formattedString = @"Smallest on 10/24/12 was 20mm now +100%";
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = formattedString;
    cell.textLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:14];
    return cell;
    
    // Configure the cell...
    // 3 arrays currentLesions,smallestLesions,baseLineLesions
    
    // configure 1st line of display
    id currentObject = [self.currentLesions objectAtIndex:indexPath.row];
    NSString *currentLesionIndicator = [currentObject valueForKey:@"lesion_target"];
    NSNumber *currentNumber = [currentObject valueForKey:@"lesion_number"];
    NSNumber *currentSize = [currentObject valueForKey:@"lesion_size"];
    NSString *typeOfLesion = @"NT"; // non target
    if ([currentLesionIndicator isEqualToString:@"Y"]) {
        typeOfLesion = @"T";
    }
    // if running on IPAD make text more verbose
    int pointsize = 14;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        pointsize = 16;
        if ([currentLesionIndicator isEqualToString:@"Y"]) {
            typeOfLesion = @"Target Lesion #";
        } else {
            typeOfLesion = @"Non Target Lesion #";
        }
    }
    id baseLineObject = [self.baseLineLesions objectAtIndex:indexPath.row];
    NSString *baseLineLesionIndicator = [baseLineObject valueForKey:@"lesion_target"];
    NSString *baseLineDisplayText = nil;
    NSNumber *baseLineSize = nil;
    NSString *response = @"PD";
    NSString *newDateString = nil;
    static float percentChange = 0.0;
    // check if new lesion is a lymph node
    id checkCurrentObject = [self.currentLesions objectAtIndex:indexPath.row];
    NSString *checkNode = [checkCurrentObject valueForKey:@"lesion_node"];
    NSString *nodeOrNoNode = @"New Lesion*";
    if ([checkNode isEqualToString:@"N"]) {
         nodeOrNoNode = @"New Lesion";
    } else {
        self.lymphFootNote.hidden = NO;
    }
    if ([baseLineLesionIndicator isEqualToString:@"X"]) {
        baseLineDisplayText = nodeOrNoNode;
    } else {
        // setup details of baseline
        NSDate *baseLineDate = [baseLineObject valueForKey:@"lesion_scan_date"];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"MM/dd/yy"];
        newDateString = [outputFormatter stringFromDate:baseLineDate];
        baseLineSize = [baseLineObject valueForKey:@"lesion_size"];
        // calculate differnece and percentage
        float difference = [currentSize floatValue] - [baseLineSize floatValue];
        if (baseLineSize > 0) {
            percentChange = difference / [baseLineSize floatValue] *100;
            //NSLog(@"percent is calc %2.2f",percentChange);
        } else {
            percentChange = 0.0;
        } 
        if (percentChange < 0.0) percentChange = percentChange * -1.0;
        response = [self decideResponseFromBaseLine:baseLineSize :currentSize :percentChange];
    }
    NSString *isLymphNode = [currentObject valueForKey:@"lesion_node"];
    
    NSString *node = @"";
    if ([isLymphNode isEqualToString:@"Y"]) {
        node = @"*";
        self.lymphFootNote.hidden = NO;
    }
    NSString *plusMinus = @"+";
    //NSLog(@"baseline is %@, currentSize is %@",baseLineSize,currentSize);
    if ([baseLineSize compare:currentSize] == NSOrderedDescending) {
        plusMinus = @"-";
    }
    if ([baseLineLesionIndicator isEqualToString:@"X"]) {
        // leave "New lesion" for display
        } else {
            baseLineDisplayText = [[NSString alloc] initWithFormat:@"%@%1.0f%% Baseline %@ %@mm %@",plusMinus,percentChange,newDateString,baseLineSize,node];
    }
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@%@: %@mm %@ %@",typeOfLesion,currentNumber,currentSize,baseLineDisplayText,response];
    //cell.textLabel.backgroundColor = [UIColor blackColor];
    //cell.contentView.backgroundColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:pointsize];
    //cell.textLabel.textColor = [UIColor blueColor];
    
    
    

    // now for the 2nd line f the display, 
    if ([baseLineLesionIndicator isEqualToString:@"X"]) {
        cell.detailTextLabel.text = @"";
        } else {
        // configure second line
            NSString *newDateString = nil;
            id smallestObject = [self.smallestLesions objectAtIndex:indexPath.row];
            //NSNumber *smallestSize = [smallestObject valueForKey:@"lesion_size"];
            NSDate *smallestDate = [smallestObject valueForKey:@"lesion_scan_date"];
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"MM/dd/yy"];
            newDateString = [outputFormatter stringFromDate:smallestDate];
            NSNumber *smallestSize = [smallestObject valueForKey:@"lesion_size"];
            // calculate differnece and percentage
            float difference = [currentSize floatValue] - [smallestSize floatValue];
            if (smallestSize > 0) {
                percentChange = difference / [smallestSize floatValue] *100;
                //NSLog(@"percent is calc %2.2f",percentChange);
            } else {
                percentChange = 0.0;
            } 
            if (percentChange < 0.0) percentChange = percentChange * -1.0;
            response = [self decideResponseFromBaseLine:baseLineSize :currentSize :percentChange];
            NSString *plusMinus1 = @"+";
            if ([smallestSize compare:currentSize] == NSOrderedDescending) {
                plusMinus1 = @"-";
            }
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"On %@ was %@mm now %@mm %@%2.0f%% %@",newDateString,smallestSize,currentSize,plusMinus1,percentChange,response];
            
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@%@: %@mm %@%1.0f%% Smallest %@ %@mm",typeOfLesion,currentNumber,currentSize,plusMinus1,percentChange,newDateString,smallestSize];
            
            cell.detailTextLabel.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:pointsize];
            cell.detailTextLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:pointsize];
        
            cell.detailTextLabel.textColor = [UIColor blueColor];
            self.isThisInitalScan = NO;
            if (smallestDate == nil) {
                cell.detailTextLabel.text = @"Inital Baseline Scan";
                self.isThisInitalScan = YES;
                self.summaryResponseLabel.text = @"RECIST Summary: Initial Baseline Scan";
                self.summaryResponseLabel.textColor = [UIColor whiteColor];
                self.overallStatusLabel1.textColor = [UIColor whiteColor];
                self.overallStatusLabel.textColor = [UIColor whiteColor];
            }
        
    }
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}
/*
- (NSString *)tableView:(UITableView *)tableView
titleForFooterInSection:(NSInteger)section{
    return [[SharedObject sharedTeamData] getPatientName];
}
*/
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    
    //id scanObject = [self.currentLesions objectAtIndex:0];
    id scanObject = [self.currentLesions objectAtIndex:section];
   /*
    NSDate *date = (NSDate*) [scanObject valueForKey:@"lesion_scan_date"];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM/dd/yy"];
    NSString *newDateString = [outputFormatter stringFromDate:date];
    //NSString *heading = [[SharedObject sharedTeamData] getPatientName];
    NSString *heading2 = [[NSString alloc] initWithFormat:@"Current Lesions from %@", newDateString];
    */
    // lets setup the header for this lesion
    NSString *headerString = @"Current";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        headerString = @"Current Size is";
    }
    NSString *myTarget = [scanObject valueForKey:@"lesion_target"];
    NSNumber *mySize = [scanObject valueForKey:@"lesion_size"];
    NSNumber *myNumber = [scanObject valueForKey:@"lesion_number"];
    NSString *typeOfLesion = @"";
    if ([myTarget isEqualToString:@"Y"]) {
        typeOfLesion = @"Target #";
    } else {
        typeOfLesion = @"Non Target #";
    }
    NSString *lesionHeader = [[NSString alloc] initWithFormat:@"%@%@ %@ %@mm", typeOfLesion,myNumber,headerString,mySize];

    
    //return heading2;
    UILabel *myHeader = [[UILabel alloc] init];
    myHeader.text = lesionHeader;
    
    myHeader.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:14];
    return lesionHeader;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // segue to before and after image    
}

- (IBAction)prepareForDetailPrint:(UIButton *)sender {
    if (self.userShowedOnlyTargets) {
        // have user include all lesions
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"All Lesions must be included for Reporting" 
                       message:@"Please re-calculate response by clicking on All Lesions" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    [self performSegueWithIdentifier:@"print" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"print"]) {
        //PatientEdit *editPatient = segue.destinationViewController;
        //editPatient.delegate = self;
        //[[segue destinationViewController] setID:patientID setName:patientName setStudyID:patientStudy setDoctor:patientDoctor];
        
        self.summaryResponseLabel.textColor = [UIColor whiteColor];
        self.overallStatusLabel1.textColor = [UIColor whiteColor];
        self.overallStatusLabel.textColor = [UIColor whiteColor];
        
        [[segue destinationViewController] setPatientID:self.patientID setLine1:self.line1Overall.text setLine2:self.line2TargetOverall.text setLine3:self.line3TargetBase.text setLine4:self.line4TargetSmall.text setLine5:self.line5NonTargetOverall.text setLine6:self.line6NonTargetBase.text setLine7:self.line7NonTargetSmall.text setPR:self.studyPercents1 setPD:self.studyPercents2];
        
        
        
    }
}
- (IBAction)showHideLesions:(UIButton *)sender {
    if (self.lesionsHidden) {
        self.lesionsHidden = NO;
        self.tableView.hidden = NO;
        [self.showHideButton setTitle:@"Hide Lesions" forState:(UIControlState)UIControlStateNormal];
    } else {
        self.lesionsHidden = YES;
        self.tableView.hidden = YES;
        [self.showHideButton setTitle:@"Show Lesions" forState:(UIControlState)UIControlStateNormal];
    }
    
}
@end
