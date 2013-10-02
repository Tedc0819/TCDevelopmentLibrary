//
//  URLImageViewListCell.h

//
//  Created by Ted Cheng on 22/7/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCURLImageViewListAdapter.h"
#import "TCHorizontalTableView.h"

#define SmallBannerCellHeight 70

extern NSString *const SmallBannerCellIdentifier;

@interface URLImageViewListCell : UITableViewCell

@property (nonatomic, strong) TCHorizontalTableView *imageViewtableView;
@property (nonatomic, strong) TCURLImageViewListAdapter *imageViewtableViewAdapter;

@end
