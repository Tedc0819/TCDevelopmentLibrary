//
//  TCNoticeView.m
//  mytvHD
//
//  Created by Ted Cheng on 23/8/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCNoticeView.h"

@implementation TCNoticeView

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)showNotice:(TCNotice *)notice
{
    [UIView animateWithDuration:0.05 animations:^{
        [self setAlpha:1];
        [self updateNotice:notice];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.05 animations:^{
        [self setAlpha:0];
    }];
}

- (void)updateNotice:(TCNotice *)notice
{

}

@end
