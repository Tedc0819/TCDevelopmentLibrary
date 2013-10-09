//
//  TCJsonObjectTableViewController.h
//  bokku
//
//  Created by Ted Cheng on 3/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCSegmentingManager.h"

@interface TCJsonObjectTableViewController : UITableViewController

//SegmentedControlButtonSetting
@property (nonatomic, strong) TCSegmentingManager *segmentingManager;

- (void)updateImageDownLoadRequest;

- (CGFloat)numberOfButtonDisplay;
- (NSArray *)segmentedControlButtons;
- (BOOL)segmentedControlButtonsShouldShow;
- (NSString *)cellClassStringForJsonObjectClassString:(NSString *)classString;
@end
