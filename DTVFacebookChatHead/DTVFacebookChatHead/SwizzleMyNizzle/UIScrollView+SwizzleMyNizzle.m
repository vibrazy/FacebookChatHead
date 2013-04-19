//
//  UIScrollView+SwizzleMyNizzle.m
//  DTVFacebookChatHead
//
//  Created by Daniel Tavares on 19/04/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import "UIScrollView+SwizzleMyNizzle.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITableViewController (SwizzleMyNizzle)

+ (void)load
{
    Method original, swizzled;
    
    original = class_getInstanceMethod(self, @selector(scrollViewDidScroll:));
    swizzled = class_getInstanceMethod(self, @selector(swizzled_scrollViewDidScroll:));
    method_exchangeImplementations(original, swizzled);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{}
- (void)swizzled_scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"Swizzled %@", NSStringFromCGPoint(scrollView.contentOffset));
    [self swizzled_scrollViewDidScroll:scrollView];
}
@end


@implementation NSObject (TopAndBottomSlideOut)
-(void)slideScrollViewDidScroll:(UIScrollView *)scrollView
{
    //post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TopAndBottomSlideOut" object:scrollView];
}
@end

@implementation UINavigationBar (TopAndBottomSlideOut)

- (id)swizzled_initWithFrame:(CGRect)frame
{
    // This is the confusing part (article explains this line).
    id result = [self swizzled_initWithFrame:frame];
    // Return the modified view.
    return result;
}

- (id)swizzled_initWithCoder:(NSCoder *)aDecoder
{
    // This is the confusing part (article explains this line).
    id result = [self swizzled_initWithCoder:aDecoder];
    
    [[NSNotificationCenter defaultCenter] addObserver:result selector:@selector(scrollViewDidScroll:) name:@"TopAndBottomSlideOut" object:nil];
    // Return the modified view.
    return result;
}
+ (void)load
{
    // The "+ load" method is called once, very early in the application life-cycle.
    // It's called even before the "main" function is called. Beware: there's no
    // autorelease pool at this point, so avoid Objective-C calls.
    Method original, swizzle;
    
    // Get the "- (id)initWithCoder:" method.
    original = class_getInstanceMethod(self, @selector(initWithCoder:));
    // Get the "- (id)swizzled_initWithCoder:" method.
    swizzle = class_getInstanceMethod(self, @selector(swizzled_initWithCoder:));
    // Swap their implementations.
    method_exchangeImplementations(original, swizzle);
}
-(void)scrollViewDidScroll:(NSNotification *)notif
{
    UIScrollView *c = (UIScrollView *)[notif object];
    
    id parentView = self.superview;
    
    if (parentView)
    {
        CGRect parentRect = ((UIView*)parentView).frame;
       // parentRect.origin.y-=0.2;
       // parentRect.size.height+=0.2;
        [parentView setFrame:parentRect];
        
        CGRect f = self.frame;
        //f.origin.y-=0.2;
        [self setFrame:f];
    }
}
@end

@implementation UITabBar (TopAndBottomSlideOut)

- (id)swizzled_initWithFrame:(CGRect)frame
{
    // This is the confusing part (article explains this line).
    id result = [self swizzled_initWithFrame:frame];    
    // Return the modified view.
    return result;
}

- (id)swizzled_initWithCoder:(NSCoder *)aDecoder
{
    // This is the confusing part (article explains this line).
    id result = [self swizzled_initWithCoder:aDecoder];
    // Return the modified view.
    [[NSNotificationCenter defaultCenter] addObserver:result selector:@selector(scrollViewDidScroll:) name:@"TopAndBottomSlideOut" object:nil];
    return result;
}
+ (void)load
{
    // The "+ load" method is called once, very early in the application life-cycle.
    // It's called even before the "main" function is called. Beware: there's no
    // autorelease pool at this point, so avoid Objective-C calls.
    Method original, swizzle;
    
    // Get the "- (id)initWithCoder:" method.
    original = class_getInstanceMethod(self, @selector(initWithCoder:));
    // Get the "- (id)swizzled_initWithCoder:" method.
    swizzle = class_getInstanceMethod(self, @selector(swizzled_initWithCoder:));
    // Swap their implementations.
    method_exchangeImplementations(original, swizzle);
}
-(void)scrollViewDidScroll:(NSNotification *)notif
{
    UIScrollView *c = (UIScrollView *)[notif object];
    
    id parentView = self.superview;
    
    CGRect parentRect = ((UIView*)parentView).frame;
    
    parentRect.size.height += (self.frame.size.height - c.contentOffset.y) / (self.frame.size.height/c.contentOffset.y);
    [parentView setFrame:parentRect];

}
@end

@implementation UIView(Border)

- (id)swizzled_initWithFrame:(CGRect)frame
{
    // This is the confusing part (article explains this line).
    id result = [self swizzled_initWithFrame:frame];
    
    // Safe guard: do we have an UIView (or something that has a layer)?
    if ([result respondsToSelector:@selector(layer)]) {
        // Get layer for this view.
        CALayer *layer = [result layer];
        // Set border on layer.
        layer.borderWidth = 1;
        layer.borderColor = [[UIColor redColor] CGColor];
    }
    
    // Return the modified view.
    return result;
}


+ (void)load
{
    // The "+ load" method is called once, very early in the application life-cycle.
    // It's called even before the "main" function is called. Beware: there's no
    // autorelease pool at this point, so avoid Objective-C calls.
    Method original, swizzle;
    
    // Get the "- (id)initWithFrame:" method.
    original = class_getInstanceMethod(self, @selector(initWithFrame:));
    // Get the "- (id)swizzled_initWithFrame:" method.
    swizzle = class_getInstanceMethod(self, @selector(swizzled_initWithFrame:));
    // Swap their implementations.
    method_exchangeImplementations(original, swizzle);
    
}


@end
