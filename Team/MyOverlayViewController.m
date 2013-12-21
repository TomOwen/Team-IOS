/*
 
     File: MyOverlayViewController.m 
 Abstract: A UIViewController controller subclass that implements an overlay view to display movie load state and playback state and a button to close the active movie.
 Contains an action method that is called when the 'Close Movie' button is pressed to close the movie.
  
  Version: 1.4 
  
 
 */

#import "MyOverlayViewController.h"

@implementation MyOverlayViewController

@synthesize moviePlaybackStateText, movieLoadStateText;

#pragma mark -
#pragma mark Display Movie Status Strings

/* Movie playback state display string. */
-(void)setPlaybackStateDisplayString:(NSString *)playBackText
{
	self.moviePlaybackStateText.text = playBackText;
}

/* Movie load state display string. */
-(void)setLoadStateDisplayString:(NSString *)loadStateText;
{
	self.movieLoadStateText.text = loadStateText;
}

@end
