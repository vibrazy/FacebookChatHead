//
//  UIScrollView+SwizzleMyNizzle.h
//  DTVFacebookChatHead
//
//  Created by Daniel Tavares on 19/04/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UITableViewController (SwizzleMyNizzle)
@end

@interface UINavigationBar (TopAndBottomSlideOut)
@end

@interface UITabBar (TopAndBottomSlideOut)
@end

@interface NSObject (TopAndBottomSlideOut)
-(void)slideScrollViewDidScroll:(UIScrollView *)scrollView;
@end


@interface UIView(Border)
@end