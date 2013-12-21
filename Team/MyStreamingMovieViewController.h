/*
 
     File: MyStreamingMovieViewController.h 
 Abstract: A UIViewController controller subclass that loads the SecondView nib file that contains its view.
 Contains an action method that is called when the Play Movie button is pressed to play the movie.
 Provides a text edit control for the user to enter a movie URL.
  
  Version: 1.4 
  
  
 */

#import <UIKit/UIKit.h>
//#import "MoviePlayerAppDelegate.h"
#import "AppDelegate.h"
#import "MyMovieViewController.h"

@interface MyStreamingMovieViewController : MyMovieViewController <UITextFieldDelegate> 
{
@private
	IBOutlet UITextField *movieURLTextField;
}

@property (nonatomic,retain) IBOutlet UITextField *movieURLTextField;

-(IBAction)playStreamingMovieButtonPressed:(id)sender;

@end
