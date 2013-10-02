//
//  TCHorizontalTableViewAdapter.h
//  myVOD
//
//  Created by Ted Cheng on 22/7/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCHorizontalTableViewAdapterDelegate;

@interface TCHorizontalTableViewAdapter : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *items;

// numberOfCellDisplay will only be considered when widthOfCell == 0
@property (nonatomic, assign) float numberOfCellDisplay;
@property (nonatomic, assign) float widthOfCell;

@property (nonatomic, assign) BOOL ableToCenterCell;
@property (nonatomic, assign) BOOL shouldAutoCenterCell;
@property (nonatomic, assign) BOOL furtherScrollableWhenReachedEdge;
@property (nonatomic, assign) BOOL shouldAutoScroll;
@property (nonatomic, assign) BOOL shouldMoveToMiddleCellAfterUpdate;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) id<TCHorizontalTableViewAdapterDelegate> delegate;

- (BOOL)isNotDummyCellWithIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)validIndexPathNearToCenter;
- (void)moveNearestCellToCenterWithAnimataion:(BOOL) animated;
- (void)moveItemToCenterWithItemIndex:(int) itemIndex WithAnimation:(BOOL) animated;
- (int)itemIndexWithIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathWithItemIndex:(int) itemIndex;

- (void)handleTableView:(UITableView *)tableView;
- (void)startAutoScroll;

- (CGFloat)normalCellWidth;
- (CGFloat)dummyCellWidth;
@end

@protocol TCHorizontalTableViewAdapterDelegate <NSObject>

@optional
- (void)tableView:(UITableView *) tableView WithAdapter:(TCHorizontalTableViewAdapter *) adapter didScrollToItem:(id) item ItemIndex:(int) index;

- (void)tableView:(UITableView *) tableView WithAdapter:(TCHorizontalTableViewAdapter *) adapter didSelectItem:(id) item ItemIndex:(int) index;

@end