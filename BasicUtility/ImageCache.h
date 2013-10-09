//
//  ImageCache.h
//
//  Created by Ted Cheng on 18/3/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageCacheLoadingProtocol;

@interface ImageCache : NSObject

+ (void)loadImageForURL:(NSURL *) url LocalOnly:(BOOL) localOnly completion:(void(^)(UIImage *image))completion;
+ (void)loadImageForURL:(NSURL *) url ToImageView:(UIImageView *)imageView LocalOnly:(BOOL) localOnly completion:(void(^)(UIImage *image))completion;
+ (void)loadImageForView:(UIView<ImageCacheLoadingProtocol> *)view localOnly:(BOOL)localOnly;
@end

@protocol ImageCacheLoadingProtocol <NSObject>

- (NSArray *)lazyLoadingImageViews;
- (NSArray *)lazyLoadingImageURLs;

@end
