//
//  TCSegmentedControlButtonManager.m
//  bokku
//
//  Created by Ted Cheng on 3/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCSegmentedControlButtonManager.h"

@implementation TCSegmentedControlButtonManager

- (id)init
{
    self = [super init];
    if (self) {
        self.currentIndex = 0;
    }
    return self;
}

- (void)setButtons:(NSArray *)buttons
{
    _buttons = buttons;
    [_buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        [button addTarget:self action:@selector(buttonDidSelect:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:idx];
    }];
    
    self.currentIndex = 0;
    [self updateButtonState];
}

- (void)buttonDidSelect:(UIButton *) button
{
    if ([self.delegate respondsToSelector:@selector(segmentedControlButtonManager:DidClickedButton:)]) {
        [self.delegate segmentedControlButtonManager:self DidClickedButton:button];
    }
    
    if (button.tag == self.currentIndex) return;
    
    self.currentIndex = button.tag;
    [self updateButtonState];
    
    if ([self.delegate respondsToSelector:@selector(segmentedControlButtonManager:DidChangeCurrentIndexToButton:)]) {
        [self.delegate segmentedControlButtonManager:self DidChangeCurrentIndexToButton:button];
    }
}

- (void)updateButtonState
{
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        [button setSelected:(button.tag == self.currentIndex)];
    }];
}


@end
