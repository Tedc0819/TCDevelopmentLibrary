//
//  TCURLImageViewListAdapter.m
//  myVOD
//
//  Created by Ted Cheng on 22/7/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCURLImageViewListAdapter.h"
#import "ImageCache.h"
#define kImageViewTag 11111

@implementation TCURLImageViewListAdapter
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
            [dummyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [dummyCell.contentView setBackgroundColor:[UIColor blackColor]];
        }
        return dummyCell;
    }
    
    static NSString *CellIdentifier = @"URLBannerViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [cell.contentView setTransform:CGAffineTransformMakeRotation( M_PI / 2)];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame: CGRectInset(cell.bounds, 2, 2)];
        [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [imageView setTag:kImageViewTag];
        [cell.contentView addSubview:imageView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView setBackgroundColor:[UIColor blackColor]];
    }

    cell.tag = indexPath.row;
    
    UIImageView *tmpImageView = (UIImageView *)[cell viewWithTag:kImageViewTag];

    id tmpImage = [self.items objectAtIndex:[self itemIndexWithIndexPath:indexPath]];

    if ([tmpImage isKindOfClass:[UIImage class]]) {
        [tmpImageView setImage:tmpImage];
    }
    if ([tmpImage isKindOfClass:[NSURL class]]) {
        [tmpImageView setImage:[self isNotDummyCellWithIndexPath:indexPath] ? [UIImage imageNamed:DefaultImage] : nil];

        if ([self isNotDummyCellWithIndexPath:indexPath]) {
            __block NSIndexPath *tmpIndexPath = indexPath;
            [ImageCache loadImageForURL:[self.items objectAtIndex:[self itemIndexWithIndexPath:indexPath]]
                              LocalOnly:NO
                             completion:^(UIImage *image) {
                                 if (tmpIndexPath.row == cell.tag) {
                                     [tmpImageView setImage: image ? image : [UIImage imageNamed:DefaultImage]];
                                 }
                             }];
        }
    }
    return cell;

}
@end
