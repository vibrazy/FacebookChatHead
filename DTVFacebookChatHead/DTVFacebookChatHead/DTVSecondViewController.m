//
//  DTVSecondViewController.m
//  DTVFacebookChatHead
//
//  Created by Daniel Tavares on 18/04/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import "DTVSecondViewController.h"
#import "DTVSlidingMenu.h"
#import "ViewUtils.h"

@interface DTVSecondViewController ()

@end

@implementation DTVSecondViewController
{
    DTVSlidingMenu *m;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIScrollView *c = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"List.jpg"]];
    [self.view addSubview:c];
    [c addSubview:imgV];
    
    
      
    
    
    [c setContentSize:CGSizeMake(self.view.frame.size.width, imgV.frame.size.height)];
    
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    
    m = [[DTVSlidingMenu alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-58, self.view.frame.size.width, 58)];
    [self.view addSubview:m];
    
    
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [m addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [m addGestureRecognizer:tapRecognizer];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    UIView *parentV =m;
    
    if ([parentV y] < ([self.view height]-58))
    {
        [m animateDown];
        [UIView animateWithDuration:0.3 animations:^{
            [parentV setY:568];
        }];
    }
    else {
        [m animateUp];
        [UIView animateWithDuration:0.3 animations:^{
            [parentV setY:[parentV height]-58];
        }];
    }
    
    
}

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    
    
    UIView *parentV =[panRecognizer view];
    
    CGPoint imageViewPosition = parentV.center;
    CGPoint translation = [panRecognizer translationInView:parentV];
    
    float diff = imageViewPosition.y - (imageViewPosition.y += translation.y);
    
   
      NSLog(@"%f", diff);
    
    
    imageViewPosition.y += translation.y;
    
  
    if (diff>10) {
        [m animateUp];
        [UIView animateWithDuration:0.3 animations:^{
            [parentV setY:[parentV height]-58];
        }];
        return;
    } else if (diff < -10) {
       
        [m animateDown];
        [UIView animateWithDuration:0.3 animations:^{
            [parentV setY:568];
        }];
        return;
    }
    
    
    
    if (imageViewPosition.y>285 && imageViewPosition.y<561)
    {
        parentV.layer.position = imageViewPosition;   
    }
    
   

    [panRecognizer setTranslation:CGPointZero inView:parentV];
    
 
    
    
    if (panRecognizer.state==UIGestureRecognizerStateBegan)
    {
        
        
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateEnded)
    {
        
        
    }
}

@end
