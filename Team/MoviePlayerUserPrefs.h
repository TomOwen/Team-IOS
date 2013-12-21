/*
 
     File: MoviePlayerUserPrefs.h 
 Abstract: Contains methods to get the application user preferences settings for the movie scaling 
 mode, control style, background color, repeat mode, application audio session and background image.
  
  Version: 1.4 
  
  
 */

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MoviePlayerUserPrefs : NSObject 
{
}

+ (MPMovieScalingMode)scalingModeUserSetting;
+ (MPMovieControlStyle)controlStyleUserSetting;
+ (UIColor *)backgroundColorUserSetting;
+ (MPMovieRepeatMode)repeatModeUserSetting;
+ (BOOL)audioSessionUserSetting;
+ (BOOL)backgroundImageUserSetting;

@end
