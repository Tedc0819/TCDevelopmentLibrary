//
//  ActivityIndicatorManager.m
//  TVBZone
//
//  Created by Ted Cheng on 4/1/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "ActivityIndicatorManager.h"

@implementation ActivityIndicatorManager

+ (NSMutableArray *) currentActivities
{
    static NSMutableArray *_activities;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _activities = [[NSMutableArray alloc] init];
    });
    return _activities;
}

+ (void)showIndicatorForActivity:(NSString *)activity
{
#ifdef ActivityIndicatorManagerShouldLog
    NSLog(@"*** ActivityIndicatorManager - SHOW - %@", activity);
#endif
    
    @synchronized(self) {
        if (![self isActivityExist:activity]) {
            [[self currentActivities] addObject:activity];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }

#ifdef ActivityIndicatorManagerShouldLogDetails
    NSLog(@"*** ActivityIndicatorManager - CURRENT - %@", [self currentActivities]);
#endif
    
}

+ (void)dismissIndicatorForActivity:(NSString *)activity
{
#ifdef ActivityIndicatorManagerShouldLog
    NSLog(@"*** ActivityIndicatorManager - DISMISS - %@", activity);
#endif
    
    @synchronized(self) {
        if ([self isActivityExist:activity]) {
            [[self currentActivities] removeObject:activity];
        }
        
        if ([[self currentActivities] count] == 0) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
    
#ifdef ActivityIndicatorManagerShouldLogDetails
    NSLog(@"*** ActivityIndicatorManager - CURRENT - %@", [self currentActivities]);
#endif    
}


+ (void)dismissAllIndicator
{
#ifdef ActivityIndicatorManagerShouldLog
    NSLog(@"*** ActivityIndicatorManager - DISMISS - ALL");
#endif
    
    [[self currentActivities] removeAllObjects];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
#ifdef ActivityIndicatorManagerShouldLogDetails
    NSLog(@"*** ActivityIndicatorManager - CURRENT - %@", [self currentActivities]);
#endif
}

+ (BOOL)isActivityExist:(NSString *)activity
{
    return [[self currentActivities] containsObject:activity];
}

@end
