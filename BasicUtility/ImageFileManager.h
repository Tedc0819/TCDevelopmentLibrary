//
//  ImageFileManager.h
//
//  Created by Ted Cheng on 19/11/12.
//  Copyright (c) 2012 Ted Cheng. All rights reserved.
//
 
#import <Foundation/Foundation.h>

#define defaultImageExtension @".jpg"

//#define ImageFileManagerShouldLog
//#define ImageFileManagerShouldLogDetails

@interface ImageFileManager : NSObject

/* 
    These methods with completion as params:
    1. Done on a private queue.
    2. Dispatch the completion on main_queue
    3. images are in jpg formats (TEMP)
*/

+ (void)saveImageData:(NSData *) data WithName:(NSString *) name completion: (void (^)(UIImage *image))completion;

+ (void)removeAllImagesWithcompletion: (void (^)())completion;

+ (void)removeImagesWithFileName:(NSArray *) array Completion:(void (^)())completion;

+ (void)loadImageWithName:(NSString *) name completion: (void (^)(UIImage *image))completion;

+ (BOOL)isImageExistWithName:(NSString *) name;

+ (NSArray *)allFileWithExtension:(NSString *) extenstion;


//WARNiNG: the following methods run on main thread

+ (void)removeAllImages;

+ (void)removeImagesWithFileName:(NSArray *) array;


//debugging methods

+ (void)currentStatus; // log out all the JPGS file in file system

+ (NSMutableDictionary *) imageCacheDict; //A dictionary the map the keys and the image for caching. 

+ (void)clearCache; // should be call on memory warning

@end
