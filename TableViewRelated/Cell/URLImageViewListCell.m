//
//  URLImageViewListCell.m
//  myVOD
//
//  Created by Ted Cheng on 22/7/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "URLImageViewListCell.h"

NSString *const SmallBannerCellIdentifier = @"SmallBannerCellIdentifier";

@implementation URLImageViewListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imageViewtableView = [[TCHorizontalTableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.imageViewtableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [self.imageViewtableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.imageViewtableView setBackgroundColor:[UIColor blackColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.imageViewtableViewAdapter = [[TCURLImageViewListAdapter alloc] init];
        [self.imageViewtableViewAdapter handleTableView:self.imageViewtableView];
        
        [self.contentView addSubview:self.imageViewtableView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
