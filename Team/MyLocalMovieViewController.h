/*

    File: MyLocalMovieViewController.h
Abstract: 
Subclass of MyMovieViewController. Gives a URL to a local movie stored in the app bundle. Implements a 'Play Movie' button for playback of a local movie. 
Also plays the local movie on touches to the UIImageView. 

 Version: 1.4


*/

#import <UIKit/UIKit.h>
#import "MyMovieViewController.h"


@interface MyLocalMovieViewController : MyMovieViewController 
{
}

-(IBAction)playMovieButtonPressed:(id)sender;

@end
