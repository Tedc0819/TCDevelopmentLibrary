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

@end

@implementation TCSegmentingManager

- (id)init
{
    self = [super init];
    if (self) {
        self.controlButtonManager = [[TCSegmentedControlButtonManager alloc] init];
    }
    return self;
}

- (void)setup
{
    [self.controlButtonManager setButtons:[self controlButtonManagerButtons]];
}

#pragma mark - data getter from datasource

- (NSUInteger)numberOfSegment
{
    return [self.datasource segmentingManagerShouldHaveNumberOfSegments:self];
}

- (NSArray *)controlButtonManagerButtons
{
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self numberOfSegment]; i++) {
        [buttons addObject:[self.datasource segmentingManager:self buttonAtIndex:i]];
    }
    return buttons.copy;
}

@end
