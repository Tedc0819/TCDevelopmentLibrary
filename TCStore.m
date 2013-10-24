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

- (void)storeObject:(id<TCStorable>)storable
{
    [self.storeDict setObject:storable.storableContentDictionary forKey:storable.storableKey];
}

- (NSDictionary *)loadObjectDictionaryWithKey:(NSString *)key;
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

@end
