//
//  TCNoticeManager.m
//
//  Created by Ted Cheng on 23/8/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCNoticeManager.h"
#import "TCNoticeView.h"
#import "TCNavigationBarBannerNoticeView.h"

@implementation TCNoticeManager

+ (TCNoticeManager *)sharedManager
{
    static TCNoticeManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[TCNoticeManager alloc] init];
    });
    return _sharedManager;
}


- (NSMutableDictionary *)noticeTypeDictionary
{
    static NSMutableDictionary *_noticeTypeDict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _noticeTypeDict = [[NSMutableDictionary alloc] init];
    });
    return _noticeTypeDict;
}


- (void)showNoticeWithText:(NSString *)text Tag:(NSString *) tag Type:(TCNoticeType) type
{
    if ([self isNoticeExist:tag]) return;
    TCNotice *notice = [[TCNotice alloc] init];
    notice.tag = tag;
    notice.text = text;
    notice.type = type;
    [self addNotice:notice];
    [self showLastestNoticeWithType:type];
}

- (void)showNoticeWithText:(NSString *)text Tag:(NSString *) tag Type:(TCNoticeType) type DismissAfter:(float) second
{
    [self showNoticeWithText:text Tag:tag Type:type];
    TCNotice *notice =  [self noticeDictionary][tag];
    notice.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:second
                                                           target:self
                                                         selector:@selector(autoDismiss:)
                                                         userInfo:@{@"notice" :  notice}
                                                          repeats:NO];
}

- (void)autoDismiss:(NSTimer *)timer
{
    TCNotice *notice = timer.userInfo[@"notice"];
    [self dismissNoticeWithTag:notice.tag];
}

- (void)dismissNoticeWithTag:(NSString *) tag
{
    [self removeNoticeWithTag:tag];
    
    TCNotice *notice = [self noticeDictionary][tag];
    [self showLastestNoticeWithType:notice.type];
}

- (void)showLastestNoticeWithType:(TCNoticeType)type
{
    NSArray *notices = [self noticesWithType:type];
    TCNoticeView *noticeView = [self noticeViewWithType:type];
    
    if (!notices.count) {
        [noticeView dismiss];
    } else {
        [noticeView showNotice:notices.lastObject];
    }
}

- (NSString *)noticeIdentifierWithType:(TCNoticeType)type
{
    return [self noticeViewClassStringWithType:type];
}

- (void)refreshNoticeWithType:(TCNoticeType)type
{
    [self showLastestNoticeWithType:type];
}

#pragma mark - notice view related

- (NSMutableDictionary *)noticeViewDictionary
{
    static NSMutableDictionary *_noticeViewDict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _noticeViewDict = [[NSMutableDictionary alloc] init];
    });
    return _noticeViewDict;
}

- (TCNoticeView *)noticeViewWithType:(TCNoticeType)type
{
    NSString *noticeIdentifier = [self noticeIdentifierWithType:type];
    
    TCNoticeView *noticeView = [self noticeViewDictionary][noticeIdentifier];
    if (!noticeView || ![noticeView isKindOfClass:[TCNoticeView class]]) {
        NSString *classString = [self noticeViewClassStringWithType:type];
        noticeView = [[NSClassFromString(classString) alloc] init];
        [[self noticeViewDictionary] setValue:noticeView forKey:noticeIdentifier];
        UIViewController *viewCon = [[[[UIApplication sharedApplication]delegate] window] rootViewController];
        [viewCon.view addSubview:noticeView];
    }
    return noticeView;
}

- (NSString *)noticeViewClassStringWithType:(TCNoticeType)type
{
    if (type==TCNoticeTypeNavigationBarBanner) return @"TCNavigationBarBannerNoticeView";
    if (type==TCNoticeTypeNavigationBarBannerWarning) return @"TCNavigationBarBannerNoticeView";
    return @"TCNoticeView";
}

#pragma mark - notice related

- (NSMutableDictionary *)noticeDictionary
{
    static NSMutableDictionary *_noticeDict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _noticeDict = [[NSMutableDictionary alloc] init];
    });
    return _noticeDict;
}

- (TCNotice *)noticeWithTag:(NSString *)tag
{
    return [self noticeDictionary][tag];
}

- (NSArray *)noticesWithType:(TCNoticeType)type //Public method
{
    NSString *noticeIdentifier = [self noticeIdentifierWithType:type];
    return ((NSArray *)[self noticeTypeDictionary][noticeIdentifier]).copy;
}

- (NSMutableArray *)noticesArrayWithType:(TCNoticeType)type //Private Method for managing
{
    NSString *noticeIdentifier = [self noticeIdentifierWithType:type];
    
    NSMutableArray *tmpArray = [self noticeTypeDictionary][noticeIdentifier];
    if (!tmpArray || ![tmpArray isKindOfClass:[NSMutableArray class]]) {
        tmpArray = [[NSMutableArray alloc] init];
        [[self noticeTypeDictionary]setValue:tmpArray forKey:noticeIdentifier];
    }
    return tmpArray;
}

- (BOOL)isNoticeExist:(NSString *) tag
{
    return [self noticeDictionary][tag] ? YES : NO;
}

- (void)addNotice:(TCNotice *)notice
{
    if ([self isNoticeExist:notice.tag]) return;
    
    [[self noticeDictionary]setValue:notice forKey:notice.tag];
    
    NSMutableArray *tmpArray = [self noticesArrayWithType:notice.type];
    [tmpArray addObject:notice];
    [self logStatus];
}

- (void)removeNoticeWithTag:(NSString *)tag
{
    if (![self isNoticeExist:tag]) return;
    TCNotice *notice = [self noticeDictionary][tag];
    
    NSString *noticeIdentifier = [self noticeIdentifierWithType:notice.type];
    
    [[self noticeDictionary] removeObjectForKey:notice.tag];
    
    NSMutableArray *tmpArray = [self noticeTypeDictionary][noticeIdentifier];
    [tmpArray removeObject:notice];
    [self logStatus];
}


- (void)logStatus
{
//    NSLog(@"notice Dict = %@\n\n\n noticeType Dict = %@",[self noticeDictionary], [self noticeTypeDictionary]);
}

@end
