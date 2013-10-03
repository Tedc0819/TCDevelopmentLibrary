//
//  TCSegmentingManager.h
//  bokku
//
//  Created by Ted Cheng on 3/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCSegmentedResourcesManager.h"
#import "TCSegmentedControlButtonManager.h"

@protocol TCSegmentingManagerDataSource;

@interface TCSegmentingManager : NSObject

@property (nonatomic, strong) TCSegmentedControlButtonManager *controlButtonManager;
@property (nonatomic, strong) TCSegmentedResourcesManager *resourceManager;
@property (nonatomic, weak) id<TCSegmentingManagerDataSource> datasource;

- (id)initWithNumberOfSegments:(NSUInteger)numberOfSegments;

@end

@protocol TCSegmentingManagerDataSource <NSObject>

@required

- (NSUInteger)segmentingManagerShouldHaveNumberOfSegments:(TCSegmentedResourcesManager *)segmentingManager;
- (UIButton *)segmentingManager:(TCSegmentedResourcesManager *)segmentingManager buttonAtIndex:(NSUInteger) index;


@end