//
//  TCStore.h
//  bokku
//
//  Created by Ted Cheng on 24/10/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TCStoreTypeCache,
    TCStoreTypeSession
} TCStoreType;

@protocol TCStorable <NSObject>

- (NSString *)storableKey; // suggested: (CLASS)_(IDENTIFIER)
- (NSDictionary *)storableContentDictionary; // suggested: @{ @"ClassName" : @"(CLASS)", ... }

@optional // a standard interface, convenience only

- (void)cacheStorable;

@end

@interface TCStore : NSObject

@property (nonatomic, assign) TCStoreType *storeType;
@property (nonatomic, strong) NSString *storeKey;

- (void)storeObject:(id<TCStorable>)storable;
//- (NSDictionary *)loadObjectDictionaryWithKey:(NSString *)key;
- (id<TCStorable>)objectWithKey:(NSString *)key;
- (void)removeObjectWithKey:(NSString *)key;
- (void)clearAllObject;
- (BOOL)isObjectWithKeyExist:(NSString *)key;

@end
