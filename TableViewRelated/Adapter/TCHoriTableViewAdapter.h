//
//  TCHoriTableViewAdapter.h
//  bokku
//
//  Created by Ted Cheng on 1/11/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCHoriTableViewAdapterDelegate;

@interface TCHoriTableViewAdapter : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *items;

// numberOfCellDisplay will only be considered when widthOfCell == 0
@property (nonatomic, assign) float numberOfCellDisplay;
@property (nonatomic, assign) float widthOfCell;

@property (nonatomic, assign) BOOL ableToCenterCell;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) id<TCHoriTableViewAdapterDelegate> delegate;

- (void)handleTableView:(UITableView *)tableView;
- (NSIndexPath *)validIndexPathNearToCenter;
- (void)scrollToNextPageWithAnimation:(BOOL)animated;
- (void)scrollToPreviousPageWithAnimation:(BOOL)animated;

@end
