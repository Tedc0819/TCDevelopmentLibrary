//
//  NSJsonObject.m
//  mytvHD
//
//  Created by Ted Cheng on 13/3/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "NSJsonObject.h"

@implementation NSJsonObject

+ (id)objectFromDictionary:(NSDictionary *) dict
{
    id jsonObj = [[self alloc] init];
    ((NSJsonObject *)jsonObj).JSONDict = dict;
    if (jsonObj) {
        [jsonObj getPropertyValuesFromDictionary:dict];
    }
    return jsonObj;
}

+ (void)getObjectsFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath WithParamsType:(TCRequestParamsType)paramsType WithMethod:(TCRequestMethod)method WithParams:(NSDictionary *)params Completion:(void (^)(NSArray *))completion
{
#ifdef NSJsonObjectShouldLogRequest
    NSLog(@"Request From Server - %@ - START", [self class]);
#endif
    [TCRequest requestContent:TCRequestContentTypeDictionary ByMethod:method FromURL:url WithParams:params AsType:paramsType Tag:url.absoluteString Completion:^(id returnObject) {
        NSDictionary *dict = (NSDictionary *)returnObject;
        if (!dict) {
#ifdef NSJsonObjectShouldLogRequest
            NSLog(@"Request From Server - %@ - Fail - NO Dictionary", [self class]);
#endif
            completion(nil);
            return;
        }
        
        if ([self class] == NSClassFromString(@"LiveEvent")){
//            NSLog(@"NSJsonDict dict = %@", dict);
        }
        
        NSArray *items = [self jsonObjectsFromRawArray:[dict objectWithKeyPath:keyPath]];
    
#ifdef NSJsonObjectShouldLogRequest
        if (items.count == 0) {
            NSLog(@"Request From Server - %@ - Fail - NO ITEM", [self class]);
        } else {
            NSLog(@"Request From Server - %@ - SUCCESS", [self class]);
        }
#endif
        
        if (completion) completion(items.count == 0 ? nil : items.copy);
    }];
}

+ (void)getObjectsFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath Completion: (void(^)(NSArray *objects)) completion
{
    [self getObjectsFromURL:url ParsingKeyPath:keyPath WithParamsType:TCRequestParamsTypeVariablePath WithMethod:TCRequestMethodGet WithParams:nil Completion:completion];
}

+ (void)getObjectFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath headers:(NSDictionary *)headers Completion:(void (^)(NSJsonObject *))completion
{
    [TCRequest requestContent:TCRequestContentTypeDictionary ByMethod:TCRequestMethodGet FromURL:url WithParams:nil headers:headers AsType:TCRequestParamsTypeVariablePath Tag:url.absoluteString Completion:^(id returnObject) {
        NSDictionary *dict = (NSDictionary *)returnObject;
        if (!dict) {
#ifdef NSJsonObjectShouldLogRequest
            NSLog(@"Request From Server - %@ - Fail - NO Dictionary", [self class]);
#endif
            completion(nil);
            return;
        }
        
        NSDictionary *objectDict = [dict dictionaryWithKeyPath:keyPath];
        
        NSJsonObject *item = nil;
        if (objectDict) {
            item = [[self alloc] init];
            [item getPropertyValuesFromDictionary:objectDict];
        }
        
#ifdef NSJsonObjectShouldLogRequest
        if (!item) {
            NSLog(@"Request From Server - %@ - Fail - NO ITEM", [self class]);
        } else {
            NSLog(@"Request From Server - %@ - SUCCESS", [self class]);
        }
#endif
        
        if (completion) completion(item);
    }];
}

+ (void)getObjectFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath Completion: (void(^)(NSJsonObject *object)) completion
{
    [self getObjectFromURL:url ParsingKeyPath:keyPath headers:nil Completion:completion];
}

+ (NSArray *)jsonObjectsFromRawArray:(NSArray *)rawArray
{
    if (![rawArray isKindOfClass:[NSArray class]]) return @[];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [rawArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        NSJsonObject *tmpJSONObj = [[self alloc] init];
        [tmpJSONObj getPropertyValuesFromDictionary:obj];
        [mutableArray addObject:tmpJSONObj];
    }];
    return mutableArray;
}

- (void)getPropertyValuesFromDictionary:(NSDictionary *)dict
{
    if (![dict isKindOfClass:[NSDictionary class]]) return;
    self.JSONDict = dict;

    NSMutableDictionary *mutableDict = [dict mutableCopy];
    NSDictionary *mappings = [self mappingDictionary];
    [dict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([mappings.allKeys containsObject:key]) {
            if (obj != nil) {
                NSString *mappedKey = [mappings objectForKey:key];
                [mutableDict setObject:obj forKey:mappedKey];
            }
        }
    }];
    
    [mutableDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null]) return;
        if ([key isEqualToString:@"id"]) key = @"objID";
        
        if ([self respondsToSelector:NSSelectorFromString(key)]) {
            @try {
                if (![self valueForKey:key]) {
                    [self setValue:obj forKey:key];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"NSJsonObject Parsing Exception = %@ Key = %@ Object = %@", exception, key, obj);
            }
        };
    }];
}

- (NSJsonObject *)parsingOwningObjectWithKeyPath:(NSArray *)keyPath AsClass:(NSString *) classStr FromJsonObjectDictionary:(NSMutableDictionary *)dict;
{
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    NSJsonObject *tmpJsonObject;
    NSDictionary *tmpDict = [dict objectWithKeyPath:keyPath];
    if (tmpDict) {
        tmpJsonObject = [(NSClassFromString(classStr)) objectFromDictionary:tmpDict];
    }
    return tmpJsonObject;
}

- (NSURL *)URLFromString:(NSString *) string
{
    return ([string respondsToSelector:@selector(length)]) ? [NSURL URLWithString:string] : nil;
}

- (NSDictionary *)mappingDictionary
{
    return @{};
}

- (NSArray *)descriptionProperties
{
    return @[];
}

- (NSString *)description
{
    NSArray *properties = [self descriptionProperties];
    
    NSMutableArray *propertyPairs = [NSMutableArray array];
    [properties enumerateObjectsUsingBlock:^(NSString *property, NSUInteger idx, BOOL *stop) {
        if ([self respondsToSelector:NSSelectorFromString(property)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id propertyValue = [self performSelector:NSSelectorFromString(property)];
#pragma clang diagnostic pop
            if (!propertyValue) {
                propertyValue = @"nil";
            }
            NSString *pair = [NSString stringWithFormat:@"%@=%@", property, propertyValue];
            [propertyPairs addObject:pair];
        }
    }];
    
    if ([propertyPairs count] > 0) {
        return [NSString stringWithFormat:@"<%@: %@>", [super description], [propertyPairs componentsJoinedByString:@" "]];
    } else {
        return [NSString stringWithFormat:@"<%@>", [super description]];
    }
}

@end
