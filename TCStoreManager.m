//
//  TCStoreManager.m
//  bokku
//
//  Created by Ted Cheng on 24/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCStoreManager.h"

@interface TCStoreManager()

@property (nonatomic, strong) NSMutableDictionary *storeDictionary;

@end

@implementation TCStoreManager

+ (TCStoreManager *)sharedManager
{
    static TCStoreManager *_sharedStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [[TCStoreManager alloc] init];
        _sharedStore.storeDictionary = [[NSMutableDictionary alloc] init];
    });
    return _sharedStore;
}

- (NSDictionary *)allStores
{
    return self.storeDictionary.copy;
}

- (TCStore *)storeWithKey:(NSString *)key
{
    TCStore *store = [self.storeDictionary objectForKey:key];
    if (!store) {
        store = [[TCStore alloc] init];
        [self.storeDictionary setObject:store forKey:key];
        store.storeKey = key;
    }
    return store;
}

- (void)clearStoreWithKey:(NSString *)key
{
    TCStore *store = [self storeWithKey:key];
    [store clearAllObject];
    [self.storeDictionary removeObjectForKey:key];
}

- (void)storeObject:(id<TCStorable>)storable ToStoreWithKey:(NSString *)storeKey
{
    TCStore *store = [self storeWithKey:storeKey];
    [store storeObject:storable];
}

- (void)removeObjectWithKey:(NSString *)key ToStoreWithKey:(NSString *)storeKey
{
    TCStore *store = [self storeWithKey:storeKey];
    [store removeObjectWithKey:key];
}

- (id<TCStorable>)objectWithKey:(NSString *)key inStoreWithKey:(NSString *)storeKey
{
    TCStore *store = [self storeWithKey:storeKey];
    return [store objectWithKey:key];
}
- (BOOL)isObjectWithKey:(NSString *)key inStoreWithKey:(NSString *)storeKey
{
    TCStore *store = [self storeWithKey:storeKey];
    return [store isObjectWithKeyExist:key];
}

- (NSString *)description
{
    NSMutableString *description = [NSString stringWithFormat:@"StoreManagerStatus:\nStores:%@\n", self.storeDictionary.allKeys].mutableCopy;
    
    [self.storeDictionary enumerateKeysAndObjectsUsingBlock:^(id key, TCStore *store, BOOL *stop) {
        [description appendString:[store description]];
    }];
    
    return description.copy;
}

@end
