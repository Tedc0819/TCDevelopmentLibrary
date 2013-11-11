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

//must fill in

+ (NSString *)singleResourceString;
+ (NSString *)puralResourceString;
+ (NSDictionary *)parsingMap;
+ (NSDictionary *)hasOneRelationship; //@{ keyInRawDictionary : ClassObObject}
+ (NSDictionary *)hasManyRelationship; // @{ keyInRawDictionary : ClassObObject}

//object related
- (id)initWithDictionary:(NSDictionary *)dict;
- (void)parseDict:(NSDictionary *)dict shouldOverwrite:(BOOL)shouldOverwrite;

- (void)saveWithCompletion:(void(^)(void)) completion;
- (void)readWithCompletion:(void(^)(void)) completion;
- (void)updateWithCompletion:(void(^)(void)) completion;
- (void)destoryWithCompletion:(void(^)(void)) completion;
- (NSDictionary *)serializedDictionary;

//parsing related
+ (NSArray *)jsonObjectsFromArray:(NSArray *)array; //parsing Array of Objects


//request related
+ (void)createObject:(TCJsonObject *)object
      WithCompletion:(void(^)(BOOL result, NSString *error,TCJsonObject *object))completion;
+ (void)readObjectByID:(NSString *)ID WithCompletion:(void(^)(TCJsonObject *object))completion;
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

+ (void)getObjectFromURL:(NSURL *)url
          ParsingKeyPath:(NSArray *)keyPath
          WithParamsType:(TCRequestParamsType)paramsType
              WithMethod:(TCRequestMethod)method
              WithParams:(NSDictionary *)params
              Completion:(void (^)(TCJsonObject *object))completion;

+ (void)getObjectFromURL:(NSURL *)url ParsingKeyPath:(NSArray *)keyPath Completion: (void(^)(TCJsonObject *object)) completion;

@end

@interface NSDictionary(TCJsonObjectFramework)

- (NSDictionary *)mappedDictionaryWithKeyMap:(NSDictionary *)map;

@end

@interface NSObject(TCJsonObjectFramework)

- (void)setValueFromDictionary:(NSDictionary *)dict shouldOverwrite:(BOOL) shouldOverwrite;

@end
