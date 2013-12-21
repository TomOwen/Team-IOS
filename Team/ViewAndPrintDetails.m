//
//  ViewAndPrintDetails.m
//  Team
//
//  Created by Tom Owen on 8/10/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "ViewAndPrintDetails.h"

@interface ViewAndPrintDetails ()

@end

@implementation ViewAndPrintDetails
@synthesize pline1 = _pline1;
@synthesize pline2 = _pline2;
@synthesize pline3 = _pline3;
@synthesize pline4 = _pline4;
@synthesize pline5 = _pline5;
@synthesize pline6 = _pline6;
@synthesize pline7 = _pline7;
@synthesize plinePD = _plinePD;
@synthesize plinePR = _plinePR;
@synthesize companyName = _companyName;
@synthesize lesion_number = _lesion_number;
@synthesize scan_date = _scan_date;
@synthesize lesion_target = _lesion_target;
@synthesize lymph_node = _lymph_node;
@synthesize comment = _comment;
@synthesize lesion_size = _lesion_size;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize objects = _objects;
@synthesize patient_study_id = _patient_study_id;
@synthesize patient_doctor = _patient_doctor;
@synthesize patient_name = _patient_name;
@synthesize study_name = _study_name;
@synthesize study_owner = _study_owner;
@synthesize report = _report;
@synthesize webView = _webView;
@synthesize printLine1 = _printLine1;
@synthesize printLine2 = _printLine2;
@synthesize printPatientID = _printPatientID;
@synthesize printSummaryLine = _printSummaryLine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setPatientID:(NSString *)patientID setLine1:(NSString *)line1 setLine2:(NSString *)line2 setLine3:(NSString *)line3 setLine4:(NSString *)line4 setLine5:(NSString *)line5 setLine6:(NSString *)line6 setLine7:(NSString *)line7 setPR:(NSString *)percentPR setPD:(NSString *)percentPD{
    NSLog(@"%@",patientID);
    NSLog(@"%@",line1);
    NSLog(@"%@",line2);
    NSLog(@"%@",line3);
    NSLog(@"%@",line4);
    NSLog(@"%@",line5);
    NSLog(@"%@",line6);
    NSLog(@"%@",line7);
    self.printPatientID = patientID;
    self.printSummaryLine = line1;
    self.printLine1 = line2;
    self.printLine2 = line3;
    self.pline1 = line1;
    self.pline2 = line2;
    self.pline3 = line3;
    self.pline4 = line4;
    self.pline5 = line5;
    self.pline6 = line6;
    self.pline7 = line7;
    self.plinePR = percentPR;
    self.plinePD = percentPD;
}

- (IBAction)printDetails:(UIBarButtonItem *)sender {
    // Get the print job class
    UIPrintInteractionController *pc = [UIPrintInteractionController
                                        sharedPrintController];
    
    // set up basic options
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Patient Scan Detail and RECIST Response";
    pc.printInfo = printInfo;
    pc.showsPageRange = YES;
    
    // give the webview to be printed
    UIViewPrintFormatter *formatter = [self.webView viewPrintFormatter];
    pc.printFormatter = formatter;
    
    // code to run after printer to see if it failed
    UIPrintInteractionCompletionHandler completionHandler = 
    ^(UIPrintInteractionController *printController, BOOL completed,
      NSError *error) {
        if(!completed && error){
            NSLog(@"Print failed - domain: %@ error code %u", error.domain,
                  error.code); 
        }
    };
    
    // bring up the AirPrint dialog
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [pc presentFromBarButtonItem:sender animated:YES completionHandler:completionHandler];

    } else {
    [pc presentAnimated:YES completionHandler:completionHandler];
    }

    
}
-(void)createScanDetail{
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    NSManagedObjectContext *context = _managedObjectContext;
    // Define our table/entity to use  
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Lesion" inManagedObjectContext:context];   
    
    // Setup the fetch request  
    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity:entity];   
    
    // Define how we will sort the records  
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lesion_number" ascending:YES];  
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];  
    [request setSortDescriptors:sortDescriptors];    
    
    // set predicate for this patient
    NSPredicate *pred = nil;
    pred = [NSPredicate predicateWithFormat:@"(lesion_patient_id = %@) and (lesion_scan_date = %@)",self.printPatientID,self.scan_date];
    [request setPredicate:pred];
    
    // Fetch the records and handle an error  
    NSError *error;  
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {  
        // Handle the error.  
        // This is a serious error and should advise the user to restart the application  
    }  
    if (![mutableFetchResults count]) {
        NSLog(@"Patient not found");
    }
    int numberOfLesions = [mutableFetchResults count];
    float totalSize = 0;
    for (int i = 0; i < numberOfLesions; i++) {
        NSManagedObject *lesionObject = [mutableFetchResults objectAtIndex:i];
        self.lesion_number = [lesionObject valueForKey:@"lesion_number"];
        self.lesion_size = [lesionObject valueForKey:@"lesion_size"];
        totalSize = totalSize + [self.lesion_size floatValue];
        self.comment = [lesionObject valueForKey:@"lesion_comment"];
        NSString *myTarget = [lesionObject valueForKey:@"lesion_target"];
        if ([myTarget isEqualToString:@"Y"]) {
            self.lesion_target = @"Target";
        } else {
            self.lesion_target = @"Non Target";
        }
        NSString *myNode = [lesionObject valueForKey:@"lesion_node"];
        if ([myNode isEqualToString:@"Y"]) {
            self.lymph_node = @"Lymph Node";
            // subtract 10mm (size of normal lympth) to calculate disease
            totalSize = totalSize -10;
            if (totalSize < 0) totalSize = 0;
        } else {
            self.lymph_node = @"Lesion";
        }
        NSLog(@"%@ #%d,%@,%@,%@",self.lesion_target,i,self.lymph_node,self.lesion_size,self.comment);
        // add lesion detail to page
        NSString *scanLesionDetail = @"<tr><td align=\"center\" valign=\"top\">%@ #%@<br></td><td align=\"center\" valign=\"top\">%@<br></td><td align=\"center\" valign=\"top\">%@<br></td><td valign=\"top\">%@<br></td></tr>";
        NSString *formatted = [[NSString alloc] initWithFormat:scanLesionDetail,self.lesion_target,self.lesion_number,self.lymph_node,self.lesion_size,self.comment];
        self.report =[self.report stringByAppendingString:formatted];
        
    }
    // do total line
    NSLog(@"total is %1.1f",totalSize);
    NSString *scanLesionTotal = @"<tr><td align=\"center\" valign=\"top\">%@<br></td><td align=\"center\" valign=\"top\"><b><font color=\"#3366ff\">%@</font></b><br></td><td align=\"center\" valign=\"top\"><font color=\"#3366ff\">%1.1f</font></b><br></td><td valign=\"top\">%@<br></td></tr></table>";
    NSString *formatted2 = [[NSString alloc] initWithFormat:scanLesionTotal,@" ",@"Total",totalSize,@" "];
    self.report =[self.report stringByAppendingString:formatted2];
    

    
}
-(int)calculateWeekDifference:(NSDate *)baseDate scanDate:(NSDate *)scanDate{
    unsigned flags = NSDayCalendarUnit;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:baseDate toDate:scanDate options:0];
    int weeks = ([difference day] / 7) +1;
    return weeks;
}
-(void)createScanHeader{
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
    pred = [NSPredicate predicateWithFormat:@"(scan_patient_id = %@)",self.printPatientID];
    [request setPredicate:pred];
    
    // Fetch the records and handle an error  
    NSError *error;  
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {  
        // Handle the error.  
        // This is a serious error and should advise the user to restart the application  
    }  
    if (![mutableFetchResults count]) {
        NSLog(@"Patient not found");
    }
    int numberOfScans = [mutableFetchResults count];
    for (int i = 0; i < numberOfScans; i++) {
        NSManagedObject *scanObject = [mutableFetchResults objectAtIndex:i];
        NSDate *scan_date_print = [scanObject valueForKey:@"scan_date"];
        int base = numberOfScans - 1;
        NSManagedObject *scanObject2 = [mutableFetchResults objectAtIndex:base];
        NSDate *baseDate = [scanObject2 valueForKey:@"scan_date"];
        NSLog(@" scan %@,%@",scan_date_print,baseDate);
        int weeks = [self calculateWeekDifference:baseDate scanDate:scan_date_print];
        NSLog(@"Weeks between dates %d",weeks);
        
        // add scan header to report and header for scan detail
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
        NSString *newDateString = [outputFormatter stringFromDate:scan_date_print];
        //NSString *scanHeader = @"</font><div align=\"left\"><div align=\"center\"><font color=\"#3366ff\"><u><big><b>%@ - Scan Date: %@ - Week Number %d</b></big></u></font><br></div><br><table align=\"center\" border=\"1\" cellpadding=\"2\" cellspacing=\"2\"width=\"75%%\"><tbody><tr><td align=\"center\" valign=\"top\">Target/Non-Target<br></td><td align=\"center\" valign=\"top\">Lesion/Lymph Node<br></td><td align=\"center\" valign=\"top\">Size in MM<br></td><td valign=\"top\">Comments<br></td></tr>";
        
        NSString *scanHeader = @"<br><br></font><font color=\"#3366ff\"><u><big><b>%@ - Scan Date: %@ - Week Number %d</b></big></u></font><br><br><table align=\"center\" border=\"1\" cellpadding=\"2\" cellspacing=\"2\"width=\"75%%\"><tbody><tr><td align=\"center\" valign=\"top\">Target/Non-Target<br></td><td align=\"center\" valign=\"top\">Lesion/Lymph Node<br></td><td align=\"center\" valign=\"top\">Size in MM<br></td><td valign=\"top\">Comments<br></td></tr>";
        
        
        NSString *formatted = [[NSString alloc] initWithFormat:scanHeader,self.patient_name,newDateString,weeks];
        self.report =[self.report stringByAppendingString:formatted];
        self.scan_date = scan_date_print;
        [self createScanDetail];
        
    }
    
}
-(void)createHeader{
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    NSManagedObjectContext *context = _managedObjectContext;
    // Define our table/entity to use  
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext:context];   
    
    // Setup the fetch request  
    NSFetchRequest *request = [[NSFetchRequest alloc] init];  
    [request setEntity:entity];   
    
    // Define how we will sort the records  
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"patient_id" ascending:NO];  
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];  
    [request setSortDescriptors:sortDescriptors];    
    
    // set predicate for this patient
    NSPredicate *pred = nil;
    pred = [NSPredicate predicateWithFormat:@"(patient_id = %@)",self.printPatientID];
    [request setPredicate:pred];
    
    // Fetch the records and handle an error  
    NSError *error;  
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {  
        // Handle the error.  
        // This is a serious error and should advise the user to restart the application  
    }  
    if (![mutableFetchResults count]) {
        NSLog(@"Patient not found");
    }
    id patientObject = [mutableFetchResults objectAtIndex:0];
    //NSManagedObject *patient = [patientObject objectAtIndex:0];
    self.patient_name = [patientObject valueForKey:@"patient_name"];
    self.patient_doctor = [patientObject valueForKey:@"patient_doctor"];
    self.patient_study_id = [patientObject valueForKey:@"patient_study_id"];
    
    // now for study data
    // Define our table/entity to use  
    
    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Studies" inManagedObjectContext:context];   
    
    // Setup the fetch request  
    NSFetchRequest *request2 = [[NSFetchRequest alloc] init];  
    [request2 setEntity:entity2];   
    
    // Define how we will sort the records  
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"study_id" ascending:NO];  
    NSArray *sortDescriptors2 = [NSArray arrayWithObject:sortDescriptor2];  
    [request2 setSortDescriptors:sortDescriptors2];    
    
    // set predicate for this patient
    NSPredicate *pred2 = nil;
    pred2 = [NSPredicate predicateWithFormat:@"(study_id = %@)",self.patient_study_id];
    [request2 setPredicate:pred2];
    
    // Fetch the records and handle an error  
    NSError *error2;  
    NSMutableArray *mutableFetchResults2 = [[context executeFetchRequest:request2 error:&error2] mutableCopy];
    if (!mutableFetchResults2) {  
        // Handle the error.  
        // This is a serious error and should advise the user to restart the application  
    }  
    if (![mutableFetchResults2 count]) {
        NSLog(@"Study not found");
    }
    int numberRead = [mutableFetchResults2 count];
    self.study_name = @"n/a";
    self.study_owner = @"n/a";
    if (numberRead) {
        id studyObject = [mutableFetchResults2 objectAtIndex:0];
        self.study_owner = [studyObject valueForKey:@"study_owner"];
        self.study_name = [studyObject valueForKey:@"study_name"];
    }
// now format page header
    //self.jsonRecord = [self.jsonRecord stringByAppendingString:@"]"];
    NSString *header = @"<html><head><meta content=\"text/html; charset=ISO-8859-1\"http-equiv=\"Content-Type\"><title>TEAM Response Report</title></head><body><div align=\"center\"><big><b><big>%@</big></big></b><br><b><big>TEAM - RECIST Response Report - as of %@<br>Patient: %@ Patient ID#: %@</big></b><br><b><big>Doctor: %@ Study:%@ - %@ / %@<br>%@<br>%@</big></b><br><br><big><b><big>%@<br><br></big>%@<br>%@<br>%@<br><br>%@<br>%@<br>%@</b></big><br>";
    
    //NSString *header = @"<html><head><meta content=\"text/html; charset=ISO-8859-1\"http-equiv=\"Content-Type\"><title>TEAM Response Report</title></head><body><b><big>TEAM - RECIST Response Report - as of %@<br><br>Patient: %@ Patient ID#: %@</big></b><br><br><b><big>Doctor: %@ Study:%@ - %@ / %@</big></b><br><br><big><b>%@<br>%@<br>%@</b></big><br>";
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
    NSString *newDateString = [outputFormatter stringFromDate:currentDate];
    NSString *formatted = [[NSString alloc] initWithFormat:header,self.companyName,newDateString,self.patient_name,self.printPatientID,self.patient_doctor,self.patient_study_id,self.study_owner,self.study_name,self.plinePR,self.plinePD,self.pline1,self.pline2,self.pline3,self.pline4,self.pline5,self.pline6,self.pline7];
    self.report = formatted;
       
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSString *temp = @"<html><head><meta content=\"text/html; charset=ISO-8859-1\"http-equiv=\"Content-Type\"><title></title></head><body><div align=\"center\"><font color=\"#666666\"><b><big><big>%@<br>%@<br>%@<br>%@</big></big></b></font><br></div></body></html>";
    //NSString *page = [[NSString alloc] initWithFormat:temp,self.printPatientID,self.printSummaryLine,self.printLine1,self.printLine2];
    //NSLog(@"page=%@",page);
    //[self.webView loadHTMLString:page baseURL:nil];
    // get company name
    NSArray *settings = [RetrieveSettings readSettings];
    self.companyName = nil;
    for (id object in settings) {
        NSDictionary *currentObject = (NSDictionary*)object;
        self.companyName = [currentObject valueForKey:@"company_name"];
    }

    
    
    
    
    [self createHeader];
    [self createScanHeader];
    // add end html code to report
    NSString *endHtml = @"</tbody></table><br></body></html>";
    //self.jsonRecord = [self.jsonRecord stringByAppendingString:@"]"];
    self.report =[self.report stringByAppendingString:endHtml];
    NSLog(@"report=%@",self.report);
    [self.webView loadHTMLString:self.report baseURL:nil];

}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
