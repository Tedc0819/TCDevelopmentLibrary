//
//  TCHoriTableViewAdapter.m
//  bokku
//
//  Created by Ted Cheng on 1/11/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCHoriTableViewAdapter.h"

@implementation TCHoriTableViewAdapter

- (void)handleTableView:(UITableView *)tableView
{
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self setTableView:tableView];
}

#pragma mark - DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.ableToCenterCell ? [self headerWidth] : 0)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.ableToCenterCell ? [self headerWidth] : 0)];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
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
    return [self normalCellWidth];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:YES];
        [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//        [cell setSelected:NO];
        if ([self.delegate respondsToSelector:@selector(tableView:WithAdapter:didSelectItem:ItemIndex:)]) {
            [self.delegate tableView:self.tableView WithAdapter:self didSelectItem:self.items[indexPath.row] ItemIndex:indexPath.row];
        }
}

- (void)scrollToIndex:(NSUInteger)index setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self deselectCell];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];

}

- (void)scrollToNextPageWithAnimation:(BOOL)animated
{
    NSIndexPath *indexPath = [self validIndexPathNearToCenter];
    
    NSUInteger desiredRow = indexPath.row + self.numberOfCellDisplay;
    NSUInteger maxNumber = self.items.count - 1;
    
    if (desiredRow > maxNumber) {
        desiredRow = maxNumber;
    }
    
    NSIndexPath *desiredIndexPath = [NSIndexPath indexPathForRow:desiredRow inSection:0];
    [self.tableView scrollToRowAtIndexPath:desiredIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
}

- (void)scrollToPreviousPageWithAnimation:(BOOL)animated
{
    NSIndexPath *indexPath = [self validIndexPathNearToCenter];
    
    NSUInteger desiredRow = indexPath.row - self.numberOfCellDisplay;
    NSUInteger minNumber = 0;
    
    if (desiredRow < minNumber) {
        desiredRow = minNumber;
    }
    
    NSIndexPath *desiredIndexPath = [NSIndexPath indexPathForRow:desiredRow inSection:0];
    [self.tableView scrollToRowAtIndexPath:desiredIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
}

- (void)deselectCell
{
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }];
}

#pragma mark - getter method

- (NSIndexPath *)validIndexPathNearToCenter
{
    CGPoint midPoint = CGPointMake(0, CGRectGetMidY(self.tableView.bounds));
    NSIndexPath *result = [self.tableView indexPathForRowAtPoint:midPoint];
    return result;
}

- (CGFloat)normalCellWidth
{
    return (self.widthOfCell == 0) ? self.tableView.frame.size.width / self.numberOfCellDisplay : self.widthOfCell;
}

- (CGFloat)headerWidth
{
    return (self.tableView.frame.size.width - [self normalCellWidth]) / 2;// + (self.furtherScrollableWhenReachedEdge) * 80;
}



@end
