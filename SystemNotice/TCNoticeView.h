//
//  TCNoticeView.h
//  mytvHD
//
//  Created by Ted Cheng on 23/8/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCNotice.h"

@interface TCNoticeView : UIView

+ (void)sharedNoticeView;

- (void)showNotice:(TCNotice *)notice;
- (void)dismiss;
- (void)updateNotice:(TCNotice *)notice;

@end
