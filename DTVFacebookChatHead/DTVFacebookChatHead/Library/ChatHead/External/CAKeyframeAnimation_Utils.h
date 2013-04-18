//
//  CAKeyframeAnimation_Utils.h
//  Photoshoot
//
//  Created by Daniel Tavares on 17/04/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

// this should be a function that takes a time value between
//  0.0 and 1.0 (where 0.0 is the beginning of the animation
//  and 1.0 is the end) and returns a scale factor where 0.0
//  would produce the starting value and 1.0 would produce the
//  ending value
typedef double (^KeyframeParametricBlock)(double);

@interface CAKeyframeAnimation (Parametric)

+ (id)animationWithKeyPath:(NSString *)path
function:(KeyframeParametricBlock)block
fromValue:(double)fromValue
toValue:(double)toValue;

@end;

@implementation CAKeyframeAnimation (Parametric)

+ (id)animationWithKeyPath:(NSString *)path
                  function:(KeyframeParametricBlock)block
                 fromValue:(double)fromValue
                   toValue:(double)toValue {
    // get a keyframe animation to set up
    CAKeyframeAnimation *animation =
    [CAKeyframeAnimation animationWithKeyPath:path];
    // break the time into steps
    //  (the more steps, the smoother the animation)
    NSUInteger steps = 100;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:steps];
    double time = 0.0;
    double timeStep = 1.0 / (double)(steps - 1);
    for(NSUInteger i = 0; i < steps; i++) {
        double value = fromValue + (block(time) * (toValue - fromValue));
        [values addObject:[NSNumber numberWithDouble:value]];
        time += timeStep;
    }
    // we want linear animation between keyframes, with equal time steps
    animation.calculationMode = kCAAnimationLinear;
    // set keyframes and we're done
    [animation setValues:values];
    return(animation);
}

@end