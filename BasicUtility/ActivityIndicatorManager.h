//
//  ActivityIndicatorManager.h
//
//  Created by Ted Cheng on 4/1/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define ActivityIndicatorManagerShouldLog
//#define ActivityIndicatorManagerShouldLogDetails

@interface ActivityIndicatorManager : NSObject

+ (void)showIndicatorForActivity:(NSString *) activity;

+ (void)dismissIndicatorForActivity:(NSString *) activity;

+ (void)dismissAllIndicator;

+ (NSMutableArray *)currentActivities;

+ (BOOL)isActivityExist:(NSString *) activity;

@end
