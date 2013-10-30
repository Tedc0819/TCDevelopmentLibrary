//
//  TCStore.m
//  bokku
//
//  Created by Ted Cheng on 24/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCStore.h"

@interface TCStore()

@property (nonatomic, strong) NSMutableDictionary *storeDict;

@end

@implementation TCStore

- (NSMutableDictionary *)storeDict
{
    if (!_storeDict) {
        _storeDict = [[NSMutableDictionary alloc] init];
    }
    return _storeDict;
}

- (void)storeObject:(id<TCStorable>)storable
{
    [self.storeDict setObject:storable forKey:storable.storableKey];
}

//- (NSDictionary *)loadObjectDictionaryWithKey:(NSString *)key;
//{
//    return [self.storeDict objectForKey:key];
//}

- (id<TCStorable>)objectWithKey:(NSString *)key
{
    return [self.storeDict objectForKey:key];
}

- (void)removeObjectWithKey:(NSString *)key
{
    return [self.storeDict removeObjectForKey:key];
}

- (void)clearAllObject
{
    [self.storeDict removeAllObjects];
}

- (BOOL)isObjectWithKeyExist:(NSString *)key
{
    return [self.storeDict objectForKey:key] ? YES : NO;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"%@: %@\n",self.storeKey, self.storeDict];
    return description;
}

@end
