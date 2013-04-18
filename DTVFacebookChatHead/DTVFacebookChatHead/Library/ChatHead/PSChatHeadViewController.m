//
//  PSChatHeadViewController.m
//  Photoshoot
//
//  Created by Daniel Tavares on 16/04/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import "PSChatHeadViewController.h"
#import "PSChatHeadView.h"

@interface PSChatHeadViewController ()

@end

@implementation PSChatHeadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
    }
    return self;
}

CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight) {
    
    CGRect arcRect = CGRectMake(rect.origin.x,
                                rect.origin.y + rect.size.height - arcHeight,
                                rect.size.width, arcHeight);
    
    CGFloat arcRadius = (arcRect.size.height/2) +
    (pow(arcRect.size.width, 2) / (8*arcRect.size.height));
    CGPoint arcCenter = CGPointMake(arcRect.origin.x + arcRect.size.width/2,
                                    arcRect.origin.y + arcRadius);
    
    CGFloat angle = acos(arcRect.size.width / (2*arcRadius));
    CGFloat startAngle = radians(180) + angle;
    CGFloat endAngle = radians(360) - angle;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, arcCenter.x, arcCenter.y, arcRadius,
                 startAngle, endAngle, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    return path;    
    
}
-(CGImageRef)mask
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef gc = CGBitmapContextCreate(NULL, self.view.frame.size.width, self.view.frame.size.height, 8, self.view.frame.size.width, colorSpace, kCGImageAlphaNone);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)[NSArray arrayWithObjects:(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor greenColor].CGColor, nil], NULL);
    CGColorSpaceRelease(colorSpace);
    
    CGRect circlePoint = (CGRectMake(0, 0, 30.0, 30.0));
    
    CGContextFillEllipseInRect(gc, circlePoint);
    
//    CGContextDrawLinearGradient(gc, gradient, CGPointMake(0, 0), CGPointMake(0, self.view.frame.size.height), 0);
    CGGradientRelease(gradient);
    CGImageRef mask = CGBitmapContextCreateImage(gc);
    CGContextRelease(gc);
    
    return mask;
}


CGImageRef createMaskWithImage(CGImageRef image)
{
    int maskWidth               = CGImageGetWidth(image);
    int maskHeight              = CGImageGetHeight(image);
    //  round bytesPerRow to the nearest 16 bytes, for performance's sake
    int bytesPerRow             = (maskWidth + 15) & 0xfffffff0;
    int bufferSize              = bytesPerRow * maskHeight;
    
    //  we use CFData instead of malloc(), because the memory has to stick around
    //  for the lifetime of the mask. if we used malloc(), we'd have to
    //  tell the CGDataProvider how to dispose of the memory when done. using
    //  CFData is just easier and cleaner.
    
    CFMutableDataRef dataBuffer = CFDataCreateMutable(kCFAllocatorDefault, 0);
    CFDataSetLength(dataBuffer, bufferSize);
    
    //  the data will be 8 bits per pixel, no alpha
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef ctx            = CGBitmapContextCreate(CFDataGetMutableBytePtr(dataBuffer),
                                                        maskWidth, maskHeight,
                                                        8, bytesPerRow, colourSpace, kCGImageAlphaNone);
    //  drawing into this context will draw into the dataBuffer.
    CGContextDrawImage(ctx, CGRectMake(0, 0, maskWidth, maskHeight), image);
    CGContextRelease(ctx);
    
    //  now make a mask from the data.
    CGDataProviderRef dataProvider  = CGDataProviderCreateWithCFData(dataBuffer);
    CGImageRef mask                 = CGImageMaskCreate(maskWidth, maskHeight, 8, 8, bytesPerRow,
                                                        dataProvider, NULL, FALSE);
    
    CGDataProviderRelease(dataProvider);
    CGColorSpaceRelease(colourSpace);
    CFRelease(dataBuffer);
    
    return mask;
}


-(void)loadView
{
    self.view = [[PSChatHeadView alloc] initWithFrame:CGRectInset([[UIScreen mainScreen] bounds], 0, 0)];

    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static inline double radians (double degrees) { return degrees * M_PI/180; }
CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight);

@end
