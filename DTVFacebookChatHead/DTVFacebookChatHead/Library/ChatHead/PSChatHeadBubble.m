//
//  PSChatHeadBubble.m
//  Photoshoot
//
//  Created by Daniel Tavares on 17/04/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import "PSChatHeadBubble.h"
#import "ViewUtils.h"

#define THRESHOLD   500.f
#define SWIPE_UP_THRESHOLD -THRESHOLD
#define SWIPE_DOWN_THRESHOLD THRESHOLD
#define SWIPE_LEFT_THRESHOLD -THRESHOLD
#define SWIPE_RIGHT_THRESHOLD THRESHOLD

@interface PSChatHeadBubble()

@end

int springConstant = 600;
int dampingCoefficient = 12;
int mass = 1;


@implementation PSChatHeadBubble
{
    CGPoint _velocity;
    CADisplayLink *displayLink;
    UIPanGestureRecognizer * panGestureRecognizer;
    CGPoint endPoint;
    UIImageView *_imageView;
    UIView *options;
    BOOL showingMenu;
    CGPoint restorePoint;
}

- (id)initWithFrame:(CGRect)frame movedBlock:(PSChatBubbleMoved)aBlock
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _imageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointZero, frame.size}];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setImage:[UIImage imageNamed:@"menu"]];
        _imageView.layer.shadowColor=[UIColor blackColor].CGColor;
        _imageView.layer.shadowOffset=CGSizeMake(-1, 1);
        _imageView.layer.shadowOpacity=0.5;
        _imageView.layer.shadowRadius=1.f;
        
        showingMenu = YES;
        
        self.status=STATUS_DRAGGING;
        
        
        [self addSubview:_imageView];
        // Initialization code
        [self setupGestures];
        
        _movedBlock=aBlock;
        
        //initialize display link
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:(id)kCFRunLoopCommonModes];
        
    }
    return self;
}

-(CGPoint)endPointValue
{
    return CGPointMake(self.superview.frame.size.width * 0.5, self.superview.frame.size.height-(([self height]*0.5) + 10));
}

-(void)didMoveToSuperview
{
    endPoint = [self endPointValue];
}

#pragma mark - Display Link

#pragma mark - Property Overrides
- (BOOL)panning {
	return (panGestureRecognizer.state == UIGestureRecognizerStateChanged);
}

- (void)displayLinkTick:(CADisplayLink *)link
{
	[self simulateSpringWithDisplayLink:link];
}

#pragma mark - Physics
- (void)simulateSpringWithDisplayLink:(CADisplayLink *)aDisplayLink
{
	if (!self.panning)
    {
		for (int i = 0; i < aDisplayLink.frameInterval; i++)
        {
			
			CGPoint displacement = CGPointMake(self.center.x - endPoint.x,
											   self.center.y - endPoint.y);
			
			CGPoint kx = CGPointMake(springConstant * displacement.x, springConstant * displacement.y);
			CGPoint bv = CGPointMake(dampingCoefficient	* _velocity.x, dampingCoefficient * _velocity.y);
			
            CGPoint acceleration = CGPointMake((kx.x + bv.x) / mass, (kx.y + bv.y) / mass);
			
			_velocity.x -= (acceleration.x * aDisplayLink.duration);
			_velocity.y -= (acceleration.y * aDisplayLink.duration);
			
			CGPoint newCenter = self.center;
			newCenter.x += (_velocity.x * aDisplayLink.duration);
			newCenter.y += (_velocity.y * aDisplayLink.duration);
			[self setCenter:newCenter];
		}
	}
}

-(void)setupGestures
{
    
    self.userInteractionEnabled = YES;
    
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [self addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationDetected:)];
    [self addGestureRecognizer:rotationRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapRecognizer];
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [longTap setMinimumPressDuration:0.5f];
    [self addGestureRecognizer:longTap];

}

#pragma mark - Touches
-(void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (self.status!=STATUS_LONGPRESS)
    {
        if (longPress.state == UIGestureRecognizerStateBegan)
        {
            if (showingMenu)
            {
                [_imageView setImage:[UIImage imageNamed:@"football"]];
                showingMenu=NO;
                endPoint = [self endPointValue];
            }
            else
            {
                [_imageView setImage:[UIImage imageNamed:@"menu"]];
                showingMenu=YES;
            }
            
            
            self.status=STATUS_LONGPRESS;
            [_imageView setNeedsDisplay];
            [self executeBlock];
        }
    }
}
- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    
    if (self.status==STATUS_ACTIVE)
    {
        NSLog(@"tap and its active");
        
        self.status=STATUS_DRAGGING;
        
        [self resetBall];
        [self resetBackground];
        
        endPoint = restorePoint;

        
        if (tapRecognizer.state == UIGestureRecognizerStateEnded)
        {
            [self executeBlock];
        }
    }
    else
    {
        UIView *superView = self.superview;
        
        float width = [_imageView width]*.5;
        float height = ([_imageView height]*.5)+20;
        
        [self parentBackground];
        
        [self resetBall];
        
        endPoint = CGPointMake([superView width]-width, height);
        
        restorePoint = self.center;
        
        self.status = STATUS_ACTIVE;
        
        if (tapRecognizer.state == UIGestureRecognizerStateEnded)
        {
            [self executeBlock];
        }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    if (self.status==STATUS_DRAGGING)
    {
        [self animateBall];
    }

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.status = STATUS_DRAGGING;
    
    [self resetBackground];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetBall];
}



#pragma mark - Directions
#pragma mark - Panning
-(void)animateBall
{
    [UIView animateWithDuration:0.1 animations:^{
        [self setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
        _imageView.layer.shadowOffset=CGSizeMake(-1, 5);
        _imageView.layer.shadowOpacity=0.5;
        _imageView.layer.shadowRadius=20.f;
    }];
}
-(void)resetBall
{
    
    //scale and change shadow
    [UIView animateWithDuration:0.1 animations:^{
        [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        _imageView.layer.shadowOffset=CGSizeMake(-1, 1);
        _imageView.layer.shadowOpacity=0.5;
        _imageView.layer.shadowRadius=1.f;
    }];
}

#pragma mark - Gestures
#pragma mark - Gestures Delegates
- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint translation = [panRecognizer translationInView:[[panRecognizer view] superview]];
    CGPoint imageViewPosition = self.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;
    
    self.layer.position = imageViewPosition;
    [panRecognizer setTranslation:CGPointZero inView:[[panRecognizer view] superview]];
    
    
    
    if (self.status==STATUS_ACTIVE) {
        self.status = STATUS_DRAGGING;        
    }

    
    if (panRecognizer.state==UIGestureRecognizerStateBegan)
    {
        
      
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateEnded)
    {
        
       
        [self resetBall];
        
        
        _velocity = [panRecognizer velocityInView:[[panRecognizer view] superview]];
        
        PAN_DIRECTION_MASK direction = PAN_DIRECTION_NONE;
        
        if (_velocity.x < SWIPE_LEFT_THRESHOLD)
        {
           direction |= PAN_DIRECTION_LEFT;
        }
        
        if (_velocity.x > SWIPE_RIGHT_THRESHOLD)
        {
            direction |= PAN_DIRECTION_RIGHT;
        }
        
        if (_velocity.y < SWIPE_UP_THRESHOLD)
        {
            direction |= PAN_DIRECTION_UP;
            
        }
        
        if (_velocity.y > SWIPE_DOWN_THRESHOLD)
        {
            direction |= PAN_DIRECTION_DOWN;
        }
        
        //remove none
        self.direction=direction& ~PAN_DIRECTION_NONE;
        
        [self updateEndPlace];
    }
    
    [self executeBlock];
}

-(void)updateEndPlace
{
    
    UIView *superView = self.superview;
    
    float width = [_imageView width]*.5;
    float height = ([_imageView height]*.5)+20;
    
    if (self.direction==PAN_DIRECTION_UPRIGHT)
    {
        endPoint = CGPointMake([superView width]-width, height);
    }
    else if (self.direction==PAN_DIRECTION_UPLEFT)
    {
        endPoint = CGPointMake(width, height);
    }
    else if (self.direction==PAN_DIRECTION_UP)
    {
        endPoint = CGPointMake(self.center.x, height);
    }
    else if (self.direction==PAN_DIRECTION_DOWNLEFT)
    {
        endPoint = CGPointMake(width, [superView height]-height);
    }
    else if (self.direction==PAN_DIRECTION_DOWNRIGHT)
    {
        endPoint = CGPointMake([superView width]-width, [superView height]-height);
    }
    else if (self.direction==PAN_DIRECTION_DOWN)
    {
        endPoint = CGPointMake(self.center.x, [superView height]-height);
    }
    else if (self.direction==PAN_DIRECTION_RIGHT)
    {
        endPoint = CGPointMake([superView width]-width, self.center.y);
    }
    else if (self.direction==PAN_DIRECTION_LEFT)
    {
        endPoint = CGPointMake(width, self.center.y);
    }
    else
    {
        float xPos = (self.layer.position.x < superView.center.x) ? width : [superView width]-width;
        endPoint = CGPointMake(xPos, self.center.y);
    }
    
    [self executeBlock];
    
}

-(void)executeBlock
{
    if (self.movedBlock)
    {
        self.movedBlock(self, self.direction,_velocity, self.status, endPoint);
    }
}

- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizer
{
    CGFloat scale = pinchRecognizer.scale;
    self.transform = CGAffineTransformScale(self.transform, scale, scale);
    pinchRecognizer.scale = 1.0;
    
    [self executeBlock];
}

- (void)rotationDetected:(UIRotationGestureRecognizer *)rotationRecognizer
{
    CGFloat angle = rotationRecognizer.rotation;
    self.transform = CGAffineTransformRotate(self.transform, angle);
    rotationRecognizer.rotation = 0.0;
    
    [self executeBlock];
}


-(void)resetBackground
{
  
    UIColor *fromColor = self.superview.backgroundColor;
    UIColor *toColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.duration = 0.12;
    colorAnimation.fromValue = (id)fromColor.CGColor;
    colorAnimation.toValue = (id)toColor.CGColor;
    [self.superview.layer addAnimation:colorAnimation forKey:@"backgroundColor"];
    [self.superview setBackgroundColor:toColor];

    
}

-(void)parentBackground
{
   
        UIColor *fromColor = self.superview.backgroundColor;
        UIColor *toColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        colorAnimation.duration = 0.12;
        colorAnimation.fromValue = (id)fromColor.CGColor;
        colorAnimation.toValue = (id)toColor.CGColor;
        [self.superview.layer addAnimation:colorAnimation forKey:@"backgroundColor"];
        [self.superview setBackgroundColor:toColor];
    
}

@end
