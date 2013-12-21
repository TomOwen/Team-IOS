//
//  TeamLesions.m
//  Team
//
//  Created by Tom Owen on 6/14/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "TeamLesions.h"

@interface TeamLesions ()

@end

@implementation TeamLesions
@synthesize managedObjectContext = _managedObjectContext;
@synthesize patientID = _patientID;
@synthesize currentScanDate = _currentScanDate;
@synthesize currentLesions = _currentLesions;

@synthesize tempLesionNumberArray = _tempLesionNumberArray;
@synthesize baseDate = _baseDate;
-(NSMutableArray *)getCurrentLesions:(NSString *)includeAllLesions {
    self.patientID = [[SharedObject sharedTeamData] getPatientID];
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
    if (![mutableFetchResults count]) {
        self.currentLesions = nil;
        return self.currentLesions;
    }
    id scanObject = [mutableFetchResults objectAtIndex:0];
    NSDate *date = (NSDate*) [scanObject valueForKey:@"scan_date"];
    id scanobject2 = [mutableFetchResults objectAtIndex:[mutableFetchResults count] - 1];
    self.baseDate = (NSDate *) [scanobject2 valueForKey:@"scan_date"];
    
    self.currentScanDate = date;
    NSLog(@"currentScanDate is %@",self.currentScanDate);
    // good to go with patientID and scan date
    
    // 1st loop get all target lesions into targetLesionNumberArray
    
    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Lesion" inManagedObjectContext:context];
    // Setup the fetch request 
    NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
    [request2 setEntity:entity2];
    
    // Define how we will sort the records  
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"lesion_number" ascending:YES];  
    NSArray *sortDescriptors2 = [NSArray arrayWithObject:sortDescriptor2];

    [request2 setSortDescriptors:sortDescriptors2];
    
    // set predicate for this patient
    // includeAllLesions Y for all, T for Target only, N for Non Target Only
    NSPredicate *pred2 = nil;
    if ([includeAllLesions isEqualToString:@"Y"]) {
        pred2 = [NSPredicate predicateWithFormat:@"(lesion_patient_id = %@) and (lesion_scan_date = %@)",self.patientID,self.currentScanDate];
    }
    if ([includeAllLesions isEqualToString:@"T"]) {
        pred2 = [NSPredicate predicateWithFormat:@"(lesion_patient_id = %@) and (lesion_scan_date = %@) and (lesion_target = 'Y')",self.patientID,self.currentScanDate];
    }
    if ([includeAllLesions isEqualToString:@"N"]) {
        pred2 = [NSPredicate predicateWithFormat:@"(lesion_patient_id = %@) and (lesion_scan_date = %@) and (lesion_target = 'N')",self.patientID,self.currentScanDate];
    }
         
    [request2 setPredicate:pred2];
    
    // Fetch the records and handle an error  
    NSError *error2;  
    self.currentLesions = [[context executeFetchRequest:request2 error:&error2] mutableCopy];
    if (!self.currentLesions) {  
        // Handle the error.  
        // This is a serious error and should advise the user to restart the application  
    }   
    // all the lesions to be compared against are now in targetLesionNumberArray
    // setup the core data stuff
    // now flip through the targetLesionNumberArray and read the smallest lesion
    // end first loop 
    //NSLog(@"currentLesions is %@",[self.currentLesions valueForKey:@"lesion_scan_date"]);
    return self.currentLesions;

}
-(NSMutableArray *)getSmallestLesions:(NSMutableArray *)currentLesions {
    NSEntityDescription *entity3;
    NSFetchRequest *request3;
    NSSortDescriptor *sortDescriptor3;
    NSSortDescriptor *sortDescriptor4;
    //NSArray *sortDescriptors3;
    NSPredicate *pred3;
    NSDictionary *currentObject;
    NSNumber *tempNumber;
    NSError *error3;
    NSMutableArray *tempBase = [[NSMutableArray alloc] init];
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    NSManagedObjectContext *context = _managedObjectContext;
    id scanObject = [currentLesions objectAtIndex:0];
    NSDate *date = (NSDate*) [scanObject valueForKey:@"lesion_scan_date"];
    
    self.currentScanDate = date;
    NSLog(@"currentScanDate is %@",self.currentScanDate);
    self.patientID = [[SharedObject sharedTeamData] getPatientID];
    
    for (id object in currentLesions) {
        entity3 = [NSEntityDescription entityForName:@"Lesion" inManagedObjectContext:context];
        // Setup the fetch request 
        request3 = [[NSFetchRequest alloc] init];
        [request3 setEntity:entity3];
        // Define how we will sort the records  
        sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"lesion_size" ascending:YES];
        sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"lesion_scan_date" ascending:YES];
        
        NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor3,sortDescriptor4, nil] ;
        
        //sortDescriptors3 = [NSArray arrayWithObject:sortDescriptor3];  
        [request3 setSortDescriptors:sortDescriptors];
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
        //NSLog(@"tempLesionNumberArray is %@",[self.tempLesionNumberArray valueForKey:@"lesion_size"]);
        if (myInt) {
            // get object at 0 it contains the smallest lesion object
            //NSLog(@"object at 0 for tempLesionArray is %@",[self.tempLesionNumberArray objectAtIndex:0]);
            [tempBase addObject:[self.tempLesionNumberArray objectAtIndex:0]];
            //[myStatic addObject:[self.tempLesionNumberArray objectAtIndex:0]];
        } else {
            // no previous lesion with this number so enter a special object
            NSDictionary *newLesionIndicator = [NSDictionary dictionaryWithObjectsAndKeys:@"X",@"lesion_target",nil];
            [tempBase addObject:newLesionIndicator];
            //[myStatic addObject:newLesionIndicator];
        }
    }
    return tempBase;
}
-(NSMutableArray *)getBaseLineLesions:(NSMutableArray *)currentLesions {
    NSEntityDescription *entity3;
    NSFetchRequest *request3;
    NSSortDescriptor *sortDescriptor3;
    NSArray *sortDescriptors3;
    NSPredicate *pred3;
    NSDictionary *currentObject;
    NSNumber *tempNumber;
    NSError *error3;
    NSMutableArray *tempBase = [[NSMutableArray alloc] init];
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    NSManagedObjectContext *context = _managedObjectContext;
    //id scanObject = [currentLesions objectAtIndex:0];
    // need to get earliest scandate
    //id scanObject = [currentLesions objectAtIndex:[currentLesions count] - 1];
    //NSDate *date = (NSDate*) [scanObject valueForKey:@"lesion_scan_date"];
    
    self.currentScanDate = self.baseDate;
    NSLog(@"baseLineScanDate is %@",self.currentScanDate);
    self.patientID = [[SharedObject sharedTeamData] getPatientID];
    
    for (id object in currentLesions) {
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
        pred3 = [NSPredicate predicateWithFormat:@"(lesion_patient_id = %@) and (lesion_scan_date = %@) and (lesion_number = %@)",self.patientID,self.currentScanDate,tempNumber];
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
        //NSLog(@"tempLesionNumberArray is %@",[self.tempLesionNumberArray valueForKey:@"lesion_size"]);
        if (myInt) {
            // get object at 0 it contains the smallest lesion object
            //NSLog(@"object at 0 for tempLesionArray is %@",[self.tempLesionNumberArray objectAtIndex:0]);
            [tempBase addObject:[self.tempLesionNumberArray objectAtIndex:0]];
            //[myStatic addObject:[self.tempLesionNumberArray objectAtIndex:0]];
        } else {
            // no previous lesion with this number so enter a special object
            NSDictionary *newLesionIndicator = [NSDictionary dictionaryWithObjectsAndKeys:@"X",@"lesion_target",nil];
            [tempBase addObject:newLesionIndicator];
            //[myStatic addObject:newLesionIndicator];
        }
    }
    return tempBase;
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
