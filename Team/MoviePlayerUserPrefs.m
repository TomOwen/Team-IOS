/*
 
     File: MoviePlayerUserPrefs.m 
 Abstract: Contains methods to get the application user preferences settings for the movie scaling 
 mode, control style, background color, repeat mode, application audio session and background image.
  
  Version: 1.4 
  
 */

#import "MoviePlayerUserPrefs.h"

// Application preference keys
NSString *kScalingModeKey					= @"scalingMode";
NSString *kControlStyleKey					= @"controlStyle";
NSString *kBackgroundColorKey				= @"backgroundColor";
NSString *kRepeatModeKey					= @"repeatMode";
NSString *kUseApplicationAudioSessionKey	= @"useApplicationAudioSession";
NSString *kMovieBackgroundImageKey			= @"useMovieBackgroundImage";


@implementation MoviePlayerUserPrefs

#pragma mark Movie User Preference Settings

+ (void)registerDefaults
{
    /* First get the movie player settings defaults (scaling, controller type, background color,
	 repeat mode, application audio session) set by the user via the built-in iPhone Settings 
	 application */
	 
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kScalingModeKey];
    if (testValue == nil)
    {
        // No default movie player settings values have been set, create them here based on our 
        // settings bundle info.
        //
        // The values to be set for movie playback are:
        //
        //    - scaling mode (None, Aspect Fill, Aspect Fit, Fill)
        //    - controller style (None, Fullscreen, Embedded)
        //    - background color (Any UIColor value)
        //    - repeat mode (None, One)
		//    - use application audio session (On, Off)
		//	  - background image
        
        NSString *pathStr = [[NSBundle mainBundle] bundlePath];
        NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
        NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
        NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
        NSNumber *controlStyleDefault = nil;
        NSNumber *scalingModeDefault = nil;
        NSNumber *backgroundColorDefault = nil;
        NSNumber *repeatModeDefault = nil;
		NSNumber *useApplicationAudioSession = nil;
		NSNumber *movieBackgroundImageDefault = nil;
        
        NSDictionary *prefItem;
        for (prefItem in prefSpecifierArray)
        {
            NSString *keyValueStr = [prefItem objectForKey:@"Key"];
            id defaultValue = [prefItem objectForKey:@"DefaultValue"];
            
            if ([keyValueStr isEqualToString:kScalingModeKey])
            {
                scalingModeDefault = defaultValue;
            }
            else if ([keyValueStr isEqualToString:kControlStyleKey])
            {
                controlStyleDefault = defaultValue;
            }
            else if ([keyValueStr isEqualToString:kBackgroundColorKey])
            {
                backgroundColorDefault = defaultValue;
            }
            else if ([keyValueStr isEqualToString:kRepeatModeKey])
            {
                repeatModeDefault = defaultValue;
            }
            else if ([keyValueStr isEqualToString:kUseApplicationAudioSessionKey])
            {
                useApplicationAudioSession = defaultValue;
            }
            else if ([keyValueStr isEqualToString:kMovieBackgroundImageKey])
            {
                movieBackgroundImageDefault = defaultValue;
            }
        }
        
        // since no default values have been set, create them here
        NSDictionary *appDefaults =  [NSDictionary dictionaryWithObjectsAndKeys:
                                      scalingModeDefault, kScalingModeKey,
                                      controlStyleDefault, kControlStyleKey,
                                      backgroundColorDefault, kBackgroundColorKey,
									  repeatModeDefault, kRepeatModeKey,
									  useApplicationAudioSession, kUseApplicationAudioSessionKey,
                                      movieBackgroundImageDefault, kMovieBackgroundImageKey,
									  nil];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
	else 
	{
		/*
			Writes any modifications to the persistent domains to disk and updates all unmodified 
			persistent domains to what is on disk.
		*/
		[[NSUserDefaults standardUserDefaults] synchronize];
	}


}

+(MPMovieScalingMode)scalingModeUserSetting
{
	[self registerDefaults];

    /* 
        Movie scaling mode can be one of: MPMovieScalingModeNone, MPMovieScalingModeAspectFit,
            MPMovieScalingModeAspectFill, MPMovieScalingModeFill.
			
		Movie scaling mode describes how the movie content is scaled to fit the frame of its view.
		It may be one of:

			MPMovieScalingModeNone, MPMovieScalingModeAspectFit, MPMovieScalingModeAspectFill,
			MPMovieScalingModeFill.
   */
	return([[NSUserDefaults standardUserDefaults] integerForKey:kScalingModeKey]);
}

+(MPMovieControlStyle)controlStyleUserSetting
{
	[self registerDefaults];

    /* 
        Movie control style can be one of: MPMovieControlStyleNone, MPMovieControlStyleEmbedded,
            MPMovieControlStyleFullscreen.
			
		Movie control style describes the style of the playback controls.
		It can be one of:
			
			MPMovieControlStyleNone, MPMovieControlStyleEmbedded, MPMovieControlStyleFullscreen,
			MPMovieControlStyleDefault, MPMovieControlStyleFullscreen
   */

    return([[NSUserDefaults standardUserDefaults] integerForKey:kControlStyleKey]);
}

+(UIColor *)backgroundColorUserSetting
{
	[self registerDefaults];

    /*
        The color of the background area behind the movie can be any UIColor value.
    */
    UIColor *colors[15] = {[UIColor blackColor], [UIColor darkGrayColor], [UIColor lightGrayColor], [UIColor whiteColor], 
        [UIColor grayColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor], 
        [UIColor yellowColor], [UIColor magentaColor],[UIColor orangeColor], [UIColor purpleColor], [UIColor brownColor], 
        [UIColor clearColor]};
    return (colors[ [[NSUserDefaults standardUserDefaults] integerForKey:kBackgroundColorKey] ] );
}

+(MPMovieRepeatMode)repeatModeUserSetting
{
	[self registerDefaults];

    /* 
		Movie repeat mode describes how the movie player repeats content at the end of playback.
	
        Movie repeat mode can be one of: MPMovieRepeatModeNone, MPMovieRepeatModeOne.
			
   */
    return([[NSUserDefaults standardUserDefaults] integerForKey:kRepeatModeKey]);
}

+(BOOL)audioSessionUserSetting
{
	[self registerDefaults];
    /* 
		Movie Use Application Audio Session mode indicates whether the movie player should use the application’s audio session.
	
        Use Application Audio Session mode can be one of: On, Off.
			
   */
    return([[NSUserDefaults standardUserDefaults] integerForKey:kUseApplicationAudioSessionKey]);
}

+(BOOL)backgroundImageUserSetting
{
	[self registerDefaults];

	return([[NSUserDefaults standardUserDefaults] integerForKey:kMovieBackgroundImageKey]);
}

@end
