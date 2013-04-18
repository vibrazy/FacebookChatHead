//
//  PSChatHeadBubble.h
//  Photoshoot
//
//  Created by Daniel Tavares on 17/04/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    PAN_DIRECTION_NONE          = 1 << 0,
    PAN_DIRECTION_UP            = 1 << 1,
    PAN_DIRECTION_DOWN          = 1 << 2,
    PAN_DIRECTION_LEFT          = 1 << 3,
    PAN_DIRECTION_RIGHT         = 1 << 4,
    PAN_DIRECTION_UPRIGHT       = PAN_DIRECTION_UP      |   PAN_DIRECTION_RIGHT,
    PAN_DIRECTION_UPLEFT        = PAN_DIRECTION_UP      |   PAN_DIRECTION_LEFT,
    PAN_DIRECTION_DOWNRIGHT     = PAN_DIRECTION_DOWN    |   PAN_DIRECTION_RIGHT,
    PAN_DIRECTION_DOWNLEFT      = PAN_DIRECTION_DOWN    |   PAN_DIRECTION_LEFT,
} PAN_DIRECTION_MASK;

typedef enum
{
    STATUS_ACTIVE               = 1 << 0,
    STATUS_DRAGGING             = 1 << 1,
    STATUS_LONGPRESS             = 1 << 2
} STATUS_MASK;

@class  PSChatHeadBubble;

typedef void(^PSChatBubbleMoved)(PSChatHeadBubble *bubble , PAN_DIRECTION_MASK direction, CGPoint velocity, STATUS_MASK status, CGPoint endPoint);

@interface PSChatHeadBubble : UIView

- (id)initWithFrame:(CGRect)frame movedBlock:(PSChatBubbleMoved)aBlock;

@property (nonatomic, copy)     PSChatBubbleMoved   movedBlock;
@property (assign, nonatomic)   PAN_DIRECTION_MASK  direction;
@property (assign, nonatomic)   STATUS_MASK         status;

@end
