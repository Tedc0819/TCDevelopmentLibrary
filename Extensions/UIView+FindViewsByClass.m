//
//  UIView+FindViewsByClass.m
//  myVOD
//
//  Created by Peter Wong on 22/8/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "UIView+FindViewsByClass.h"

@implementation UIView (FindViewsByClass)

- (UIView *)superviewOfClass:(Class)aClass {
    UIView *result = nil;
    UIView *current = self;
    
    while ([current superview] != nil) {
        current = [current superview];
        
        if ([current isKindOfClass:aClass]) {
            result = current;
            break;
        }
    }
    
    return result;
}

- (UIView *)subviewOfClass:(Class)aClass {
    UIView *result = nil;
    NSMutableArray *queue = [NSMutableArray arrayWithObject:self];
    
    // Breadth first search
    while ([queue count] > 0) {
        UIView *current = [queue objectAtIndex:0];
        
        if ([current isKindOfClass:aClass]) {
            result = current;
            break;
        } else {
            for (UIView *subview in [current subviews]) {
                [queue addObject:subview];
            }
            [queue removeObjectAtIndex:0];
        }
    }
    
    return result;
}

@end
