//
//  UIView+FindViewsByClass.h
//
//  Created by Peter Wong on 22/8/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FindViewsByClass)

- (UIView *) superviewOfClass:(Class)aClass;
- (UIView *) subviewOfClass:(Class)aClass;

@end
