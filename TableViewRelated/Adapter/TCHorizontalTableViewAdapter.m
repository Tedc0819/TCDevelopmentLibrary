//
//  TCHorizontalTableViewAdapter.m

//
//  Created by Ted Cheng on 22/7/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCHorizontalTableViewAdapter.h"

#define DummyCellIndex 99999
#define autoScrollInterval 3

@interface TCHorizontalTableViewAdapter ()

@property (nonatomic, strong) NSTimer *deceleratedActionTimer;

@property (nonatomic, strong) NSTimer *autoScrollTimer;

@end

@implementation TCHorizontalTableViewAdapter

- (id)init
{
    self = [super init];
    if (self) {
    
    }
    return self;
}

- (void)handleTableView:(UITableView *)tableView
{
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self setTableView:tableView];
}

#pragma mark - DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count + (self.ableToCenterCell ? 2 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

#pragma mark - Delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self isNotDummyCellWithIndexPath:indexPath]) ? [self normalCellWidth] : [self dummyCellWidth];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isNotDummyCellWithIndexPath:indexPath]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:YES];
        [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [cell setSelected:NO];
        if ([self.delegate respondsToSelector:@selector(tableView:WithAdapter:didSelectItem:ItemIndex:)]) {
            int itemIndex = [self itemIndexWithIndexPath:indexPath];
            [self.delegate tableView:self.tableView WithAdapter:self didSelectItem:[self.items objectAtIndex:itemIndex] ItemIndex:itemIndex];
        }
    }
    
}

#pragma mark - scrollView Deleagate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self autoCenterCellShouldWork]) {
        [self.deceleratedActionTimer invalidate];
        self.deceleratedActionTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(moveNearestCellToCenterWithAnimataion:) userInfo:nil repeats:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(tableView:WithAdapter:didScrollToItem:ItemIndex:)]) {
        int index = [self itemIndexWithIndexPath:[self validIndexPathNearToCenter]];
        if (index >=0) {
            [self.delegate tableView:self.tableView WithAdapter:self didScrollToItem:[self.items objectAtIndex:index] ItemIndex:index];

        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopAutoSCroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        if ([self autoCenterCellShouldWork]) [self moveNearestCellToCenterWithAnimataion:YES];
        [self startAutoScroll];
    }
}



#pragma mark - getter method

- (BOOL)autoCenterCellShouldWork
{
    return self.ableToCenterCell && self.shouldAutoCenterCell;
}

- (BOOL)isNotDummyCellWithIndexPath:(NSIndexPath *)indexPath
{
    if (!self.ableToCenterCell) return YES;
    return !(indexPath.row == 0 || indexPath.row == self.items.count + 1) ;
}

- (CGFloat)normalCellWidth
{
    return (self.widthOfCell == 0) ? self.tableView.frame.size.width / self.numberOfCellDisplay : self.widthOfCell;
}

- (CGFloat)dummyCellWidth
{
    return (self.tableView.frame.size.width - [self normalCellWidth]) / 2 + (self.furtherScrollableWhenReachedEdge) * 80;
}

- (int)itemIndexWithIndexPath:(NSIndexPath *)indexPath
{
    if (!self.ableToCenterCell) return indexPath.row;
    return [self isNotDummyCellWithIndexPath:indexPath] ? indexPath.row - 1 : DummyCellIndex;
}

- (NSIndexPath *)indexPathWithItemIndex:(int) itemIndex
{
    if (!self.ableToCenterCell) return [NSIndexPath indexPathForRow:itemIndex inSection:0];;
    return [NSIndexPath indexPathForRow:itemIndex + 1 inSection:0];
}

- (NSIndexPath *)validIndexPathNearToCenter
{
    CGPoint midPoint = CGPointMake(0, CGRectGetMidY(self.tableView.bounds));
    NSIndexPath *result = [self.tableView indexPathForRowAtPoint:midPoint];
    if (![self isNotDummyCellWithIndexPath:result]) {
        if (result.row < 1) {
            result = [NSIndexPath indexPathForRow:result.row + 1 inSection:0];
        } else {
            result = [NSIndexPath indexPathForRow:result.row - 1 inSection:0];
        }
    }
    return result;
}



#pragma mark - helper method

- (void)moveItemToCenterWithItemIndex:(int) itemIndex WithAnimation:(BOOL) animated
{
    if (self.items.count == 0) return;
    @try {
        [self.tableView scrollToRowAtIndexPath:[self indexPathWithItemIndex:itemIndex] atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception!");
    }
    
    if ([self.delegate respondsToSelector:@selector(tableView:WithAdapter:didScrollToItem:ItemIndex:)]) {
        int index = [self itemIndexWithIndexPath:[self validIndexPathNearToCenter]];
        if (index >=0) {
            [self.delegate tableView:self.tableView WithAdapter:self didScrollToItem:[self.items objectAtIndex:index] ItemIndex:index];
        }
    }
    
}


- (void)moveNearestCellToCenterWithAnimataion:(BOOL) animated
{
    NSIndexPath *result = [self validIndexPathNearToCenter];
    [self.tableView scrollToRowAtIndexPath:result atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
    
    if ([self.delegate respondsToSelector:@selector(tableView:WithAdapter:didScrollToItem:ItemIndex:)]) {
        int index = [self itemIndexWithIndexPath:[self validIndexPathNearToCenter]];
        [self.delegate tableView:self.tableView WithAdapter:self didScrollToItem:[self.items objectAtIndex:index] ItemIndex:index];
    }
}

#pragma mark - autoScroll function

- (void)autoScroll
{
    int currentItemIndex = [self itemIndexWithIndexPath:[self validIndexPathNearToCenter]];
    int nextItemIndex = (currentItemIndex + 1) > self.items.count - 1 ? 0 : currentItemIndex + 1;
    
    [UIView animateWithDuration:0.7 animations:^{
        [self moveItemToCenterWithItemIndex:nextItemIndex WithAnimation:NO];
    }];
}

- (void)startAutoScroll
{
    if (!self.shouldAutoScroll) return;
    if (!self.items.count) return;
    
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:autoScrollInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    
}

- (void)stopAutoSCroll
{
    [self.autoScrollTimer invalidate];
}

@end
