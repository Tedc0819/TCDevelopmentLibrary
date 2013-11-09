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

//object related
- (id)initWithDictionary:(NSDictionary *)dict;
- (void)parsingDict:(NSDictionary *)dict shouldOverwrite:(BOOL)shouldOberwrite;

- (void)saveWithCompletion:(void(^)(void)) completion;
- (void)readWithCompletion:(void(^)(void)) completion;
- (void)updateWithCompletion:(void(^)(void)) completion;
- (void)destoryWithCompletion:(void(^)(void)) completion;

//parsing related
+ (NSArray *)jsonObjectsFromArray:(NSArray *)array; //parsing Array of Objects
+ (NSDictionary *)parsingMap;
+ (NSDictionary *)hasOneRelationship; //@{ keyInRawDictionary : ClassObObject}
+ (NSDictionary *)hasManyRelationship; // @{ keyInRawDictionary : ClassObObject}

//request related

+ (void)createObject:(TCJsonObject *)object WithCompletion:(void(^)(TCJsonObject *object))completion;
+ (void)readObjectByID:(int)ID WithCompletion:(void(^)(TCJsonObject *object))completion;
+ (void)updateObject:(TCJsonObject *)object WithCompletion:(void(^)(TCJsonObject *object))completion;
+ (void)destoryObject:(TCJsonObject *)object WithCompletion:(void(^)(TCJsonObject *object))completion;

// raw request
+ (void)getObjectsFromURL:(NSURL *)url
           ParsingKeyPath:(NSArray *)keyPath
           WithParamsType:(TCRequestParamsType)paramsType
               WithMethod:(TCRequestMethod)method
               WithParams:(NSDictionary *)params
               Completion:(void (^)(NSArray *objects))completion;

+ (void)getObjectsFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath Completion: (void(^)(NSArray *objects)) completion;

@end

@interface NSDictionary(TCJsonObjectFramework)

- (NSDictionary *)mappedDictionaryWithKeyMap:(NSDictionary *)map;

@end

@interface NSObject(TCJsonObjectFramework)

- (void)setValueFromDictionary:(NSDictionary *)dict shouldOverwrite:(BOOL) shouldOverwrite;

@end
