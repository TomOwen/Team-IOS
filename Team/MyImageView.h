/*
 
     File: MyImageView.h 
 Abstract: A UIImageView subclass that implements the UIResponder event-handling
 method touchesBegan: withEvent:
 in order to receive finger touch event messages. Any finger touch events in this
 view will start the movie playing.
  
  Version: 1.4 
  
  
 */

#import <UIKit/UIKit.h>
#import "MyLocalMovieViewController.h"

@interface MyImageView : UIImageView 
{
    IBOutlet MyLocalMovieViewController *viewController;
}

@property (nonatomic,retain) IBOutlet MyLocalMovieViewController *viewController;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
