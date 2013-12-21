//
//  LogonViewController.m
//  Team
//
//  Created by Tom Owen on 5/30/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "LogonViewController.h"

@interface LogonViewController ()

@end

@implementation LogonViewController
@synthesize initializing = _initializing;
@synthesize callBack = _callBack;
@synthesize saveEmail = _saveEmail;
@synthesize checkbox = _checkbox;
@synthesize defaults = _defaults;
@synthesize userName = _userName;
@synthesize userPassword = _userPassword;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    //
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *teamuser = [defaults objectForKey:@"teamuser"];
    NSString *teampassword = [defaults objectForKey:@"teampassword"];
    self.userName.text = teamuser;
    self.userPassword.text = teampassword;
    
    [RKClient clientWithBaseURLString:@"http://www.websoftmagic.com"];
    [RKClient sharedClient].username = @"team_admin" ;
    [RKClient sharedClient].password = @"Teamdb143143" ;
    [RKClient sharedClient].requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
}
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    
    if ([response isOK]) {
        // Success! Let's take a look at the data
        //NSLog(@"Retrieved XML: %@", [response bodyAsString]);
        BOOL isUserValid = [self checkLoginResults:[response bodyAsString]];
        if (!isUserValid) {
            self.initializing.text = @"";
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: @"Sorry, that user/password not valid"
                           message:@"Try again, or contact your administrator for help"
                           delegate: nil
                           cancelButtonTitle: @"Ok"
                           otherButtonTitles: nil];
            [alertDialog show];
            return;
        }
        // here if user is ok
        // good login now set user/password if user wants to save it
        NSString *myuser = [[NSString alloc] initWithFormat:@"%@",self.userName.text];
        NSString *mypass = [[NSString alloc] initWithFormat:@"%@",self.userPassword.text];
        
        
        self.defaults = [NSUserDefaults standardUserDefaults];
        if (!self.checkbox.isChecked) {
            [self.defaults setObject:myuser forKey:@"teamuser"];
            [self.defaults setObject:mypass forKey:@"teampassword"];
        } else {
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"teammenu" sender:self];
        return;
    }
    // here if response was not valid
    self.initializing.text = @"";
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"Did not get a proper response from TEAM"
                   message:@"Try again, or contact your administrator for help"
                   delegate: nil
                   cancelButtonTitle: @"Ok"
                   otherButtonTitles: nil];
    [alertDialog show];
    return;
}
- (void)viewDidUnload
{
    [self setUserName:nil];
    [self setUserPassword:nil];
    [self setInitializing:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"teammenu"]) {
        
        //NSLog(@"Loging on with no check");
    }
}
*/
/*
- (void) checkSentEmail:(NSArray *)objects {
    int count = [objects count];
    if (count) {
        Results* response = [objects objectAtIndex:0];
        if ([response.succeed isEqualToString:@"Y"]) {
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: @"A message has been sent"
                           message:@"Please check your email for your login information."
                           delegate: nil
                           cancelButtonTitle: @"Ok"
                           otherButtonTitles: nil];
            [alertDialog show];
            return;
        } else {
            NSString *message = [[NSString alloc]initWithFormat:@"Email %@ is not a valid TEAM user.",self.saveEmail.text];
            UIAlertView *alertDialog;
            alertDialog = [[UIAlertView alloc]
                           initWithTitle: message
                           message:@"Check that you typed it correctly."
                           delegate: nil
                           cancelButtonTitle: @"Ok"
                           otherButtonTitles: nil];
            [alertDialog show];
            return;
        }
    }
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"Could not reach the TEAM server!"
                   message:@"Please contact TEAM support or check your internet connection"
                   delegate: nil
                   cancelButtonTitle: @"Ok"
                   otherButtonTitles: nil];
    [alertDialog show];
}
*/
/*
- (void) checkLoginResults:(NSArray *)objects {
    int count = [objects count];
    // here if user/password was correct
    if (!count) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Could not validate this email, possible TEAM Server issue"
                       message:@"Try again, or contact your administrator for help"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
    }
    LoginResults* response = [objects objectAtIndex:0];
    if ([response.teamid intValue] == 0) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Sorry, that user/password not valid"
                       message:@"Try again, or contact your administrator for help"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
    }
    NSLog(@"teamid = %@, db_server = %@",response.teamid,response.db_server);
    [[SharedObject sharedTeamData] setTeamID:response.teamid];
    [[SharedObject sharedTeamData] setUserAdmin:response.userAdminAccess];
    NSString *myuser = [[NSString alloc] initWithFormat:@"%@",self.userName.text];
    NSString *mypass = [[NSString alloc] initWithFormat:@"%@",self.userPassword.text];
    self.defaults = [NSUserDefaults standardUserDefaults];
    if (!self.checkbox.isChecked) {
        [self.defaults setObject:myuser forKey:@"teamuser"];
        [self.defaults setObject:mypass forKey:@"teampassword"];
    } else {
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    // add imagedoc server and user/password to Team Shared data
    [[SharedObject sharedTeamData] setDb_server:response.db_server];
    [[SharedObject sharedTeamData] setDbUser:response.dbUser];
    [[SharedObject sharedTeamData] setDbPassword:response.dbPassword];
    [[SharedObject sharedTeamData] setImagedoc_server:response.imagedoc_server];
    [[SharedObject sharedTeamData] setImagedocUser:response.imagedocUser];
    [[SharedObject sharedTeamData] setImagedocPassword:response.imagedocPassword];
    [[SharedObject sharedTeamData] setMediaType:response.imageType];
    [[SharedObject sharedTeamData] setDocType:response.docType];
    [[SharedObject sharedTeamData] setCompanyName:response.companyName];
    NSLog(@"imageserver=%@,user=%@,password=%@,imagetype=%@,doctype=%@,companyName=%@",response.imagedoc_server,response.imagedocUser,response.imagedocPassword,response.imageType,response.docType,response.companyName);
    NSString *image_type = [[SharedObject sharedTeamData] getMediaType];
    NSLog(@"image_type=%@",image_type);
    
   [self performSegueWithIdentifier:@"teammenu" sender:self];
}
*/
-(BOOL)reachable {
    Reachability *r = [Reachability reachabilityWithHostName:@"websoftmagic.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

- (IBAction)userLogin:(UIButton *)sender {
    // check user name and password then segue to Team
    if (([self.userName.text length] < 1) || ([self.userPassword.text length] < 1)) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Both user Name and Password must be entered"
                       message:@"Please try again"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
    }
    if (![self reachable]) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Sorry I could not reach the TEAM Server."
                       message:@"Please check your internet settings"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
    }
        // send get request
    // search1=user_name,search2=user_password,search3=dummy
    NSString *getRequest = [[NSString alloc]initWithFormat:@"/teamquery/team.php?search1=%@&search2=%@",self.userName.text,self.userPassword.text];
    self.callBack = @"login";
    self.initializing.text = @"Initializing TEAM, Please Wait....";
    [[RKClient sharedClient] get:getRequest delegate:self];
    // response will come back in delegate
    return;
    
    // rest of code not run
    BOOL valid = [self isUserNameValid:self.userName.text userpassword:self.userPassword.text];
    if (!valid) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Sorry, that user/password not valid"
                       message:@"Try again, or contact your administrator for help"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
    }
    // good login now set user/password if user wants to save it
    NSString *myuser = [[NSString alloc] initWithFormat:@"%@",self.userName.text];
    NSString *mypass = [[NSString alloc] initWithFormat:@"%@",self.userPassword.text];
    
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    if (!self.checkbox.isChecked) {
        [self.defaults setObject:myuser forKey:@"teamuser"];
        [self.defaults setObject:mypass forKey:@"teampassword"];
    } else {
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"teammenu" sender:self];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userPassword) {
        [self userLogin:nil];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.saveEmail = [alertView textFieldAtIndex:0];
    if (![self reachable]) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Sorry I could not reach the TEAM Server."
                       message:@"Please check your internet settings"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
    }
    // send email address to server to send email
    BOOL okemail = [self sendUserEmail:self.saveEmail.text];
    if (okemail) {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"A message has been sent"
                       message:@"Please check your email for the details to change/reset your password."
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
    } else {
        UIAlertView *alertDialog;
        alertDialog = [[UIAlertView alloc]
                       initWithTitle: @"Sorry, that user/password not valid"
                       message:@"Try again, or contact your administrator for help"
                       delegate: nil
                       cancelButtonTitle: @"Ok"
                       otherButtonTitles: nil];
        [alertDialog show];
        return;
    }
}
- (IBAction)forgotPassword:(id)sender {
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"Enter your Email address"
                   message:@"Instructions to change/reset your password will be sent."
                   delegate: self
                   cancelButtonTitle: @"Ok"
                   otherButtonTitles: nil];
    alertDialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertDialog show];
}

- (IBAction)tryTeamDemo:(UIButton *)sender {
    self.userName.text = @"demo";
    self.userPassword.text = @"demo";
    [self userLogin:(UIButton *)NULL];
    
}
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc]
                   initWithTitle: @"I could not reach the TEAM Server"
                   message:@"Please check your TEAM settings"
                   delegate: nil
                   cancelButtonTitle: @"Ok"
                   otherButtonTitles: nil];
    
    [alertDialog show];
    NSLog(@"error %@",error);
}
-(BOOL)sendUserEmail:(NSString *)email {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [[NSString alloc]initWithFormat:@"http://team_admin:Teamdb143143@www.websoftmagic.com/login/teamsendemail.php?user_email=%@",email];
    [request setURL:[NSURL URLWithString:url]];
    //NSLog(@"url=%@",url);
    [request setHTTPMethod:@"GET"];
    NSString *accept = [NSString stringWithFormat:@"application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5"];
    [request addValue:accept forHTTPHeaderField: @"Accept"];
    //send request & get response
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* myString;
    myString = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
    //NSLog(@"got=%@",myString);
    // try to parse values from xml
    NSString *response = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
    //NSLog(@"got=%@",response);
    // check if proper response and teamid not 0
    // teamid
    NSRange rangebegin0 = [response rangeOfString:@"<succeed>"];
    NSRange rangeend0 = [response rangeOfString:@"</succeed>"];
    int length0 = rangeend0.location - rangebegin0.location -9;
    int begin0 = rangebegin0.location + 9;
    NSRange fileRange0 = NSMakeRange(begin0, length0);
    NSString *teamid = [response substringWithRange:fileRange0];
    if (!rangebegin0.location) {
        NSLog(@"Login response was not xml");
        return FALSE;
    }
    if ([teamid isEqualToString:@"Y"]) {
        //NSLog(@"Valid Login for %@",teamid);
        return TRUE;
    }
    //NSLog(@"Invalid Email for %@",teamid);
    return FALSE;
    
}
-(BOOL)isUserNameValid:(NSString *)username userpassword:(NSString *)password {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [[NSString alloc]initWithFormat:@"https://team_admin:Teamdb143143@www.websoftmagic.com/login/teamlogin.php?user_name=%@&user_password=%@",username,password];
    [request setURL:[NSURL URLWithString:url]];
    //NSLog(@"url=%@",url);
    [request setHTTPMethod:@"GET"];
    NSString *accept = [NSString stringWithFormat:@"application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5"];
    [request addValue:accept forHTTPHeaderField: @"Accept"];
    //send request & get response
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* myString;
    myString = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
   // NSLog(@"got=%@",myString);
    // try to parse values from xml
    NSString *response = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
    // check if proper response and teamid not 0
    // teamid
    NSRange rangebegin0 = [response rangeOfString:@"<teamid>"];
    NSRange rangeend0 = [response rangeOfString:@"</teamid>"];
    int length0 = rangeend0.location - rangebegin0.location -8;
    int begin0 = rangebegin0.location + 8;
    NSRange fileRange0 = NSMakeRange(begin0, length0);
    NSString *teamid = [response substringWithRange:fileRange0];
    if (!rangebegin0.location) {
        NSLog(@"Login response was not xml");
        return FALSE;
    }
    if ([teamid isEqualToString:@"0"]) {
        NSLog(@"Invalid Login attempt");
        return FALSE; //invalid login
    }
    // db_server
    NSRange rangebegin = [response rangeOfString:@"<db_server>"];
    NSRange rangeend = [response rangeOfString:@"</db_server>"];
    int length = rangeend.location - rangebegin.location -11;
    int begin = rangebegin.location + 11;
    NSRange fileRange = NSMakeRange(begin, length);
    NSString *db_server = [response substringWithRange:fileRange];
    
    // db_user
    NSRange rangebegin2 = [response rangeOfString:@"<db_user>"];
    NSRange rangeend2 = [response rangeOfString:@"</db_user>"];
    int length2 = rangeend2.location - rangebegin2.location -9;
    int begin2 = rangebegin2.location + 9;
    NSRange fileRange2 = NSMakeRange(begin2, length2);
    NSString *db_user = [response substringWithRange:fileRange2];
    
    // db_password
    NSRange rangebegin3 = [response rangeOfString:@"<db_password>"];
    NSRange rangeend3 = [response rangeOfString:@"</db_password>"];
    int length3 = rangeend3.location - rangebegin3.location -13;
    int begin3 = rangebegin3.location + 13;
    NSRange fileRange3 = NSMakeRange(begin3, length3);
    NSString *db_password = [response substringWithRange:fileRange3];
    
    // imagedoc_server
    NSRange rangebegin4 = [response rangeOfString:@"<imagedoc_server>"];
    NSRange rangeend4 = [response rangeOfString:@"</imagedoc_server>"];
    int length4 = rangeend4.location - rangebegin4.location -17;
    int begin4 = rangebegin4.location + 17;
    NSRange fileRange4 = NSMakeRange(begin4, length4);
    NSString *imagedoc_server = [response substringWithRange:fileRange4];
    
    // imagedoc_user
    NSRange rangebegin5 = [response rangeOfString:@"<imagedoc_user>"];
    NSRange rangeend5 = [response rangeOfString:@"</imagedoc_user>"];
    int length5 = rangeend5.location - rangebegin5.location -15;
    int begin5 = rangebegin5.location + 15;
    NSRange fileRange5 = NSMakeRange(begin5, length5);
    NSString *imagedoc_user = [response substringWithRange:fileRange5];
    
    // imagedoc_password
    NSRange rangebegin6 = [response rangeOfString:@"<imagedoc_password>"];
    NSRange rangeend6 = [response rangeOfString:@"</imagedoc_password>"];
    int length6 = rangeend6.location - rangebegin6.location -19;
    int begin6 = rangebegin6.location + 19;
    NSRange fileRange6 = NSMakeRange(begin6, length6);
    NSString *imagedoc_password = [response substringWithRange:fileRange6];
    
    // image_type
    NSRange rangebegin7 = [response rangeOfString:@"<image_type>"];
    NSRange rangeend7 = [response rangeOfString:@"</image_type>"];
    int length7 = rangeend7.location - rangebegin7.location -12;
    int begin7 = rangebegin7.location + 12;
    NSRange fileRange7 = NSMakeRange(begin7, length7);
    NSString *image_type = [response substringWithRange:fileRange7];
    
    // doc_type
    NSRange rangebegin8 = [response rangeOfString:@"<doc_type>"];
    NSRange rangeend8 = [response rangeOfString:@"</doc_type>"];
    int length8 = rangeend8.location - rangebegin8.location -10;
    int begin8 = rangebegin8.location + 10;
    NSRange fileRange8 = NSMakeRange(begin8, length8);
    NSString *doc_type = [response substringWithRange:fileRange8];
    
    // user_admin_access
    NSRange rangebegin9 = [response rangeOfString:@"<user_admin_access>"];
    NSRange rangeend9 = [response rangeOfString:@"</user_admin_access>"];
    int length9 = rangeend9.location - rangebegin9.location -19;
    int begin9 = rangebegin9.location + 19;
    NSRange fileRange9 = NSMakeRange(begin9, length9);
    NSString *user_admin_access = [response substringWithRange:fileRange9];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:teamid];
    //
    /*
    NSLog(@"teamid=*%@*",myNumber);
    NSLog(@"db_server=*%@*",db_server);
    NSLog(@"db_user=*%@*",db_user);
    NSLog(@"db_passord=*%@*",db_password);
    NSLog(@"imagedoc_server=*%@*",imagedoc_server);
    NSLog(@"imagedoc_user=*%@*",imagedoc_user);
    NSLog(@"imagedoc_password=*%@*",imagedoc_password);
    NSLog(@"image_type=*%@*",image_type);
    NSLog(@"doc_type=*%@*",doc_type);
    NSLog(@"user_admin_access=*%@*",user_admin_access);
    */
    // singleton for rest of application
    
    
    [[SharedObject sharedTeamData] setTeamID:myNumber];
    [[SharedObject sharedTeamData] setDb_server:db_server];
    [[SharedObject sharedTeamData] setDbUser:db_user];
    [[SharedObject sharedTeamData] setDbPassword:db_password];
    [[SharedObject sharedTeamData] setImagedoc_server:imagedoc_server];
    [[SharedObject sharedTeamData] setImagedocUser:imagedoc_user];
    [[SharedObject sharedTeamData] setImagedocPassword:imagedoc_password];
    [[SharedObject sharedTeamData] setMediaType:image_type];
    [[SharedObject sharedTeamData] setDocType:doc_type];
    [[SharedObject sharedTeamData] setUserAdmin:user_admin_access];
    
    // now setup the shared object manager for the rest of the application
    RKObjectManager* manager;
    NSString *dbstring = [[NSString alloc] initWithFormat:@"http://%@",db_server];
    NSURL *dburl = [[NSURL alloc] initWithString:dbstring];
    manager = [RKObjectManager objectManagerWithBaseURL:dburl];
    manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    [RKObjectManager sharedManager].client.username = db_user;
    [RKObjectManager sharedManager].client.password = db_password;
    
    return TRUE;
}
-(BOOL)checkLoginResults:(NSString *)response {
    NSRange rangebegin0 = [response rangeOfString:@"<teamid>"];
    NSRange rangeend0 = [response rangeOfString:@"</teamid>"];
    int length0 = rangeend0.location - rangebegin0.location -8;
    int begin0 = rangebegin0.location + 8;
    NSRange fileRange0 = NSMakeRange(begin0, length0);
    NSString *teamid = [response substringWithRange:fileRange0];
    if (!rangebegin0.location) {
        NSLog(@"Login response was not xml");
        return FALSE;
    }
    if ([teamid isEqualToString:@"0"]) {
        NSLog(@"Invalid Login attempt");
        return FALSE; //invalid login
    }
    // db_server
    NSRange rangebegin = [response rangeOfString:@"<db_server>"];
    NSRange rangeend = [response rangeOfString:@"</db_server>"];
    int length = rangeend.location - rangebegin.location -11;
    int begin = rangebegin.location + 11;
    NSRange fileRange = NSMakeRange(begin, length);
    NSString *db_server = [response substringWithRange:fileRange];
    
    // db_user
    NSRange rangebegin2 = [response rangeOfString:@"<db_user>"];
    NSRange rangeend2 = [response rangeOfString:@"</db_user>"];
    int length2 = rangeend2.location - rangebegin2.location -9;
    int begin2 = rangebegin2.location + 9;
    NSRange fileRange2 = NSMakeRange(begin2, length2);
    NSString *db_user = [response substringWithRange:fileRange2];
    
    // db_password
    NSRange rangebegin3 = [response rangeOfString:@"<db_password>"];
    NSRange rangeend3 = [response rangeOfString:@"</db_password>"];
    int length3 = rangeend3.location - rangebegin3.location -13;
    int begin3 = rangebegin3.location + 13;
    NSRange fileRange3 = NSMakeRange(begin3, length3);
    NSString *db_password = [response substringWithRange:fileRange3];
    
    // imagedoc_server
    NSRange rangebegin4 = [response rangeOfString:@"<imagedoc_server>"];
    NSRange rangeend4 = [response rangeOfString:@"</imagedoc_server>"];
    int length4 = rangeend4.location - rangebegin4.location -17;
    int begin4 = rangebegin4.location + 17;
    NSRange fileRange4 = NSMakeRange(begin4, length4);
    NSString *imagedoc_server = [response substringWithRange:fileRange4];
    
    // imagedoc_user
    NSRange rangebegin5 = [response rangeOfString:@"<imagedoc_user>"];
    NSRange rangeend5 = [response rangeOfString:@"</imagedoc_user>"];
    int length5 = rangeend5.location - rangebegin5.location -15;
    int begin5 = rangebegin5.location + 15;
    NSRange fileRange5 = NSMakeRange(begin5, length5);
    NSString *imagedoc_user = [response substringWithRange:fileRange5];
    
    // imagedoc_password
    NSRange rangebegin6 = [response rangeOfString:@"<imagedoc_password>"];
    NSRange rangeend6 = [response rangeOfString:@"</imagedoc_password>"];
    int length6 = rangeend6.location - rangebegin6.location -19;
    int begin6 = rangebegin6.location + 19;
    NSRange fileRange6 = NSMakeRange(begin6, length6);
    NSString *imagedoc_password = [response substringWithRange:fileRange6];
    
    // image_type
    NSRange rangebegin7 = [response rangeOfString:@"<image_type>"];
    NSRange rangeend7 = [response rangeOfString:@"</image_type>"];
    int length7 = rangeend7.location - rangebegin7.location -12;
    int begin7 = rangebegin7.location + 12;
    NSRange fileRange7 = NSMakeRange(begin7, length7);
    NSString *image_type = [response substringWithRange:fileRange7];
    
    // doc_type
    NSRange rangebegin8 = [response rangeOfString:@"<doc_type>"];
    NSRange rangeend8 = [response rangeOfString:@"</doc_type>"];
    int length8 = rangeend8.location - rangebegin8.location -10;
    int begin8 = rangebegin8.location + 10;
    NSRange fileRange8 = NSMakeRange(begin8, length8);
    NSString *doc_type = [response substringWithRange:fileRange8];
    
    // user_admin_access
    NSRange rangebegin9 = [response rangeOfString:@"<user_admin_access>"];
    NSRange rangeend9 = [response rangeOfString:@"</user_admin_access>"];
    int length9 = rangeend9.location - rangebegin9.location -19;
    int begin9 = rangebegin9.location + 19;
    NSRange fileRange9 = NSMakeRange(begin9, length9);
    NSString *user_admin_access = [response substringWithRange:fileRange9];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:teamid];
    //
    /*
     NSLog(@"teamid=*%@*",myNumber);
     NSLog(@"db_server=*%@*",db_server);
     NSLog(@"db_user=*%@*",db_user);
     NSLog(@"db_passord=*%@*",db_password);
     NSLog(@"imagedoc_server=*%@*",imagedoc_server);
     NSLog(@"imagedoc_user=*%@*",imagedoc_user);
     NSLog(@"imagedoc_password=*%@*",imagedoc_password);
     NSLog(@"image_type=*%@*",image_type);
     NSLog(@"doc_type=*%@*",doc_type);
     NSLog(@"user_admin_access=*%@*",user_admin_access);
     */
    // singleton for rest of application
    
    
    [[SharedObject sharedTeamData] setTeamID:myNumber];
    [[SharedObject sharedTeamData] setDb_server:db_server];
    [[SharedObject sharedTeamData] setDbUser:db_user];
    [[SharedObject sharedTeamData] setDbPassword:db_password];
    [[SharedObject sharedTeamData] setImagedoc_server:imagedoc_server];
    [[SharedObject sharedTeamData] setImagedocUser:imagedoc_user];
    [[SharedObject sharedTeamData] setImagedocPassword:imagedoc_password];
    [[SharedObject sharedTeamData] setMediaType:image_type];
    [[SharedObject sharedTeamData] setDocType:doc_type];
    [[SharedObject sharedTeamData] setUserAdmin:user_admin_access];
    [[SharedObject sharedTeamData] setUser_name:self.userName.text];
    
    // now setup the shared object manager for the rest of the application
    RKObjectManager* manager;
    NSString *dbstring = [[NSString alloc] initWithFormat:@"http://%@",db_server];
    NSURL *dburl = [[NSURL alloc] initWithString:dbstring];
    manager = [RKObjectManager objectManagerWithBaseURL:dburl];
    manager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    [RKObjectManager sharedManager].client.username = db_user;
    [RKObjectManager sharedManager].client.password = db_password;
    
    return TRUE;

}
@end
