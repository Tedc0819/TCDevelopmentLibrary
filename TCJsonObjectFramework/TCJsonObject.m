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

//object related
- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        [self parseDict:dict shouldOverwrite:YES];
    }
    return self;
}

- (void)parseDict:(NSDictionary *)dict shouldOverwrite:(BOOL)shouldOverwrite;
{
    if (![dict isKindOfClass:[NSDictionary class]]) return;
    NSDictionary *sourceDict = [dict mappedDictionaryWithKeyMap:[self.class parsingMap]];
    NSDictionary *finalDict = [self dictionaryAfterParsedOwingObjectFromDictionary:sourceDict];
    [self setValueFromDictionary:finalDict shouldOverwrite:YES];
}

- (NSDictionary *)serializedDictionary
{
    return @{};
}

- (NSDictionary *)dictionaryAfterParsedOwingObjectFromDictionary:(NSDictionary *)sourceDict
{
    //parsing has one relationship
    NSMutableDictionary *dict = sourceDict.mutableCopy;
    
    NSDictionary *hasOneRelationship = [self.class hasOneRelationship].copy;
    [hasOneRelationship enumerateKeysAndObjectsUsingBlock:^(id key, NSString *classStr, BOOL *stop) {
        if ([dict[key] isKindOfClass:[NSDictionary class]]) {
            //parsing
            if ([NSClassFromString(classStr) isSubclassOfClass:[TCJsonObject class]]) {
                TCJsonObject *object = [[NSClassFromString(classStr) alloc] initWithDictionary:dict[key]];
                [dict setValue:object forKey:key];
            }
        }
    }];

    NSDictionary *hasManyRelationship = [self.class hasManyRelationship].copy;
    [hasManyRelationship enumerateKeysAndObjectsUsingBlock:^(id key, NSString *classStr, BOOL *stop) {
        if ([dict[key] isKindOfClass:[NSArray class]]) {
            //parsing
            if ([NSClassFromString(classStr) isSubclassOfClass:[TCJsonObject class]]) {
                NSArray *objects = [NSClassFromString(classStr) jsonObjectsFromArray:dict[key]];
                [dict setValue:objects forKey:key];
            }
        }
    }];
    
    return dict.copy;
}

//parsing related
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

+ (NSDictionary *)hasOneRelationship
{
    return @{};
}

+ (NSDictionary *)hasManyRelationship
{
    return @{};
}

//request related
+ (void)createObject:(TCJsonObject *)object WithCompletion:(void(^)(BOOL result, NSString *error,TCJsonObject *object))completion
{
//returning Dictionary should be like this
//    @{ @"result" : YES/NO,
//       @"error"  : @"error msg",
//       singleResourceName : @"TCJsonObject"
//    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ResourcesHostPath, [self puralResourceString]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSDictionary *params = object.serializedDictionary;
    NSDictionary *header = @{};
    NSString *tag = [NSString stringWithFormat:@"%@_Create_%lu", [self singleResourceString], (unsigned long)object.hash];
    
    [TCRequest requestContent:TCRequestContentTypeDictionary
                     ByMethod:TCRequestMethodPost
                      FromURL:url
                   WithParams:params
                      headers:header
                       AsType:TCRequestParamsTypeForm
                          Tag:tag
                   Completion:^(id returnObject) {
                       TCJsonObject *object = [[self alloc] initWithDictionary:returnObject[[self singleResourceString]]];
                       completion(((NSNumber *)returnObject[@"result"]).boolValue,returnObject[@"error"],object);
                   }];
}

+ (void)readObjectByID:(NSString *)ID WithCompletion:(void(^)(TCJsonObject *object))completion
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/%@",ResourcesHostPath, [self puralResourceString],ID];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self getObjectFromURL:url
             ParsingKeyPath:@[[self singleResourceString]]
                 Completion:^(TCJsonObject *object) {
                     completion(object);
                 }
    ];
}

+ (void)updateObject:(TCJsonObject *)object WithCompletion:(void(^)(TCJsonObject *object))completion
{
    //returning Dictionary should be like this
    //    @{ @"result" : YES/NO,
    //       @"error"  : @"error msg",
    //       singleResourceName : @"TCJsonObject"
    //    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ResourcesHostPath, [self puralResourceString]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSDictionary *params = object.serializedDictionary;
    NSDictionary *header = @{};
    NSString *tag = [NSString stringWithFormat:@"%@_Update_%lu", [self singleResourceString], (unsigned long)object.hash];
    
    [TCRequest requestContent:TCRequestContentTypeDictionary
                     ByMethod:TCRequestMethodPut
                      FromURL:url
                   WithParams:params
                      headers:header
                       AsType:TCRequestParamsTypeForm
                          Tag:tag
                   Completion:^(id returnObject) {
                       NSLog(@"returnObject = %@", returnObject);
                   }];
}

+ (void)destoryObject:(TCJsonObject *)object WithCompletion:(void(^)(TCJsonObject *object))completion
{
    //returning Dictionary should be like this
    //    @{ @"result" : YES/NO,
    //       @"error"  : @"error msg",
    //       singleResourceName : @"TCJsonObject"
    //    }
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ResourcesHostPath, [self puralResourceString]];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSDictionary *params = object.serializedDictionary;
//    NSDictionary *header = @{};
//    NSString *tag = [NSString stringWithFormat:@"%@_Create_%lu", [self singleResourceString], (unsigned long)object.hash];
//    
//    [TCRequest requestContent:TCRequestContentTypeDictionary
//                     ByMethod:TCRequestMethodDelete
//                      FromURL:url
//                   WithParams:params
//                      headers:header
//                       AsType:TCRequestParamsTypeForm
//                          Tag:tag
//                   Completion:^(id returnObject) {
//                       NSLog(@"returnObject = %@", returnObject);
//                   }];
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

+ (void)getObjectsFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath Completion: (void(^)(NSArray *objects)) completion
{
    [self getObjectsFromURL:url ParsingKeyPath:keyPath WithParamsType:TCRequestParamsTypeVariablePath WithMethod:TCRequestMethodGet WithParams:nil Completion:completion];
}

+ (void)getObjectFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath WithParamsType:(TCRequestParamsType)paramsType WithMethod:(TCRequestMethod)method WithParams:(NSDictionary *)params Completion:(void (^)(TCJsonObject *object))completion
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
        
        TCJsonObject *object = [[self alloc] initWithDictionary:dict];
        
#ifdef NSJsonObjectShouldLogRequest
        if (!object) {
            NSLog(@"Request From Server - %@ - Fail - NO ITEM", [self class]);
        } else {
            NSLog(@"Request From Server - %@ - SUCCESS", [self class]);
        }
#endif
        completion(object);
    }];
}

+ (void)getObjectFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath Completion: (void(^)(TCJsonObject *object)) completion
{
    [self getObjectFromURL:url ParsingKeyPath:keyPath WithParamsType:TCRequestParamsTypeVariablePath WithMethod:TCRequestMethodGet WithParams:nil Completion:completion];
}

#pragma mark - others

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

@implementation NSDictionary(TCJsonObjectFramework)

- (NSDictionary *)mappedDictionaryWithKeyMap:(NSDictionary *)map
{
    NSMutableDictionary *mutableDict = [self mutableCopy];
    [self enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSString *key, id obj, BOOL *stop) {
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
