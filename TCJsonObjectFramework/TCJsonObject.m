//
//  NSJsonObject.m
//  mytvHD
//
//  Created by Ted Cheng on 13/3/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCJsonObject.h"
#import "Extension.h"

@implementation TCJsonObject

//+ (id)objectFromDictionary:(NSDictionary *) dict
//{
//    id jsonObj = [[self alloc] init];
//    ((TCJsonObject *)jsonObj).JSONDict = dict;
//    if (jsonObj) {
//        [jsonObj getPropertyValuesFromDictionary:dict];
//    }
//    return jsonObj;
//}
//
//+ (void)getObjectsFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath WithParamsType:(TCRequestParamsType)paramsType WithMethod:(TCRequestMethod)method WithParams:(NSDictionary *)params Completion:(void (^)(NSArray *))completion
//{
//#ifdef NSJsonObjectShouldLogRequest
//    NSLog(@"Request From Server - %@ - START", [self class]);
//#endif
//    [TCRequest requestContent:TCRequestContentTypeDictionary ByMethod:method FromURL:url WithParams:params AsType:paramsType Tag:url.absoluteString Completion:^(id returnObject) {
//        NSDictionary *dict = (NSDictionary *)returnObject;
//        if (!dict) {
//#ifdef NSJsonObjectShouldLogRequest
//            NSLog(@"Request From Server - %@ - Fail - NO Dictionary", [self class]);
//#endif
//            completion(nil);
//            return;
//        }
//        
//        if ([self class] == NSClassFromString(@"LiveEvent")){
////            NSLog(@"NSJsonDict dict = %@", dict);
//        }
//        
//        NSArray *items = [self jsonObjectsFromRawArray:[dict objectWithKeyPath:keyPath]];
//    
//#ifdef NSJsonObjectShouldLogRequest
//        if (items.count == 0) {
//            NSLog(@"Request From Server - %@ - Fail - NO ITEM", [self class]);
//        } else {
//            NSLog(@"Request From Server - %@ - SUCCESS", [self class]);
//        }
//#endif
//        
//        if (completion) completion(items.count == 0 ? nil : items.copy);
//    }];
//}
//
//+ (void)getObjectsFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath Completion: (void(^)(NSArray *objects)) completion
//{
//    [self getObjectsFromURL:url ParsingKeyPath:keyPath WithParamsType:TCRequestParamsTypeVariablePath WithMethod:TCRequestMethodGet WithParams:nil Completion:completion];
//}
//
//+ (void)getObjectFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath headers:(NSDictionary *)headers Completion:(void (^)(TCJsonObject *))completion
//{
//    [TCRequest requestContent:TCRequestContentTypeDictionary ByMethod:TCRequestMethodGet FromURL:url WithParams:nil headers:headers AsType:TCRequestParamsTypeVariablePath Tag:url.absoluteString Completion:^(id returnObject) {
//        NSDictionary *dict = (NSDictionary *)returnObject;
//        if (!dict) {
//#ifdef NSJsonObjectShouldLogRequest
//            NSLog(@"Request From Server - %@ - Fail - NO Dictionary", [self class]);
//#endif
//            completion(nil);
//            return;
//        }
//        
//        NSDictionary *objectDict = [dict dictionaryWithKeyPath:keyPath];
//        
//        TCJsonObject *item = nil;
//        if (objectDict) {
//            item = [[self alloc] init];
//            [item getPropertyValuesFromDictionary:objectDict];
//        }
//        
//#ifdef NSJsonObjectShouldLogRequest
//        if (!item) {
//            NSLog(@"Request From Server - %@ - Fail - NO ITEM", [self class]);
//        } else {
//            NSLog(@"Request From Server - %@ - SUCCESS", [self class]);
//        }
//#endif
//        
//        if (completion) completion(item);
//    }];
//}
//
//+ (void)getObjectFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath Completion: (void(^)(TCJsonObject *object)) completion
//{
//    [self getObjectFromURL:url ParsingKeyPath:keyPath headers:nil Completion:completion];
//}
//
//+ (NSArray *)jsonObjectsFromRawArray:(NSArray *)rawArray
//{
//    if (![rawArray isKindOfClass:[NSArray class]]) return @[];
//    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
//    [rawArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//        TCJsonObject *tmpJSONObj = [[self alloc] init];
//        [tmpJSONObj getPropertyValuesFromDictionary:obj];
//        [mutableArray addObject:tmpJSONObj];
//    }];
//    return mutableArray;
//}
//
//- (void)getPropertyValuesFromDictionary:(NSDictionary *)dict
//{
//    if (![dict isKindOfClass:[NSDictionary class]]) return;
//    self.JSONDict = dict;
//
//    NSMutableDictionary *mutableDict = [dict mutableCopy];
//    NSDictionary *mappings = [self mappingDictionary];
//    [dict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSString *key, id obj, BOOL *stop) {
//        if ([mappings.allKeys containsObject:key]) {
//            if (obj != nil) {
//                NSString *mappedKey = [mappings objectForKey:key];
//                [mutableDict setObject:obj forKey:mappedKey];
//            }
//        }
//    }];
//    
//    [mutableDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        if (obj == [NSNull null]) return;
//        if ([key isEqualToString:@"id"]) key = @"objID";
//        
//        if ([self respondsToSelector:NSSelectorFromString(key)]) {
//            @try {
//                if (![self valueForKey:key]) {
//                    [self setValue:obj forKey:key];
//                }
//            }
//            @catch (NSException *exception) {
//                NSLog(@"NSJsonObject Parsing Exception = %@ Key = %@ Object = %@", exception, key, obj);
//            }
//        };
//    }];
//}
//
//- (TCJsonObject *)parsingOwningObjectWithKeyPath:(NSArray *)keyPath AsClass:(NSString *) classStr FromJsonObjectDictionary:(NSMutableDictionary *)dict;
//{
//    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
//    TCJsonObject *tmpJsonObject;
//    NSDictionary *tmpDict = [dict objectWithKeyPath:keyPath];
//    if (tmpDict) {
//        tmpJsonObject = [(NSClassFromString(classStr)) objectFromDictionary:tmpDict];
//    }
//    return tmpJsonObject;
//}
//
//- (NSURL *)URLFromString:(NSString *) string
//{
//    return ([string respondsToSelector:@selector(length)]) ? [NSURL URLWithString:string] : nil;
//}
//
//- (NSDictionary *)mappingDictionary
//{
//    return @{};
//}
//
//- (NSArray *)descriptionProperties
//{
//    return @[];
//}
//
//- (NSString *)description
//{
//    NSArray *properties = [self descriptionProperties];
//    
//    NSMutableArray *propertyPairs = [NSMutableArray array];
//    [properties enumerateObjectsUsingBlock:^(NSString *property, NSUInteger idx, BOOL *stop) {
//        if ([self respondsToSelector:NSSelectorFromString(property)]) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//            id propertyValue = [self performSelector:NSSelectorFromString(property)];
//#pragma clang diagnostic pop
//            if (!propertyValue) {
//                propertyValue = @"nil";
//            }
//            NSString *pair = [NSString stringWithFormat:@"%@=%@", property, propertyValue];
//            [propertyPairs addObject:pair];
//        }
//    }];
//    
//    if ([propertyPairs count] > 0) {
//        return [NSString stringWithFormat:@"<%@: %@>", [super description], [propertyPairs componentsJoinedByString:@" "]];
//    } else {
//        return [NSString stringWithFormat:@"<%@>", [super description]];
//    }
//}

/////////////////NEW VERSION/////////////

//object related
- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValueFromDictionary:dict shouldOverwrite:YES];
    }
    return self;
}

//parsing related

+ (TCJsonObject *)jsonObjectFromDictionary:(NSDictionary *)dict; //parsing single Object
{
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    NSDictionary *sourceDict = [dict mappedDictionaryWithKeyMap:[self parsingMap]];

    TCJsonObject *jsonObject = [[self alloc] initWithDictionary:sourceDict];
    return jsonObject;
}

+ (NSArray *)jsonObjectsFromArray:(NSArray *)array; //parsing Array of Objects
{
    if (![array isKindOfClass:[NSArray class]]) return @[];
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        TCJsonObject *tmpJSONObj = [[self alloc] initWithDictionary:obj];
        [mutableArray addObject:tmpJSONObj];
    }];
    
    return mutableArray;
}

+ (NSDictionary *)parsingMap
{
    return @{};
}

//request related

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
        
        NSArray *items = [self jsonObjectsFromArray:[dict objectWithKeyPath:keyPath]];
        
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


@end

@implementation NSDictionary(TCJsonObjectFramework)

- (NSDictionary *)mappedDictionaryWithKeyMap:(NSDictionary *)map
{
    NSMutableDictionary *mutableDict = [self mutableCopy];
    [mutableDict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([map.allKeys containsObject:key] && (obj != nil)) {
            NSString *mappedKey = [map objectForKey:key];
            [mutableDict setObject:obj forKey:mappedKey];
        }
    }];
    return mutableDict.copy;
}

@end

@implementation NSObject(TCJsonObjectFramework)

- (void)setValueFromDictionary:(NSDictionary *)dict shouldOverwrite:(BOOL) shouldOverwrite
{
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null]) return;
        if ([key isEqualToString:@"id"]) key = @"objID";
        
        if ([self respondsToSelector:NSSelectorFromString(key)]) {
            @try {
                if (shouldOverwrite || ![self valueForKey:key]) {
                    [self setValue:obj forKey:key];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"NSJsonObject Parsing Exception = %@ Key = %@ Object = %@", exception, key, obj);
            }
        };
    }];
}

@end
