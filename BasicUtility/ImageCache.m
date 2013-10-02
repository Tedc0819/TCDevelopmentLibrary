//
//  ImageCache.m
//  mytvHD
//
//  Created by Ted Cheng on 18/3/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "ImageCache.h"
#import "ImageFileManager.h"
#import "Extension.h"
#import "TCRequest.h"

@implementation ImageCache

+ (void)loadImageForURL:(NSURL *) url LocalOnly:(BOOL) localOnly completion:(void(^)(UIImage *image))completion
{
    if ((!url) || ([url class] != [NSURL class])){
        completion (nil);
        return;
    }
    
    NSString *key = url.absoluteString.MD5String;
    
    UIImage *image = [ImageFileManager imageCacheDict][key];
    if (image){
        if (completion) completion(image);
    } else {
        if ([ImageFileManager isImageExistWithName:key]) {
            [ImageFileManager loadImageWithName:key completion:completion];
        } else {
            if (!localOnly) {
                [TCRequest requestContent:TCRequestContentTypeData ByMethod:TCRequestMethodGet FromURL:url WithParams:nil AsType:TCRequestParamsTypeVariablePath Tag:url.absoluteString Completion:^(id returnObject) {
                    [ImageFileManager saveImageData:returnObject WithName:key completion:^(UIImage *image) {
                        [ImageFileManager loadImageWithName:key completion:completion];
                    }];
                }];
            }else {
                completion(nil);
            }
            
        }
    }
}

@end
