//
//  UINavigationController+ShowNotice.m
//  myVOD
//
//  Created by Peter Wong on 22/8/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "UINavigationController+ShowNotice.h"

@interface UINavigationController (ShowNoticePrivate)

+ (NSMutableArray *) noticeKeys; // in order to maintain the order of notices
+ (NSMutableDictionary *) notices;
+ (NSMutableDictionary *) noticeTimers;

+ (BOOL) isNoticeExist:(NSString *)tag;

- (void) showLastNotice;

- (void) autoDismissNotice:(NSTimer *)timer;

@end

@implementation UINavigationController (ShowNotice)

#pragma mark - Class properties

+ (NSMutableArray *)noticeKeys {
    static NSMutableArray *_noticeKeys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _noticeKeys = [NSMutableArray array];
    });
    return _noticeKeys;
}

+ (NSMutableDictionary *)notices {
    static NSMutableDictionary *_notices;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _notices = [NSMutableDictionary dictionary];
    });
    return _notices;
}

+ (NSMutableDictionary *)noticeTimers {
    static NSMutableDictionary *_noticeTimers;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _noticeTimers = [NSMutableDictionary dictionary];
    });
    return _noticeTimers;
}

#pragma mark - Notice checking

+ (BOOL)isNoticeExist:(NSString *)tag {
    return [[UINavigationController noticeKeys] containsObject:tag];
}

#pragma mark - Showing notices

- (void)showNoticeWithText:(NSString *)text tag:(NSString *)tag {
    if (![UINavigationController isNoticeExist:tag]) {
        [[UINavigationController noticeKeys] addObject:tag];
        [UINavigationController notices][tag] = text;
    }
    [self showLastNotice];
}
- (void)showNoticeWithText:(NSString *)text Tag:(NSString *)tag {
    [self showNoticeWithText:text tag:tag];
}

- (void)showNoticeWithText:(NSString *)text tag:(NSString *)tag dismissAfter:(float)seconds {
    [self showNoticeWithText:text tag:tag];
    [UINavigationController noticeTimers][tag] = [NSTimer scheduledTimerWithTimeInterval:seconds
                                                                                  target:self selector:@selector(autoDismissNotice:)
                                                                                userInfo:@{ @"tag": tag }
                                                                                 repeats:NO];
}
- (void)showNoticeWithText:(NSString *)text Tag:(NSString *)tag DismissAfter:(float)seconds {
    [self showNoticeWithText:text tag:tag dismissAfter:seconds];
}

- (void)showLastNotice {
    static NSInteger NOTICE_LABEL_TAG = 2222;
    UILabel *noticeLabel = (UILabel *)[self.view viewWithTag:NOTICE_LABEL_TAG];
    
    if (!noticeLabel) {
        noticeLabel = [[UILabel alloc] initWithFrame:(CGRect){0, self.navigationBar.frame.origin.y + self.navigationBar.frame.size.height - 4, self.navigationBar.frame.size.width, 18}];
        [noticeLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [noticeLabel setTag:NOTICE_LABEL_TAG];
        [noticeLabel setTextAlignment:NSTextAlignmentCenter];
        [noticeLabel setTextColor:[UIColor whiteColor]];
        [noticeLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [self.view addSubview:noticeLabel];
    }
    
    if ([[UINavigationController noticeKeys] count] == 0) {
        [UIView animateWithDuration:0.05 animations:^{
            [noticeLabel setAlpha:0];
        }];
    } else {
        [UIView animateWithDuration:0.05 animations:^{
            [noticeLabel setAlpha:1];
            
            NSString *lastKey = (NSString *)[[UINavigationController noticeKeys] lastObject];
            [noticeLabel setText:[UINavigationController notices][lastKey]];
            NSLog(@"last key = %@", lastKey);
        }];
    }
}

#pragma mark - Dismissing notices

- (void)autoDismissNotice:(NSTimer *)timer {
    [self dismissNoticeWithTag:timer.userInfo[@"tag"]];
}

- (void)dismissNoticeWithTag:(NSString *)tag {
    NSTimer *theTimer = (NSTimer *)[UINavigationController noticeTimers][tag];
    [theTimer invalidate];
    [[UINavigationController noticeTimers] removeObjectForKey:tag];
    
    if ([UINavigationController isNoticeExist:tag]) {
        [[UINavigationController noticeKeys] removeObject:tag];
        [[UINavigationController notices] removeObjectForKey:tag];
    }
    
    [self showLastNotice];
}

@end
