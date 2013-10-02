//
//  TCHorizontalViewListAdapter.m

//
//  Created by Ted Cheng on 22/7/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCHorizontalViewListAdapter.h"

@implementation TCHorizontalViewListAdapter

- (id)init
{
    self = [super init];
    if (self) {
        self.ableToCenterCell = NO;
        self.shouldAutoCenterCell = YES;
        self.numberOfCellDisplay = 1;
        self.furtherScrollableWhenReachedEdge = NO;
        self.shouldAutoScroll = NO;
        self.shouldMoveToMiddleCellAfterUpdate = NO;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self isNotDummyCellWithIndexPath:indexPath]) {
        UITableViewCell *dummyCell = [tableView dequeueReusableCellWithIdentifier:@"DummyCell"];
        
        if (!dummyCell) {
            dummyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DummyCell"];
        }
        return dummyCell;
    }
    
    static NSString *CellIdentifier = @"HoriButtonsViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.contentView setTransform:CGAffineTransformMakeRotation( M_PI / 2)];
    }
    
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        [subview removeFromSuperview];
    }];
    
    UIView *itemView = [self.items objectAtIndex:indexPath.row];
    [cell.contentView addSubview:itemView];
    
    return cell;
}

@end
