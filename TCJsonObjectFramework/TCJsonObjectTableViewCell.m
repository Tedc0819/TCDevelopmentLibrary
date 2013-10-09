//
//  TCJsonObjectTableViewCell.m
//  TCJsonRESTFrameworkExample
//
//  Created by Ted Cheng on 8/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCJsonObjectTableViewCell.h"

@implementation TCJsonObjectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setToDefaultView
{

}

- (void)updateWithJsonObject:(TCJsonObject *)jsonObject
{
    
}

- (NSArray *)lazyLoadingImageViews
{
    return @[];
}

- (NSArray *)lazyLoadingImageURLs
{
    return @[];
}

@end
