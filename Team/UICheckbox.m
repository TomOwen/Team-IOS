//
//  UICheckbox.m
//  remember
//
//  Created by Tom Owen on 7/24/12.
//  Copyright (c) 2012 Owen & Owen. All rights reserved.
//

#import "UICheckbox.h"

@implementation UICheckbox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
@synthesize isChecked = _isChecked;

-(void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"uicheckbox_%@checked.png", (self.isChecked) ? @"un" : @""]];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.isChecked = !self.isChecked;
    [self setNeedsDisplay];
    
    return TRUE;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
