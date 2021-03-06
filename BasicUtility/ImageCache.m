//
//  ImageCache.m
//
//  Created by Ted Cheng on 18/3/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "ImageCache.h"
#import "ImageFileManager.h"
#import "Extension.h"
#import "TCRequest.h"

@implementation ImageCache

+ (NSMutableDictionary *)currentProcessRecord
{
    static NSMutableDictionary *_currentProcessRecord;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentProcessRecord = [[NSMutableDictionary alloc] init];
    });
    return _currentProcessRecord;
}

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

+ (void)loadImageForURL:(NSURL *) url ToImageView:(UIImageView *)imageView LocalOnly:(BOOL) localOnly completion:(void(^)(UIImage *image))completion
{
    NSString *imageViewIDString = @(imageView.hash).stringValue;
    [[ImageCache currentProcessRecord] setValue:url.absoluteString forKey:imageViewIDString];
    [ImageCache loadImageForURL:url LocalOnly:localOnly completion:^(UIImage *image) {
        if ([[ImageCache currentProcessRecord][imageViewIDString] isEqualToString:url.absoluteString]) {
            if (image) {
                [imageView setImage:image];
            }
            [[ImageCache currentProcessRecord]removeObjectForKey:imageViewIDString];
        }
        completion(image);
    }];
}

+ (void)loadImageForView:(UIView<ImageCacheLoadingProtocol> *)view localOnly:(BOOL)localOnly
{
    [view.lazyLoadingImageViews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        [ImageCache loadImageForURL:view.lazyLoadingImageURLs[idx] ToImageView:imageView LocalOnly:localOnly completion:^(UIImage *image) {}];
    }];
}

@end
