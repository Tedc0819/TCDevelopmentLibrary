//
//  TCSegmentingManager.h
//  bokku
//
//  Created by Ted Cheng on 3/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCSegmentedControlButtonManager.h"

@interface TCSegmentingManager : NSObject

@property (nonatomic, strong) TCSegmentedControlButtonManager *controlButtonManager;

- (id)initWithButtons:(NSArray *)buttons;
- (NSArray *)currentItems;
- (void)setItems:(NSArray *)items ForIndex:(NSUInteger)index;

@end