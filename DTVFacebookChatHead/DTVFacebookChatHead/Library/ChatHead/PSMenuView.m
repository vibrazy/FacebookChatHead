//
//  PSMenuView.m
//  DTVFacebookChatHead
//
//  Created by Daniel Tavares on 18/04/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import "PSMenuView.h"

@implementation PSMenuView
{
    CGSize imageSize;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        UIImage *img = [UIImage imageNamed:@"Vertical_Menu"];
        
        // Initialization code
        self.layer.anchorPoint = CGPointMake(1, 0);
        self.layer.contents = (id)img.CGImage;
        imageSize = CGSizeMake(img.size.width, img.size.height);
    }
    return self;
}

-(void)animate
{
    [self increaseAnimation];
}
-(void)hide
{
    NSLog(@"hiding");
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{

                         self.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
                     }
                     completion:^(BOOL finished) {
                         
                     }];

}
-(void)increaseAnimation
{
    
    CGRect  toFrame     = self.frame;
    toFrame.size.width = imageSize.width;
    toFrame.size.height = imageSize.height;
    
    [self.layer setBounds:toFrame];
    
    NSLog(@"%@", NSStringFromCGRect(toFrame));
    
    self.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
    
    
    void (^animationBlock)(BOOL) = ^(BOOL finished) {
        // Wait one second and then fade in the view
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(0.95, 0.95);
                         }
                         completion:^(BOOL finished){
                             
                             
                             // Wait one second and then fade in the view
                             [UIView animateWithDuration:0.1
                                              animations:^{
                                                  self.transform = CGAffineTransformMakeScale(1.02, 1.02);
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  
                                                  // Wait one second and then fade in the view
                                                  [UIView animateWithDuration:0.1
                                                                   animations:^{
                                                                       self.transform = CGAffineTransformIdentity;
                                                                   }
                                                                   completion:^(BOOL finished){
                                                                       
                                                                   }];
                                              }];
                         }];
    };
    
    // Show the view right away
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1.05, 1.05);
                     }
                     completion:animationBlock];
}


@end
