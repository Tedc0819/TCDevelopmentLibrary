//
//  TCSegmentingManager.h
//  bokku
//
//  Created by Ted Cheng on 3/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCSegmentedControlButtonManager.h"

@protocol TCSegmentingManagerDataSource;

@interface TCSegmentingManager : NSObject

@property (nonatomic, strong) TCSegmentedControlButtonManager *controlButtonManager;
@property (nonatomic, weak) id<TCSegmentingManagerDataSource> datasource;

- (void)setup;

@end

@protocol TCSegmentingManagerDataSource <NSObject>

@required

- (NSUInteger)segmentingManagerShouldHaveNumberOfSegments:(TCSegmentingManager *)segmentingManager;
- (UIButton *)segmentingManager:(TCSegmentingManager *)segmentingManager buttonAtIndex:(NSUInteger) index;

@end