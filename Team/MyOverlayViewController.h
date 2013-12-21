/*
 
     File: MyOverlayViewController.h 
 Abstract: A UIViewController controller subclass that implements an overlay view to display movie load state and playback state and a button to close the active movie.
 Contains an action method that is called when the 'Close Movie' button is pressed to close the movie.
  
  Version: 1.4 
  
 
 
 */

#import <UIKit/UIKit.h>


@interface MyOverlayViewController : UIViewController 
{
@private
	IBOutlet UILabel *moviePlaybackStateText;
	IBOutlet UILabel *movieLoadStateText;
}

@property (nonatomic, retain) IBOutlet UILabel *moviePlaybackStateText;
@property (nonatomic, retain) IBOutlet UILabel *movieLoadStateText;

- (void)setPlaybackStateDisplayString:(NSString *)playBackText;
- (void)setLoadStateDisplayString:(NSString *)loadStateText;

@end
