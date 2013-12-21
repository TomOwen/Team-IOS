//
//  TeamHelp.m
//  Team
//
//  Created by Tom Owen on 7/8/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "TeamHelp.h"

@interface TeamHelp ()

@end

@implementation TeamHelp
@synthesize helpTableView = _helpTableView;
@synthesize helpFiles = _helpFiles;
@synthesize helpLabels = _helpLabels;
@synthesize helpImages = _helpImages;


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
    // load labels and images for help table
    self.helpFiles = [[NSMutableDictionary alloc] initWithObjectsAndKeys: 
                       @"overview.html", @"0",
                       @"contact.html", @"1",
                       @"login.html", @"2",
                       @"patient-add.html",@"3",
                       @"patient-response.html",@"4",
                       @"doctor-add.html",@"5",
                       @"study-add.html",@"6",
                       @"scan-add.html",@"7",
                       @"delete.html",@"8",
                       @"print-screen.html",@"9",
                       @"image-online.html",@"10",
                       @"reports-online.html",@"11",
                       @"graph-online.html",@"12",
                       @"recist-info.html",@"13",
                       @"adverse.html",@"14",
                       nil]; //nil to signify end of objects and keys.

    self.helpLabels = [[NSMutableDictionary alloc] initWithObjectsAndKeys: 
                       @"TEAM Overview", @"0",
                       @"Contact TEAM Support", @"1",
                       @"Login/Logout and Passwords", @"2",
                       @"All About Patients", @"3",
                       @"Patient Response and Reports", @"4",
                       @"How to add a New Doctor", @"5",
                       @"How to add a New Clinical Study/Trial", @"6",
                       @"Managing Patient Scans", @"7",
                       @"How to Delete a Patient/Scan/Lesion", @"8",
                       @"Printing screen images", @"9",
                       @"Patient Scan Images – Online", @"10",
                       @"Scan & Internal Study Reports", @"11",
                       @"Patient and Study Graphs", @"12",
                       @"RECIST Web site", @"13",
                       @"Adverse Events Web site", @"14",
                       nil]; //nil to signify end of objects and keys.
    
    self.helpImages = [[NSMutableDictionary alloc] initWithObjectsAndKeys: 
                       @"team114114.png", @"0",
                       @"contact.png", @"1",
                       @"icon-login.png", @"2",
                       @"icon-patients.png",@"3",
                       @"icon-reports.png", @"4",
                       @"doctor.png", @"5",
                       @"study.png", @"6",
                       @"scans.png", @"7",
                       @"edit.png", @"8",
                       @"print.png", @"9",
                       @"scans.png", @"10",
                       @"icon-reports.png", @"11",
                       @"icon_graph.png", @"12",
                       @"team114114.png", @"13",
                       @"adverse.png", @"14",
                       nil]; //nil to signify end of objects and keys.
    
    //NSString *some1 = @"<html><head><meta content=\"text/html; charset=ISO-889-1\"http-equiv=\"Content-Type\"><title>Patient Scans and Response</title></head><body><table border=\"0\" cellpadding=\"2\" cellspacing=\"2\" width=\"100%%\"><tbody><tr><td valign=\"top\">%@<br></td><td valign=\"top\">%@<br></td><td valign=\"top\">%@<br></td><td valign=\"top\">%@<br></td><td valign=\"top\">%@<br></td></tr></tbody></table><br></body></html>";
    //NSString *line1 = [[NSString alloc] initWithFormat:some1,@"name",@"id",@"12/31/12",@"Dr Oz",@"My Trial"];
    //NSLog(@"%@",line1);
    //[webVIew loadHTMLString:someHtmlConent];


}

- (void)viewDidUnload
{
    [self setHelpTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
#pragma mark - Help Table delagates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexChosen = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"displayHelp" sender:self];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"displayHelp"]) {
        NSString *indexKey = [[NSString alloc] initWithFormat:@"%d",indexChosen];
        NSString *htmlFileName = [self.helpFiles objectForKey:indexKey];
        //NSString *htmlFileName = [[NSString alloc] initWithFormat:@"helphtml%d.html",indexChosen];
        [[segue destinationViewController] setHTMLPage:htmlFileName];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.helpFiles count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"help";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...

    NSString *index1 = [[NSString alloc] initWithFormat:@"%d",indexPath.row];
    cell.textLabel.text = [self.helpLabels objectForKey:index1];
    NSString *imageName = [self.helpImages objectForKey:index1];    
    cell.imageView.image = [UIImage imageNamed:imageName];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    }else {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    //cell.backgroundColor = [UIColor blackColor];

    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (IBAction)quit:(UIButton *)sender {
    exit(0);
}

- (IBAction)contactUs:(UIButton *)sender {
    MFMailComposeViewController *myclass = [[MFMailComposeViewController alloc] init];
    myclass.mailComposeDelegate = self;
    [myclass setSubject:@"TEAM Support Question"];
    NSArray *toRecipients = [NSArray arrayWithObjects:@"team@websoftmagic.com",nil];
    [myclass setToRecipients:toRecipients];
    [self presentModalViewController:myclass animated:YES];
    
}


@end
