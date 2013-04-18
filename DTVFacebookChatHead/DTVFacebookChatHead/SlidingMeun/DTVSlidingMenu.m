//
//  DTVSlidingMenu.m
//  DTVFacebookChatHead
//
//  Created by Daniel Tavares on 18/04/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import "DTVSlidingMenu.h"
#import "ViewUtils.h"

@implementation DTVSlidingMenu
{
    UIImageView *imgV;
    UIImageView *sliding;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        sliding = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TabBarE.jpg"]];
        [self addSubview:sliding];
        
        // Initialization code
        imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TabBar.jpg"]];
        [self addSubview:imgV];
        
        [self setHeight:[sliding height]];
        
        
    }
    return self;
}
-(void)animateUp
{
    [UIView animateWithDuration:0.3 animations:^{
        [imgV setAlpha:0.0];        
    }];

}
-(void)animateDown
{
    [UIView animateWithDuration:0.3 animations:^{
    [imgV setAlpha:1.0];
    }];
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
