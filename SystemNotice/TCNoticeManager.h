//
//  TCNoticeManager.h
//  mytvHD
//
//  Created by Ted Cheng on 23/8/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCNotice;

typedef enum {
    TCNoticeTypeNavigationBarBanner,
    TCNoticeTypeNavigationBarBannerWarning
} TCNoticeType;

@interface TCNoticeManager : NSObject

+ (TCNoticeManager *)sharedManager;
- (void)showNoticeWithText:(NSString *)text Tag:(NSString *) tag Type:(TCNoticeType) type;
- (void)showNoticeWithText:(NSString *)text Tag:(NSString *) tag Type:(TCNoticeType) type DismissAfter:(float) second;
- (void)dismissNoticeWithTag:(NSString *) tag;
- (BOOL)isNoticeExist:(NSString *) tag;
- (void)refreshNoticeWithType:(TCNoticeType)type;
- (TCNotice *)noticeWithTag:(NSString *)tag;

@end
