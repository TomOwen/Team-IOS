/*
 
     File: MyStreamingMovieViewController.m 
 Abstract: A UIViewController controller subclass that loads the SecondView nib file that contains its view.
 Contains an action method that is called when the Play Movie button is pressed to play the movie.
 Provides a text edit control for the user to enter a movie URL.
  
  Version: 1.4 
  
 
 */

#import "MyStreamingMovieViewController.h"

@implementation MyStreamingMovieViewController

@synthesize movieURLTextField;

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
	UITextField	*movieURLText = self.movieURLTextField;
	/* When the user presses return, take focus away from the 
	 text field so that the keyboard is dismissed. */
	if (theTextField == movieURLText) {
		[movieURLText resignFirstResponder];
	}
	return YES;
}

/* Handle touches to the 'Play Movie' button. */
-(IBAction)playStreamingMovieButtonPressed:(id)sender
{
	/* Has the user entered a movie URL? */
	if (self.movieURLTextField.text.length > 0)
	{
		
        //NSURL *theMovieURL = [NSURL URLWithString:self.movieURLTextField.text];
        NSURL *theMovieURL = [NSURL URLWithString:@"http://whereryou.webuda.com/gallery/143-120811-1.mov"];
		if (theMovieURL)
		{
			if ([theMovieURL scheme])	// sanity check on the URL
			{
				/* Play the movie with the specified URL. */
                [self playMovieStream:theMovieURL];
			}
		}
	}
}


@end
