//
//  SetSettings.m
//  Team
//
//  Created by Tom Owen on 6/9/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "SetSettings.h"

@interface SetSettings ()

@end

@implementation SetSettings
@synthesize settingsArray = _settingsArray;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize serverInputURL = _serverInputURL;
@synthesize imageType = _imageType;
@synthesize docType = _docType;
@synthesize saveStatusLabel = _saveStatusLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
- (BOOL)doesSettingsAlreadyExist:(NSManagedObjectContext *)context
{
    // Define our table/entity to use  
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:context];   
    
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
        // Handle the error.  
        // This is a serious error and should advise the user to restart the application  
    }   
    [self setSettingsArray: mutableFetchResults];
    
    if ([self.settingsArray count] == 0) {
        NSLog(@"count 0, add settings");
        
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:context];
        [newManagedObject setValue:@"http://yourserver.com/yourfolder/" forKey:@"server_url"];
        [newManagedObject setValue:@"jpg" forKey:@"image_type"];
        [newManagedObject setValue:@"doc" forKey:@"doc_type"];
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        return NO;
    } else {
        
        for (id object in self.settingsArray) {
            NSDictionary *currentObject = (NSDictionary*)object;
            NSString *serverURL = [currentObject valueForKey:@"server_url"];
            NSString *imageType  = [currentObject valueForKey:@"image_type"];
            NSString *docType = [currentObject valueForKey:@"doc_type"];
            self.serverInputURL.text = serverURL;
            self.imageType.text = imageType;
            self.docType.text = docType;
        }
        return YES;
    }
    
}

- (IBAction)saveSettings:(UIBarButtonItem *)sender {
    
    if ([self.serverInputURL.text length] < 1) { 
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Please enter the Server URL" 
                       message:@"Please Re-enter the Server URL" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    if ([self.docType.text length] < 1) { 
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Please enter the Document type" 
                       message:@"Please Re-enter the Document type" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }
    if ([self.serverInputURL.text length] < 1) { 
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc] 
                       initWithTitle: @"Please enter the Image Type" 
                       message:@"Please Re-enter the Image Type" 
                       delegate: nil 
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        
        [alertDialog show];
        return;
    }

    // set up context
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    
    
    NSManagedObjectContext *context = _managedObjectContext; 
    NSEntityDescription *entityDesc = 
    [NSEntityDescription entityForName:@"Settings" 
                inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request 
                                              error:&error];
    if ([objects count] == 0) {
        NSLog( @"No matches....Error in settings record");
    } else {
        matches = [objects objectAtIndex:0];
        [matches setValue:self.serverInputURL.text forKey:@"server_url"];
        [matches setValue:self.imageType.text forKey:@"image_type"];
        [matches setValue:self.docType.text forKey:@"doc_type"];
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

        [self.saveStatusLabel setText:@"Ok, Saved!"];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // check if settings exist if not then add a default set
    // check to see if ID already exists
    // set up context
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    NSManagedObjectContext *context = _managedObjectContext; 
    if (![self doesSettingsAlreadyExist:context]) { 
        [self.saveStatusLabel setText:@"New Settings"];
        self.serverInputURL.text = @"http://yourserver.com/yourfolder/";
        self.imageType.text = @"jpg";
        self.docType.text = @"doc";
    }
    
}

- (void)viewDidUnload
{
    [self setServerInputURL:nil];
    [self setImageType:nil];
    [self setDocType:nil];
    [self setSaveStatusLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
-(void)addDemoLesions{
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Lesion" ofType:@"json"];
    NSArray* lesions = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
    NSLog(@"Imported lesions: %@", lesions);
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    NSManagedObjectContext *context = _managedObjectContext;
    [lesions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *lesion_patient_id = [obj objectForKey:@"lesion_patient_id"];
        NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
        [inFormat setDateFormat:@"MM/dd/yy"];
        NSString *dateInput = [obj objectForKey:@"lesion_scan_date"];
        NSDate *lesion_scan_date = [inFormat dateFromString:dateInput];
        
        NSString *lesion_numberInput = [obj objectForKey:@"lesion_number"];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *lesion_number = [f numberFromString:lesion_numberInput];
       
        NSString *lesion_sizeInput = [obj objectForKey:@"lesion_size"];
        NSNumberFormatter *f2 = [[NSNumberFormatter alloc] init];
        [f2 setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *lesion_size = [f numberFromString:lesion_sizeInput];
        
        NSString *lesion_comment = [obj objectForKey:@"lesion_comment"];
        NSString *lesion_target = [obj objectForKey:@"lesion_target"];
        NSString *lesion_node = [obj objectForKey:@"lesion_node"];
        NSString *lesion_media_type = [obj objectForKey:@"lesion_media_type"];
        NSString *lesion_media_online = [obj objectForKey:@"lesion_media_online"];
        
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Lesion" inManagedObjectContext:context];
        [newManagedObject setValue:lesion_patient_id forKey:@"lesion_patient_id"];
        [newManagedObject setValue:lesion_scan_date forKey:@"lesion_scan_date"];
        [newManagedObject setValue:lesion_number forKey:@"lesion_number"];
        [newManagedObject setValue:lesion_size forKey:@"lesion_size"];
        [newManagedObject setValue:lesion_comment forKey:@"lesion_comment"];
        [newManagedObject setValue:lesion_target forKey:@"lesion_target"];
        [newManagedObject setValue:lesion_node forKey:@"lesion_node"];
        [newManagedObject setValue:lesion_media_type forKey:@"lesion_media_type"];
        [newManagedObject setValue:lesion_media_online forKey:@"lesion_media_online"];
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc] 
                           initWithTitle: @"TEAM had a System Problem Saving Settings Data" 
                           message:@"The TEAM App will log the error and terminate. Check your network/iCloud settings and contact support for further help" 
                           delegate: nil
                           cancelButtonTitle: @"Ok"
                           otherButtonTitles: nil];
            [alertDialog show];
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        }
        
    }];
}
-(void)addDemoStudies{
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Studies" ofType:@"json"];
    NSArray* studies = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
    NSLog(@"Imported studies: %@", studies);
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    NSManagedObjectContext *context = _managedObjectContext;
    [studies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *study_id = [obj objectForKey:@"study_id"];
        NSString *study_owner = [obj objectForKey:@"study_owner"];
        NSString *study_name = [obj objectForKey:@"study_name"];
        NSString *study_url = [obj objectForKey:@"study_url"];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Studies" inManagedObjectContext:context];
        [newManagedObject setValue:study_id forKey:@"study_id"];
        [newManagedObject setValue:study_owner forKey:@"study_owner"];
        [newManagedObject setValue:study_name forKey:@"study_name"];
        [newManagedObject setValue:study_url forKey:@"study_url"];
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }];
}
-(void)addDemoSettings{
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"json"];
    NSArray* settings = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
    NSLog(@"Imported settings: %@", settings);
    
    [settings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *server_url = [obj objectForKey:@"server_url"];
        NSString *image_type = [obj objectForKey:@"image_type"];
        NSString *doc_type = [obj objectForKey:@"doc_type"];
        
        // get the settings record and update the values
        if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
        NSManagedObjectContext *context = _managedObjectContext;
        NSEntityDescription *entityDesc = 
        [NSEntityDescription entityForName:@"Settings" 
                    inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSManagedObject *matches = nil;
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request 
                                                  error:&error];
        if ([objects count] == 0) {
            NSLog( @"No matches");
        } else {
            matches = [objects objectAtIndex:0];
            //NSString *count = [NSString stringWithFormat:@"%d matches found",[objects count]];
            //NSLog(@"%@",count);
            [matches setValue:server_url forKey:@"server_url"];
            [matches setValue:image_type forKey:@"image_type"];
            [matches setValue:doc_type forKey:@"doc_type"];
            // Save the context.
            NSLog(@"setting settings.......");
            NSError *error = nil;
            if (![context save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }];
}
-(void)addDemoDoctors{
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Doctor" ofType:@"json"];
    NSArray* doctors = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
    NSLog(@"Imported doctors: %@", doctors);
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    NSManagedObjectContext *context = _managedObjectContext;
    [doctors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *name = [obj objectForKey:@"doctor_name"];
        NSString *info = [obj objectForKey:@"doctor_info"];
        NSLog(@"name=%@,info=%@",name,info);
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Doctor" inManagedObjectContext:context];
        [newManagedObject setValue:name forKey:@"doctor_name"];
        [newManagedObject setValue:info forKey:@"doctor_info"];
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }];
}
-(void)addDemoPatients{
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Patient" ofType:@"json"];
    NSArray* patients = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
    NSLog(@"Imported Patients: %@", patients);
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    NSManagedObjectContext *context = _managedObjectContext;
    [patients enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *patient_id = [obj objectForKey:@"patient_id"];
        NSString *patient_name = [obj objectForKey:@"patient_name"];
        NSString *patient_study_id = [obj objectForKey:@"patient_study_id"];
        NSString *patient_doctor = [obj objectForKey:@"patient_doctor"];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:context];
        [newManagedObject setValue:patient_id forKey:@"patient_id"];
        [newManagedObject setValue:patient_name forKey:@"patient_name"];
        [newManagedObject setValue:patient_study_id forKey:@"patient_study_id"];
        [newManagedObject setValue:patient_doctor forKey:@"patient_doctor"];
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

    }];
    
}
-(void)addDemoScans{
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Scan" ofType:@"json"];
    NSArray* scans = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
    NSLog(@"Imported Scans: %@", scans);
    if (_managedObjectContext == nil) { _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; }
    NSManagedObjectContext *context = _managedObjectContext;
    [scans enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *scan_patient_id = [obj objectForKey:@"scan_patient_id"];
        NSString *dateInput = [obj objectForKey:@"scan_date"];
        NSString *reportOnline = [obj objectForKey:@"scan_report_online"];
        NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
        [inFormat setDateFormat:@"MM/dd/yy"];
        NSDate *scan_date = [inFormat dateFromString:dateInput];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Scan" inManagedObjectContext:context];
        [newManagedObject setValue:scan_patient_id forKey:@"scan_patient_id"];
        [newManagedObject setValue:scan_date forKey:@"scan_date"];
        [newManagedObject setValue:reportOnline forKey:@"scan_report_online"];
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
	//NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    NSLog(@"button is %d",buttonIndex);
    
    if (buttonIndex == 0) {
		NSLog(@"Deleting Patient and Data");
        [self addDemoDoctors];
        [self addDemoPatients];
        [self addDemoLesions];
        [self addDemoSettings];
        [self addDemoStudies];
        [self addDemoScans];
    }
}

- (IBAction)loadDemoFiles:(UIButton *)sender {
    UIActionSheet *actionSheet;
    actionSheet=[[UIActionSheet alloc] initWithTitle:@""
                                            delegate:self
                                   cancelButtonTitle:@"Cancel" 
                              destructiveButtonTitle:@"Delete and Reload Demo Data"
                                   otherButtonTitles:nil];
    actionSheet.actionSheetStyle=UIActionSheetStyleDefault;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}
@end
