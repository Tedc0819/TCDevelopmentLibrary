//
//  ImageCache.h
//
//  Created by Ted Cheng on 18/3/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

+ (void)loadImageForURL:(NSURL *) url LocalOnly:(BOOL) localOnly completion:(void(^)(UIImage *image))completion;



@end
