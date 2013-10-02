//
//  NSJsonObject.h
//  mytvHD
//
//  Created by Ted Cheng on 13/3/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCRequest.h"

//#define NSJsonObjectShouldLogRequest

@interface NSJsonObject : NSObject

@property (nonatomic, strong) NSDictionary *JSONDict;

+ (id)objectFromDictionary:(NSDictionary *) dict;
+ (NSArray *)jsonObjectsFromRawArray:(NSArray *)rawArray;

+ (void)getObjectsFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath WithParamsType:(TCRequestParamsType)paramsType WithMethod:(TCRequestMethod)method WithParams:(NSDictionary *)params Completion:(void (^)(NSArray *objects))completion;
+ (void)getObjectsFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath Completion: (void(^)(NSArray *objects)) completion;
+ (void)getObjectFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath headers:(NSDictionary *)headers Completion: (void(^)(NSJsonObject *object)) completion;
+ (void)getObjectFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath Completion: (void(^)(NSJsonObject *object)) completion;

//+ (void)deleteObjects:(NSArray *)objects ByURL:(NSURL *)url ResultKeyPath:(NSArray *)keyPath Completion:(void(^)(id object)) completion;
//+ (void)updateObject:(NSJsonObject *)object ByURL:(NSURL *)url ResultKeyPath:(NSArray *)keyPath Completion:(void(^)(id object)) completion;
- (NSDictionary *)mappingDictionary;
- (NSArray *)descriptionProperties;

- (void)getPropertyValuesFromDictionary:(NSDictionary *)dict;
- (NSURL *)URLFromString:(NSString *) string;
- (NSJsonObject *)parsingOwningObjectWithKeyPath:(NSArray *)keyPath AsClass:(NSString *) classStr FromJsonObjectDictionary:(NSDictionary *)dict;

@end
