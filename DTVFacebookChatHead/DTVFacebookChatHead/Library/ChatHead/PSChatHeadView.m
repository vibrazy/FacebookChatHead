//
//  PSChatHeadView.m
//  Photoshoot
//
//  Created by Daniel Tavares on 16/04/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import "PSChatHeadView.h"
#import "PSChatHeadBubble.h"
#import "PSMenuView.h"

@interface PSChatHeadView()
@property (nonatomic, retain) PSChatHeadBubble *chatBubbleView;
@property (nonatomic, retain) PSMenuView *menuView;
@property (nonatomic, retain) UIImageView *pictchView;
@end

@implementation PSChatHeadView
{
    CGPoint touchLocation_;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
               
        // Initialization code
        __unsafe_unretained typeof(self) weakSelf = self;
        _chatBubbleView = [[PSChatHeadBubble alloc] initWithFrame:CGRectMake(50, 60, 55, 55) movedBlock:^(PSChatHeadBubble *bubble, PAN_DIRECTION_MASK direction, CGPoint velocity, STATUS_MASK status, CGPoint endPoint) {
            [weakSelf bubbleMoved:bubble direction:direction velocity:velocity status:status endPoint:endPoint];
        }];
        [self addSubview:_chatBubbleView];
        
        //create other views
        self.menuView = [[PSMenuView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
       // self.menuView.alpha=0.0;
        [self insertSubview:_menuView belowSubview:_chatBubbleView];

        
        self.pictchView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.pictchView.alpha=0.0;
        [self.pictchView setImage:[UIImage imageNamed:@"football_pitch-wallpaper-640x960@2x.jpg"]];
        [self insertSubview:_pictchView belowSubview:_menuView];
        
    }
    return self;
}
#pragma mark - Animation

-(CGPoint)centerFromCGRect:(CGRect)rect
{
    CGPoint point = CGPointMake(rect.origin.x + (rect.size.width*0.5), rect.origin.y + (rect.size.height*0.5));
    return point;
}

-(void)animateBubble:(PSChatHeadBubble *)bubble newFrame:(CGRect)newRect
{
//    // define a parametric function
//    KeyframeParametricBlock function = ^double(double time) {
//        return(1.0 - pow((1.0 - time), 2.0));
//    };
//    
//    if (bubble.layer)
//    {
//       
//        
//        [CATransaction begin];
//        [CATransaction
//         setValue:[NSNumber numberWithFloat:10.4]
//         forKey:kCATransactionAnimationDuration];
//        
//        CGPoint newPoint = [self centerFromCGRect:newRect];
//        CGPoint oldPoint = [self centerFromCGRect:bubble.frame];
//        
//        // make an animation
//        CAAnimation *dropy = [CAKeyframeAnimation
//                             animationWithKeyPath:@"position.y"
//                             function:function fromValue:oldPoint.y toValue:newPoint.y];
//        
//        CAAnimation *dropx = [CAKeyframeAnimation
//                             animationWithKeyPath:@"position.x"
//                             function:function fromValue:oldPoint.x toValue:newPoint.x];
//
//        // create animation group for x and y
//        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
//        animGroup.animations = [NSArray arrayWithObjects:dropy,dropx, nil];
//        animGroup.duration = 0.3;
//        animGroup.fillMode =kCAFillModeForwards;
//        animGroup.delegate = self;
//        [animGroup setValue:bubble.layer forKey:@"animationLayer"];
//        [bubble.layer addAnimation:animGroup forKey:nil];
//        
//        
//        [bubble.layer setPosition:newPoint];
//        
//        [CATransaction commit];
//        
    
    //}
}

-(void)resetBackground
{
    
    UIColor *fromColor = self.backgroundColor;
    UIColor *toColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.duration = 0.12;
    colorAnimation.fromValue = (id)fromColor.CGColor;
    colorAnimation.toValue = (id)toColor.CGColor;
    [self.layer addAnimation:colorAnimation forKey:@"backgroundColor"];
    [self setBackgroundColor:toColor];
    
    
}
#pragma mark - Bubble Movemend
-(void)bubbleMoved:(PSChatHeadBubble*)bubble
         direction:(PAN_DIRECTION_MASK)direction
          velocity:(CGPoint)velocity
            status:(STATUS_MASK)status
          endPoint:(CGPoint)endPoint
{
    
    int multiplierX = (bubble.frame.origin.x < 0) ? -1 : 1;
    int multiplierY = (bubble.frame.origin.y < 0) ? -1 : 1;
    
    
    
    if (status == STATUS_ACTIVE)
    {
        //self.menuView.alpha=1.0;
        [self.menuView setFrame:CGRectMake(endPoint.x, endPoint.y, 1, 1)];
        [self.menuView animate];
    }
    else if (status == STATUS_LONGPRESS)
    {
        if (self.pictchView.alpha==0.7f)
        {
            [UIView animateWithDuration:0.2 animations:^{
                [self.pictchView setAlpha:0.0];
            }];
            
        }
        else {
            [UIView animateWithDuration:0.2 animations:^{
                [self.pictchView setAlpha:0.7];
            }];
            
        }
        if (self.menuView.alpha==1.0f)
        {
            [self.menuView hide];
            [self resetBackground];
        }

    }
    else if (status == STATUS_DRAGGING)
    {
        if (self.menuView.alpha==1.0f)
        {
            [self.menuView hide];
            [self resetBackground];
        }
        //self.menuView.alpha=0.0;
    }
    
    if(![self isWithinBoundaries:bubble.frame])
    {
        //new position
        CGSize intersectSize = [self sizeIntersect:bubble.frame];
       
        //work out the new frame taking into account what is out
        CGRect newFrame = bubble.frame;
        
       
        newFrame.origin.x-=ABS(intersectSize.width)*multiplierX;
        newFrame.origin.y-=ABS(intersectSize.height)*multiplierY;
        
        [self animateBubble:bubble newFrame:newFrame];
    }
    else
    {
        
        //  NSLog(@"%@, %@",NSStringFromCGPoint(self.center), NSStringFromCGPoint(velocity));
//         [bubble setCenter:CGPointMake(bubble.center.x + (velocity.x/4), bubble.center.y + (velocity.y/4))];
//        CGFloat velX = velocity.x;
//        
//        NSTimeInterval duration = [self width] / velX;
//        
//        CGPoint bubbleCenter = bubble.center;
//        bubbleCenter.x -= multiplierX*ABS([self width]-[bubble width]*0.5);
//        bubbleCenter.y -= multiplierY*ABS([self height]-[bubble height]*0.5);
//        [UIView animateWithDuration:0.4 animations:^{
//            [bubble setCenter:bubbleCenter];
//        }];
        
       // NSLog(@"%f", duration);
//        CGFloat xPoints = 320.0;
//
//       
//        CGPoint offScreenCenter = moveView.center;
//        offScreenCenter.x += xPoints;
//        [UIView animateWithDuration:duration animations:^{
//            moveView.center = offScreenCenter;
//        }];
    }
}

-(BOOL)isWithinBoundaries:(CGRect)frame
{
    CGRect interSection = [self intersectionOfFrameWithSuperViewsFrame:frame];
    
    if (interSection.size.width!= frame.size.width || interSection.size.height!= frame.size.height)
    {
        return NO;
    }
    
    return YES;
}

-(CGRect)intersectionOfFrameWithSuperViewsFrame:(CGRect)frame
{
    return CGRectIntersection(self.frame, frame);
}

-(CGSize)sizeIntersect:(CGRect)frame
{
    CGRect intersectFrame = CGRectIntersection(self.frame, frame);
    return CGSizeMake(frame.size.width - intersectFrame.size.width , frame.size.height - intersectFrame.size.height);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL pointInside = NO;

    if (CGRectContainsPoint(_chatBubbleView.frame, point)) pointInside = YES;
    
    return pointInside;
}


@end
