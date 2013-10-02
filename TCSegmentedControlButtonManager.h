//
//  TCSegmentedControlButtonManager.h
//  bokku
//
//  Created by Ted Cheng on 3/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCSegmentedControlButtonManagerDelegate;

@interface TCSegmentedControlButtonManager : NSObject

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, weak) id<TCSegmentedControlButtonManagerDelegate> delegate;

@end

@protocol TCSegmentedControlButtonManagerDelegate <NSObject>

@optional
- (void)segmentedControlButtonManager:(TCSegmentedControlButtonManager *) manager DidClickedButton:(UIButton *) button;
- (void)segmentedControlButtonManager:(TCSegmentedControlButtonManager *) manager DidChangeCurrentIndexToButton:(UIButton *) button;

@end