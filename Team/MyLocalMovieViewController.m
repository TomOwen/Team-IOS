/*

    File: MyLocalMovieViewController.m
Abstract: 
Subclass of MyMovieViewController. Gives a URL to a local movie stored in the app bundle. Implements a 'Play Movie' button for playback of a local movie. 
Also plays the local movie on touches to the UIImageView. 

 Version: 1.4


*/

#import "MyLocalMovieViewController.h"

@interface MyLocalMovieViewController (LocalMovieURL)
-(NSURL *)localMovieURL;
@end

#pragma mark -
@implementation MyLocalMovieViewController (LocalMovieURL)

/* Returns a URL to a local movie in the app bundle. */
-(NSURL *)localMovieURL
{
	NSURL *theMovieURL = nil;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle) 
	{
		NSString *moviePath = [bundle pathForResource:@"Movie" ofType:@"m4v"];
		if (moviePath)
		{
			theMovieURL = [NSURL fileURLWithPath:moviePath];
		}
	}
    return theMovieURL;
}

@end

#pragma mark -

@implementation MyLocalMovieViewController

/* Button presses for the 'Play Movie' button. */
-(IBAction)playMovieButtonPressed:(id)sender
{
	/* Play the movie at the specified URL. */
    [self playMovieFile:[self localMovieURL]];
}


@end
