//
//  TCJsonObjectTableViewCell.h
//  TCJsonRESTFrameworkExample
//
//  Created by Ted Cheng on 8/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCJsonObject.h"
#import "ImageCache.h"

@interface TCJsonObjectTableViewCell : UITableViewCell<ImageCacheLoadingProtocol>

@property (nonatomic, weak) TCJsonObject *jsonObject;

- (void)setToDefaultView;
- (void)updateWithJsonObject:(TCJsonObject *)jsonObject;

//please also implement the ImageCacheLoadingProtocol

@end
