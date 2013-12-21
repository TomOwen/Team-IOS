//
//  TeamCalculator.m
//  Team
//
//  Created by Tom Owen on 6/10/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "TeamCalculator.h"

@interface TeamCalculator ()

@property (nonatomic, strong) NSMutableArray *currentScanLesions;

@end

@implementation TeamCalculator
@synthesize currentLesions = _currentLesions;
@synthesize smallestLesions = _smallestLesions;
@synthesize currentScanLesions = _currentScanLesions;
@synthesize baseLineLesions = _baseLineLesions;
@synthesize tempBase = _tempBase;
@synthesize tableView = _tableView;
@synthesize tempLesionNumberArray = _tempLesionNumberArray;
@synthesize currentScanDate = _currentScanDate;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize overallStatusLabel = _overallStatusLabel;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize targetScanDateArray = _targetScanDateArray;
@synthesize targetLesionNumberArray = _targetLesionNumberArray;
@synthesize targetLesionSizeArray = _targetLesionSizeArray;
@synthesize baseScanDateArray = _baseScanDateArray;
@synthesize baseLesionNumberArray = _baseLesionNumberArray;
@synthesize baseLesionSizeArray = _baseLesionSizeArray;
@synthesize percentIncreaseArray = _percentIncreaseArray;
@synthesize patientID = _patientID;
@synthesize includeAllLesions = _includeAllLesions;
@synthesize totalSizeOfLesions = _totalSizeOfLesions;
@synthesize percentageChanged = _percentageChanged;
@synthesize listOfDates = _listOfDates;
static float totalOfAllCurrentLesions = 0.0;
static float totalOfAllSmallestLesions = 0.0;


// The TeamCalculator will determine disease status by comparing the baseline
// lesions against the previous smallest version of that lesion in a previous scan date.
- (NSMutableArray *)currentScanLesions
{
    if (_currentScanLesions == nil) _currentScanLesions = [[NSMutableArray alloc] init];
    return _currentScanLesions;
}


static NSMutableArray *myStatic = nil;

-(void)performCalculationsOnPatient{
    totalOfAllCurrentLesions = 0.0;
    totalOfAllSmallestLesions = 0.0;
    myStatic = [[NSMutableArray alloc] init];
    // read all the scans for the patientid
    // initialize the arrays for holding all data for calculations
    // reset total size and percentage
    self.targetScanDateArray = Nil;
    self.targetLesionNumberArray = Nil;
    self.targetLesionSizeArray = Nil;
    self.baseScanDateArray = Nil;
    self.baseLesionNumberArray = Nil;
    self.baseLesionSizeArray = Nil;
    self.totalSizeOfLesions = 0;
    self.percentageChanged = 0;
    // set up context
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    NSManagedObjectContext *context = _managedObjectContext;
    // Define our table/entity to use  
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Scan" inManagedObjectContext:context];   
    
    // Setup the fetch request  
    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity:entity];   
    
    // Define how we will sort the records  
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"scan_date" ascending:NO];  
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];  
    [request setSortDescriptors:sortDescriptors];    
    
    // set predicate for this patient
    NSPredicate *pred = nil;
    pred = [NSPredicate predicateWithFormat:@"(scan_patient_id = %@)",self.patientID];
    [request setPredicate:pred];
    
    // Fetch the records and handle an error  
    NSError *error;  
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];   
    
    if (!mutableFetchResults) {  
        // Handle the error.  
        // This is a serious error and should advise the user to restart the application  
    }   
// ********* test code for arrays
/*
    [self setTargetScanDateArray: mutableFetchResults];
    
    id scanDateID = [self.targetScanDateArray objectAtIndex:0];
    NSDate *scanDate = [scanDateID valueForKey:@"scan_date"];
    NSLog(@"0works - how about %@",scanDate);
    id scanDateID1 = [self.targetScanDateArray objectAtIndex:1];
    NSDate *scanDate1 = [scanDateID1 valueForKey:@"scan_date"];
    NSLog(@"1works - how about %@",scanDate1);
    
    NSMutableArray *mylistOfDates = [[NSMutableArray alloc] init];
    [mylistOfDates addObject:scanDate];
    NSString *mystring = [mylistOfDates objectAtIndex:0];
    NSLog(@"works mystring is %@",mystring);
    
    NSDate *test1 = [mutableFetchResults valueForKey:@"scan_date"];
    NSLog(@"From mutuable whole array %@",test1);
    id myobject = [mutableFetchResults objectAtIndex:0];
    NSLog(@"single date object = %@",[myobject valueForKey:@"scan_date"]);
    
    for (id object in mutableFetchResults) {
        NSDictionary *currentObject = (NSDictionary*)object;
        NSDate *scanDate = [currentObject valueForKey:@"scan_date"];
        [self.listOfDates addObject:scanDate];
    }
*/
    /*
    for (id object in self.targetScanDateArray) {
        NSDictionary *currentObject = (NSDictionary*)object;
        NSDate *scanDate = [currentObject valueForKey:@"scan_date"];
        NSLog(@"got scan date %@",scanDate);
    }
*/
// end test code for arrays
// mutableFetched results contains all of the scan dates for this patient
// lets get the most recent one for the current scan
    id scanObject = [mutableFetchResults objectAtIndex:0];
    
    NSDate *date = (NSDate*) [scanObject valueForKey:@"scan_date"];
    
    self.currentScanDate = date;
    NSLog(@"currentScanDate is %@",self.currentScanDate);
// good to go with patientID and scan date
    
// 1st loop get all target lesions into targetLesionNumberArray
    
    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Lesion" inManagedObjectContext:context];
    // Setup the fetch request 
    NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
    [request2 setEntity:entity2];
    
    // Define how we will sort the records  
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"lesion_scan_date" ascending:NO];  
    NSArray *sortDescriptors2 = [NSArray arrayWithObject:sortDescriptor2];  
    [request2 setSortDescriptors:sortDescriptors2];
    
    // set predicate for this patient
    NSPredicate *pred2 = nil;
    if (self.includeAllLesions) {
        pred2 = [NSPredicate predicateWithFormat:@"(lesion_patient_id = %@) and (lesion_scan_date = %@)",self.patientID,self.currentScanDate];
    } else {
        pred2 = [NSPredicate predicateWithFormat:@"(lesion_patient_id = %@) and (lesion_scan_date = %@) and (lesion_target = 'Y')",self.patientID,self.currentScanDate];
    }
    [request2 setPredicate:pred2];
    
    // Fetch the records and handle an error  
    NSError *error2;  
    //NSMutableArray *targetLesionNumberArray1 = [[context executeFetchRequest:request2 error:&error2] mutableCopy];
    self.targetLesionNumberArray = [[context executeFetchRequest:request2 error:&error2] mutableCopy];
    if (!self.targetLesionNumberArray) {  
        // Handle the error.  
        // This is a serious error and should advise the user to restart the application  
    }   
    // all the lesions to be compared against are now in targetLesionNumberArray
    // setup the core data stuff
    // now flip through the targetLesionNumberArray and read the smallest lesion
// end first loop 
    NSLog(@"targetLesionNumberArray is %@",[self.targetLesionNumberArray valueForKey:@"lesion_scan_date"]);
    
    for (id object in self.targetLesionNumberArray) {
        NSLog(@"target display");
    }
    
    NSEntityDescription *entity3;
    NSFetchRequest *request3;
    NSSortDescriptor *sortDescriptor3;
    NSArray *sortDescriptors3;
    NSPredicate *pred3;
    NSDictionary *currentObject;
    NSNumber *tempNumber;
    NSError *error3;
    NSMutableArray *tempBase = [[NSMutableArray alloc] init];
    
    for (id object in self.targetLesionNumberArray) {
        entity3 = [NSEntityDescription entityForName:@"Lesion" inManagedObjectContext:context];
        // Setup the fetch request 
        request3 = [[NSFetchRequest alloc] init];
        [request3 setEntity:entity3];
        // Define how we will sort the records  
        sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"lesion_size" ascending:YES];  
        sortDescriptors3 = [NSArray arrayWithObject:sortDescriptor3];  
        [request3 setSortDescriptors:sortDescriptors3];
        // set predicate for this patient
        pred3 = nil;
        // get lesion number
        currentObject = (NSDictionary *)object;
        tempNumber = [currentObject valueForKey:@"lesion_number"];
        pred3 = [NSPredicate predicateWithFormat:@"(lesion_patient_id = %@) and (lesion_scan_date != %@) and (lesion_number = %@)",self.patientID,self.currentScanDate,tempNumber];
        [request3 setPredicate:pred3];
    
        // Fetch the records and handle an error  
        //NSError *error3;  
        self.tempLesionNumberArray = [[context executeFetchRequest:request3 error:&error3] mutableCopy];
    
        if (!self.tempLesionNumberArray) { 
            NSLog(@"error");
        // Handle the error.  
        // This is a serious error and should advise the user to restart the application  
        }  
        NSUInteger myInt = [self.tempLesionNumberArray count];
        NSLog(@"Count of tempLesionArray is %d",myInt);
        NSLog(@"tempLesionNumberArray is %@",[self.tempLesionNumberArray valueForKey:@"lesion_size"]);
        if (myInt) {
        // get object at 0 it contains the smallest lesion object
        NSLog(@"object at 0 for tempLesionArray is %@",[self.tempLesionNumberArray objectAtIndex:0]);
        [tempBase addObject:[self.tempLesionNumberArray objectAtIndex:0]];
        [myStatic addObject:[self.tempLesionNumberArray objectAtIndex:0]];
        } else {
            // no previous lesion with this number so enter a special object
            NSDictionary *newLesionIndicator = [NSDictionary dictionaryWithObjectsAndKeys:@"X",@"lesion_target",nil];
            [tempBase addObject:newLesionIndicator];
            [myStatic addObject:newLesionIndicator];
        }
    }
 /*   
    for (id object in self.tempLesionNumberArray) {
        NSDictionary *currentObject = (NSDictionary *)object;
        NSLog(@"add to base scandate = %@,lesion number = %@",[currentObject valueForKey:@"lesion_scan_date"], [currentObject valueForKey:@"lesion_number"]);
        // for each lesion # get the smallest size in all the lesions for this patient
        // then add the object to baseLesionNumberArray
        [self.baseLesionNumberArray addObject:object];
    }
*/
    
// now count the total size and difference and percentage and set Response
    for (id object in self.targetLesionNumberArray) {
        NSDictionary *currentObject = (NSDictionary *)object;
        NSNumber *mySize = [currentObject valueForKey:@"lesion_size"];
        totalOfAllCurrentLesions = totalOfAllCurrentLesions + [mySize floatValue];
    }
    for (id object in myStatic) {
        NSDictionary *currentObject = (NSDictionary *)object;
        NSNumber *mySize = [currentObject valueForKey:@"lesion_size"];
        totalOfAllSmallestLesions = totalOfAllSmallestLesions + [mySize floatValue];
    }
    NSLog(@"totalcurrent is %2.2f and totalprevious is %2.2f",totalOfAllCurrentLesions,totalOfAllSmallestLesions);
    float difference = totalOfAllCurrentLesions - totalOfAllSmallestLesions;
    static float totalPercentChanged = 0.0;
    if (totalOfAllSmallestLesions > 0) {
        totalPercentChanged = difference / totalOfAllSmallestLesions *100.0;
    } else {
        totalPercentChanged = 0.0;
    }
    NSString *inc = @"Increase";
    
    
    if (difference < 0) {
        inc = @"Decrease";
    }
    self.overallStatusLabel.text = @"test";
    self.overallStatusLabel.text = [[NSString alloc] initWithFormat:@"%%%2.0f %@ - Current %2.2fmm - Prior %2.2f %@",totalPercentChanged,inc,totalOfAllCurrentLesions,totalOfAllSmallestLesions,@"PR"];
/*
for (id object in tempBase) {
    NSDictionary *currentObject = (NSDictionary *)object;
    NSLog(@"In base scandate = %@,lesion number = %@",[currentObject valueForKey:@"lesion_scan_date"], [currentObject valueForKey:@"lesion_number"]);
    }
*/
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.patientID = [[SharedObject sharedTeamData] getPatientID];
    self.includeAllLesions = NO;
    [self performCalculationsOnPatient];
    
}

- (void)viewDidUnload
{
    [self setOverallStatusLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (IBAction)performCalculationWithAllLesions:(UIButton *)sender {
    TeamLesions *team1 = [[TeamLesions alloc] init]; 
    self.currentLesions = [team1 getCurrentLesions:YES];
    NSLog(@"currentLesions in MainTeam is %@",[self.currentLesions valueForKey:@"lesion_scan_date"]);
    self.smallestLesions = [team1 getSmallestLesions:self.currentLesions];
    NSLog(@"smallestLesions in MainTeam is %@",[self.smallestLesions valueForKey:@"lesion_target"]);
    self.baseLineLesions = [team1 getBaseLineLesions:self.currentLesions];
    NSLog(@"baseLineLesions in MainTeam is %@",[self.baseLineLesions valueForKey:@"lesion_target"]);
    self.includeAllLesions = YES;
    [self performCalculationsOnPatient];
    [self.tableView reloadData];
        
}
- (IBAction)performCalculationWithTargetsOnly:(UIButton *)sender {
    self.includeAllLesions = NO;
    [self performCalculationsOnPatient];
    [self.tableView reloadData];
}
#pragma mark - Scan Table delagates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.targetLesionNumberArray count];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"teamCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    // targetlesionnumberarray is current lesions
    // mystatic is corresponding values from the smallest lesion prior
    // if mystatic contains X in the lesion_target then no previous lesion (new)
    id currentObject = [self.targetLesionNumberArray objectAtIndex:indexPath.row];
    NSString *currentLesionIndicator = [currentObject valueForKey:@"lesion_target"];
    NSNumber *currentNumber = [currentObject valueForKey:@"lesion_number"];
    NSNumber *currentSize = [currentObject valueForKey:@"lesion_size"];
    NSString *typeOfLesion = @"NT"; // non target
    if ([currentLesionIndicator isEqualToString:@"Y"]) {
        typeOfLesion = @"T";
    }
    id smallestObject = [myStatic objectAtIndex:indexPath.row];
    NSString *smallLesionIndicator = [smallestObject valueForKey:@"lesion_target"];
    NSString *smallestDisplayText = nil;
    NSNumber *smallSize = nil;
    if ([smallLesionIndicator isEqualToString:@"X"]) {
        smallestDisplayText = @"New Lesion";
    } else {
        // setup details of smallest
        NSDate *smallDate = [smallestObject valueForKey:@"lesion_scan_date"];
        smallSize = [smallestObject valueForKey:@"lesion_size"];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"MM/dd/yy"];
        NSString *newDateString = [outputFormatter stringFromDate:smallDate];
        smallestDisplayText = [[NSString alloc] initWithFormat:@"On %@ was %@mm",newDateString,smallSize];
    }
    
    // calculate differnece and percentage
    float difference = [currentSize floatValue] - [smallSize floatValue];
    static float percentChange = 0.0;
    if (smallSize > 0) {
        
        percentChange = difference / [smallSize floatValue] *100;
        NSLog(@"percent is calc %2.2f",percentChange);
    } else {
        percentChange = 0.0;
    }
   // NSLog(@"currentsize is %2.2f and smallsize is %2.2f percent = %2.2f",[currentSize floatValue],[smallSize floatValue],percentChange);

    
    
    
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@%@ %@mm %@",typeOfLesion,currentNumber,currentSize,smallestDisplayText];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    NSString *increaseOrDecrease = @"Increase";
    if (difference < 0) {
        increaseOrDecrease = @"Decrease";
    }
    // determine CR PR SD PD New Lesion

    
    
    
    
    
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%2.2fmm %%%2.0f %@",difference,percentChange,increaseOrDecrease];
    if ([smallLesionIndicator isEqualToString:@"X"]) {
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
     //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM/dd/yy"];
    NSString *newDateString = [outputFormatter stringFromDate:self.currentScanDate];
    NSString *heading = [[SharedObject sharedTeamData] getPatientName];
    NSString *heading2 = [[NSString alloc] initWithFormat:@"%@ (%@)", heading,newDateString];
    
    return heading2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // set lesion_number
    //NSNumber *myNumber = (NSNumber *) [object valueForKey:@"lesion_number"];
    //[[SharedObject sharedTeamData] setLesionNumber:myNumber];
    //[self performSegueWithIdentifier:@"editLesion" sender:self];
    
}

@end
