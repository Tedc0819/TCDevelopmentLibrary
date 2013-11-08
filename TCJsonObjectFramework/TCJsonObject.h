//
//  NSJsonObject.h
//  mytvHD
//
//  Created by Ted Cheng on 13/3/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCRequest.h"

#define NSJsonObjectShouldLogRequest

@interface TCJsonObject : NSObject

@property (nonatomic, strong) NSString *objID;
@property (nonatomic, strong) NSDictionary *JSONDict;

//- (NSArray *)descriptionProperties;
//
//- (void)getPropertyValuesFromDictionary:(NSDictionary *)dict;
//- (NSURL *)URLFromString:(NSString *) string;
//- (TCJsonObject *)parsingOwningObjectWithKeyPath:(NSArray *)keyPath AsClass:(NSString *) classStr FromJsonObjectDictionary:(NSDictionary *)dict;
//
////parsing related
//
//+ (id)objectFromDictionary:(NSDictionary *) dict; //parsing one object
//+ (NSArray *)jsonObjectsFromRawArray:(NSArray *)rawArray; //parsing Array of Objects
//- (NSDictionary *)mappingDictionary;

///////////NEW VERSION///////////

//object related
- (id)initWithDictionary:(NSDictionary *)dict;
- (void)saveWithCompletion:(void(^)(void)) completion;
- (void)readWithCompletion:(void(^)(void)) completion;
- (void)updateWithCompletion:(void(^)(void)) completion;
- (void)destoryWithCompletion:(void(^)(void)) completion;

//parsing related
+ (TCJsonObject *)jsonObjectFromDictionary:(NSDictionary *)dict; //parsing single Object
+ (NSArray *)jsonObjectsFromArray:(NSArray *)array; //parsing Array of Objects
+ (NSDictionary *)parsingMap;

//request related

+ (void)createObject:(TCJsonObject *)object WithCompletion:(void(^)(TCJsonObject *object))completion;
+ (void)readObjectByID:(int)ID WithCompletion:(void(^)(TCJsonObject *object))completion;
+ (void)updateObject:(TCJsonObject *)object WithCompletion:(void(^)(TCJsonObject *object))completion;
+ (void)destoryObject:(TCJsonObject *)object WithCompletion:(void(^)(TCJsonObject *object))completion;

+ (void)getObjectsFromURL:(NSURL *)url
           ParsingKeyPath:(NSArray *)keyPath
           WithParamsType:(TCRequestParamsType)paramsType
               WithMethod:(TCRequestMethod)method
               WithParams:(NSDictionary *)params
               Completion:(void (^)(NSArray *objects))completion;

@end

@interface NSDictionary(TCJsonObjectFramework)

- (NSDictionary *)mappedDictionaryWithKeyMap:(NSDictionary *)map;

@end

@interface NSObject(TCJsonObjectFramework)

- (void)setValueFromDictionary:(NSDictionary *)dict shouldOverwrite:(BOOL) shouldOverwrite;

@end
