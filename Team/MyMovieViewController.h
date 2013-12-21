/*

    File: MyMovieViewController.h 
Abstract:  A UIViewController controller subclass that implements a movie playback view.
Uses a MyMovieController object to control playback of a movie.
Adds and removes an overlay view to the view hierarchy. Handles button presses to the
'Close Movie' button in the overlay view.
Adds and removes a background view to hide any underlying user interface controls when playing a movie.
Gets user movie settings preferences by calling the MoviePlayerUserPref methods. Apply these settings to the movie with the MyMovieController singleton.
 
 Version: 1.4 
*/

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SharedObject.h"
#import "RetrieveSettings.h"

//#import "MoviePlayerAppDelegate.h"
#import "AppDelegate.h"
#import "MyOverlayViewController.h"

@class MyImageView;

@interface MyMovieViewController : UIViewController 
{
@private
    MPMoviePlayerController *moviePlayerController;
    
//  IBOutlet MoviePlayerAppDelegate *appDelegate;
    IBOutlet AppDelegate *appDelegate;
    
	IBOutlet MyImageView *imageView;
	IBOutlet UIImageView *movieBackgroundImageView;
	IBOutlet UIView *backgroundView;	
	IBOutlet MyOverlayViewController *overlayController;       
}

@property (nonatomic, retain) IBOutlet MyImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *movieBackgroundImageView;
@property (nonatomic, retain) IBOutlet UIView *backgroundView;
@property (nonatomic, retain) IBOutlet MyOverlayViewController *overlayController;

@property (nonatomic, retain) AppDelegate IBOutlet *appDelegate;

@property (retain) MPMoviePlayerController *moviePlayerController;

- (IBAction)overlayViewCloseButtonPress:(id)sender;
- (void)viewWillEnterForeground;
- (void)playMovieFile:(NSURL *)movieFileURL;
- (void)playMovieStream:(NSURL *)movieFileURL;

@end


