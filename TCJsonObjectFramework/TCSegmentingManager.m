//
//  TCSegmentingManager.m
//  bokku
//
//  Created by Ted Cheng on 3/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCSegmentingManager.h"

@interface TCSegmentingManager()

@property (nonatomic, strong) NSMutableArray *resourceArrays;
@property (nonatomic, strong) NSArray *segmentedControlButtons;

@end

@implementation TCSegmentingManager

- (id)initWithButtons:(NSArray *)buttons
{
    self = [self init];
    if (self) {
        self.controlButtonManager = [[TCSegmentedControlButtonManager alloc] init];
        [self.controlButtonManager setButtons:buttons];
        self.resourceArrays = [self emptyResourceArrays];
    }
    return self;
}

- (void)setItems:(NSArray *)items ForIndex:(NSUInteger)index
{
    if (index >= [self numberOfSegment]) return;
    [self.resourceArrays setObject:items atIndexedSubscript:index];
}

#pragma mark - getter method

- (NSArray *)currentItems
{
    return self.resourceArrays[self.controlButtonManager.currentIndex];
}

#pragma mark - data getter from datasource

- (NSUInteger)numberOfSegment
{
    return self.controlButtonManager.buttons.count ? self.controlButtonManager.buttons.count : 1;
}

- (NSMutableArray *)emptyResourceArrays
{
    NSMutableArray *itemArrays = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self numberOfSegment]; i++) {
        [itemArrays addObject:@[]];
    }
    return itemArrays;
}

@end
