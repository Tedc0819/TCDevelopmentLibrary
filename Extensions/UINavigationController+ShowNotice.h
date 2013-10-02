//
//  UINavigationController+ShowNotice.h
//
//  Created by Peter Wong on 22/8/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ShowNotice)

- (void) showNoticeWithText:(NSString *)text tag:(NSString *)tag;
- (void) showNoticeWithText:(NSString *)text Tag:(NSString *)tag;

- (void) showNoticeWithText:(NSString *)text tag:(NSString *)tag dismissAfter:(float)seconds;
- (void) showNoticeWithText:(NSString *)text Tag:(NSString *)tag DismissAfter:(float)seconds;

- (void) dismissNoticeWithTag:(NSString *)tag;

@end
