//
//  TCStoreManager.h
//  bokku
//
//  Created by Ted Cheng on 24/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCStore.h"

@interface TCStoreManager : NSObject

+ (TCStoreManager *)sharedManager;
- (NSDictionary *)allStores;
- (TCStore *)storeWithKey:(NSString *)key; //if a store doesn't exist, it will be auto created
- (void)clearStoreWithKey:(NSString *)key;

- (void)storeObject:(id<TCStorable>)storable ToStoreWithKey:(NSString *)storeKey;
- (void)removeObjectWithKey:(NSString *)key ToStoreWithKey:(NSString *)storeKey;
- (id<TCStorable>)objectWithKey:(NSString *)key inStoreWithKey:(NSString *)storeKey;

@end
