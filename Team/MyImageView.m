/*
 
     File: MyImageView.m 
 Abstract: A UIImageView subclass that implements the UIResponder event-handling
 method touchesBegan: withEvent:
 in order to receive finger touch event messages. Any finger touch events in this
 view will start the movie playing.
  
  Version: 1.4 
  
  */

#import "MyImageView.h"


@implementation MyImageView

@synthesize viewController;

/* Touches to the Image view will start the movie playing. */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch* touch = [touches anyObject];
    if (touch.phase == UITouchPhaseBegan)
    {
		/* play the movie! */
        [self.viewController playMovieButtonPressed:self];
    }    
}


@end
