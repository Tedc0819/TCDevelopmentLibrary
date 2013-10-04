//
//  TCHorizontalTableView.m

//
//  Created by Ted Cheng on 21/7/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCHorizontalTableView.h"

@implementation TCHorizontalTableView

- (id)initWithFrame:(CGRect)frame
{
//    float tmpValue = frame.size.height;
//    frame.size.height = frame.size.width;
//    frame.size.width = tmpValue;
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setTransform:CGAffineTransformMakeRotation( 3 * M_PI / 2)];
        [self setFrame:frame];
        [self setShowsVerticalScrollIndicator:NO];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    for (UIView* child in [self subviews]) {
        CGRect frame1 = child.frame;
        if ([child isKindOfClass:[UITableViewCell class]]) {
            frame1.size.width = self.bounds.size.width;
            child.frame = frame1;
        }
        if ([child isKindOfClass:[NSClassFromString(@"UITableViewWrapperView") class]]) {
            for (UIView* cell in [child subviews]) {
                CGRect frame1 = cell.frame;
                if ([cell isKindOfClass:[UITableViewCell class]]) {
                    frame1.size.width = self.bounds.size.width;
                    cell.frame = frame1;
                }
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
