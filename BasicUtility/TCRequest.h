//
//  TCRequest.h
//
//  Created by Ted Cheng on 13/8/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

//#define TCRequestShouldLog
//#define TCRequestShouldLogDetails

#import <Foundation/Foundation.h>

typedef enum {
    TCRequestMethodGet,
    TCRequestMethodPost,
    TCRequestMethodDelete,
    TCRequestMethodPut
} TCRequestMethod;

typedef enum {
    TCRequestParamsTypeVariablePath,
    TCRequestParamsTypeForm,
    TCRequestParamsTypeJSON
} TCRequestParamsType;

typedef enum {
    TCRequestContentTypeData,
    TCRequestContentTypeDictionary,
    TCRequestContentTypeArray
}TCRequestContentType;

@interface TCRequest : NSObject

+ (TCRequest *)requestContent:(TCRequestContentType)content
                     ByMethod:(TCRequestMethod) method
                      FromURL:(NSURL *)url
                   WithParams:(NSDictionary *)params
                      headers:(NSDictionary *)headers
                       AsType:(TCRequestParamsType)type
                          Tag:(NSString *)tag
                   Completion:(void (^)(id returnObject))completion;
+ (TCRequest *)requestContent:(TCRequestContentType)content
                     ByMethod:(TCRequestMethod) method
                      FromURL:(NSURL *)url
                   WithParams:(NSDictionary *)params
                       AsType:(TCRequestParamsType)type
                          Tag:(NSString *)tag
                   Completion:(void (^)(id returnObject))completion;
+ (void)cancelRequestWithTag:(NSString *) tag;
+ (void)cancelAllRequests;

@end
