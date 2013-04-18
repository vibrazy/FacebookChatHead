//
//  DTVFirstViewController.m
//  DTVFacebookChatHead
//
//  Created by Daniel Tavares on 18/04/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import "DTVFirstViewController.h"

@interface DTVFirstViewController ()

@end

@implementation DTVFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *c = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"List.jpg"]];
    [self.view addSubview:c];
    [c addSubview:imgV];
    
    [c setContentSize:CGSizeMake(self.view.frame.size.width, imgV.frame.size.height)];
    
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
