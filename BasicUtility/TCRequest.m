//
//  TCRequest.m
//
//  Created by Ted Cheng on 13/8/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "TCRequest.h"
#import "ActivityIndicatorManager.h"

#define kRequestTimeOut 60

static NSArray *_httpMethodArray;

@interface TCRequest()<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) TCRequestMethod httpMethod;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *headers;
@property (copy, nonatomic) void (^completionHandler) (id);
@property (nonatomic, assign) TCRequestContentType contentType;
@property (nonatomic, assign) TCRequestParamsType paramsType;
@property (nonatomic, strong) NSString *tag;

- (NSString *)paramsToFormData:(id)params commonKey:(NSString *)commonKey;

@end

@implementation TCRequest

+ (NSString *)httpMethodWithMethod:(TCRequestMethod) method
{
    if (!_httpMethodArray) {
        _httpMethodArray = @[@"GET",@"POST",@"DELETE",@"PUT"];
    }
    return _httpMethodArray[method];
}

+ (NSMutableDictionary *)requestDictionary
{
    static NSMutableDictionary *_requestDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestDictionary = [[NSMutableDictionary alloc] init];
    });
    return _requestDictionary;
}

+ (void)cancelRequestWithTag:(NSString *) tag
{
    [((TCRequest *)[TCRequest requestDictionary][tag])cancelDownload];
}

+ (void)cancelAllRequests
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[TCRequest requestDictionary] enumerateKeysAndObjectsUsingBlock:^(id key, TCRequest *request, BOOL *stop) {
            [request cancelDownload];
        }];
    });
}

+ (TCRequest *)requestContent:(TCRequestContentType)content
                     ByMethod:(TCRequestMethod)method
                      FromURL:(NSURL *)url
                   WithParams:(NSDictionary *)params
                      headers:(NSDictionary *)headers
                       AsType:(TCRequestParamsType)type
                          Tag:(NSString *)tag
                   Completion:(void (^)(id))completion
{
    if (!tag) tag = [TCRequest uuidString];
    if ([TCRequest requestDictionary][tag]) return nil;
    
    TCRequest *request = [[TCRequest alloc] init];
    request.url = url;
    request.completionHandler = completion;
    request.httpMethod = method;
    request.contentType = content;
    request.paramsType = type;
    request.tag = tag;
    request.params = params;
    request.headers = headers;
    
    [[TCRequest requestDictionary] setValue:request forKey:tag];
    [request startDownload];
    
#ifdef TCRequestShouldLogDetails
    NSLog(@"*** TCRequest - Current - %@", [TCRequest requestDictionary]);
#endif
    
    return request;
}

+ (TCRequest *)requestContent:(TCRequestContentType)content
                     ByMethod:(TCRequestMethod) method
                      FromURL:(NSURL *)url
                   WithParams:(NSDictionary *)params
                       AsType:(TCRequestParamsType)type
                          Tag:(NSString *)tag
                   Completion:(void (^)(id returnObject))completion
{
    return [self requestContent:content ByMethod:method FromURL:url WithParams:params headers:nil AsType:type Tag:tag Completion:completion];
}

- (void)startDownload
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    [request setHTTPMethod:[TCRequest httpMethodWithMethod:self.httpMethod]];
    
    if (self.contentType == TCRequestParamsTypeVariablePath && self.params) {
        NSString *tmpURLString = [NSString stringWithFormat:@"%@?%@",self.url.absoluteString, [self variableString]];
        self.url = [NSURL URLWithString:tmpURLString];
    }
    
    if (self.paramsType == TCRequestParamsTypeJSON) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        NSData *requestData = [self dataForJSONRequest];
        [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:requestData];
    }
    
    if (self.paramsType == TCRequestParamsTypeForm) {
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        NSData *requestData = [self dataForFormRequest];
        [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:requestData];
    }
    
    if (self.headers) {
        [self.headers enumerateKeysAndObjectsUsingBlock:^(NSString *headerField, NSString *headerValue, BOOL *stop) {
            [request addValue:headerValue forHTTPHeaderField:headerField];
        }];
    }
    
    [request setTimeoutInterval:kRequestTimeOut];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancelDownload
{
    [self.connection cancel];
    [[TCRequest requestDictionary] removeObjectForKey:self.tag];
    [ActivityIndicatorManager dismissIndicatorForActivity:self.tag];
    self.completionHandler(nil);
    
#ifdef TCRequestShouldLog
    NSLog(@"*** TCRequest - Request With Tag %@ - CANCEL", self.tag);
#endif
    
#ifdef TCRequestShouldLogDetails
    NSLog(@"*** TCRequest - Current - %@", [TCRequest requestDictionary]);
#endif
}

#pragma NSData delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
#ifdef TCRequestShouldLog
    NSLog(@"*** TCRequest - Request With Tag %@ - ERROR - %@", self.tag ,error);
#endif
    [self cancelDownload];
    self.completionHandler(nil);
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData
{
    if (self.data == nil)
        self.data = [[NSMutableData alloc] init];
    [self.data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    [[TCRequest requestDictionary] removeObjectForKey:self.tag];
    [ActivityIndicatorManager dismissIndicatorForActivity:self.tag];
#ifdef TCRequestShouldLog
    NSLog(@"*** TCRequest - Request With Tag %@ - DONE", self.tag);
#endif
    
#ifdef TCRequestShouldLogDetails
    NSLog(@"*** TCRequest - Current - %@", [TCRequest requestDictionary]);
#endif
    
#ifdef TCRequestShouldLog
    if (self.data==nil) NSLog(@"*** TCRequest - Request With Tag %@ - RECEIVE NO DATA", self.tag);
#endif
    
    if (self.contentType == TCRequestContentTypeData) {
        self.completionHandler(self.data);
    } else {
        id result;
        NSException *parsingException;
        @try {
            result = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:nil];
        }
        @catch (NSException *exception) {
            NSLog(@"DataDownload - parsing JSON - Tag:%@ Exception:%@ ",self.tag ,exception);
            parsingException = exception;
        }
        if (parsingException) {
            if (self.completionHandler) self.completionHandler(nil);
            return ;
        }
        
        if (self.contentType == TCRequestContentTypeDictionary) {
            if (self.completionHandler) self.completionHandler([result isKindOfClass:[NSDictionary class]] ? result : nil);
        }
        if (self.contentType == TCRequestContentTypeArray) {
            if (self.completionHandler) self.completionHandler([result isKindOfClass:[NSArray class]] ? result : nil);
        }
    }
    
}

#pragma  mark - helper method

- (NSString *)variableString
{
    __block NSMutableString *tmpRequestString = [[NSMutableString alloc] init];
    [self.params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        if (tmpRequestString.length > 0) [tmpRequestString appendString:@"&"];
        [tmpRequestString appendString:[NSString stringWithFormat:@"%@=%@",key, obj]];
    }];
    return tmpRequestString;
}

- (NSData *)dataForJSONRequest
{
    __block NSMutableString *tmpJsonRequest = [[NSMutableString alloc] init];
    [self.params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        if (tmpJsonRequest.length > 0) [tmpJsonRequest appendString:@","];
        [tmpJsonRequest appendString:[NSString stringWithFormat:@"\"%@\":\"%@\"",key, obj]];
    }];
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{%@}",tmpJsonRequest];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    return requestData;
}

- (NSData *)dataForFormRequest
{
    NSString *data = [self paramsToFormData:self.params commonKey:@""];
    return [data dataUsingEncoding:NSUTF8StringEncoding];
    
//    __block NSMutableString *tmpRequestString = [[NSMutableString alloc] init];
//    [self.params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
//        if (tmpRequestString.length > 0) [tmpRequestString appendString:@"&"];
//        [tmpRequestString appendString:[NSString stringWithFormat:@"%@=%@",key, obj]];
//    }];
//    NSData *requestData = [tmpRequestString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    return requestData;
}

- (NSString *)paramsToFormData:(id)params commonKey:(NSString *)commonKey
{
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)params;
        NSMutableArray *parts = [NSMutableArray array];

        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *newCommonKey;
            if ([commonKey length] == 0) {
                newCommonKey = [NSString stringWithFormat:@"%@", [key URLEncodeString]];
            } else {
                newCommonKey = [NSString stringWithFormat:@"%@[%@]", commonKey, [key URLEncodeString]];
            }
            NSString *part = [self paramsToFormData:obj commonKey:newCommonKey];
            [parts addObject:part];
        }];

        return [parts componentsJoinedByString:@"&"];
    } else if ([params isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)params;
        NSMutableArray *parts = [NSMutableArray array];

        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *newCommonKey = [NSString stringWithFormat:@"%@[%d]", commonKey, idx];
            NSString *part = [self paramsToFormData:obj commonKey:newCommonKey];
            [parts addObject:part];
        }];
        
        return [parts componentsJoinedByString:@"&"];
    } else {
        return [NSString stringWithFormat:@"%@=%@", commonKey, [[params description] URLEncodeString]];
    }
}

+ (NSString *)uuidString {
    // Returns a UUID
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidStr;
}


@end
