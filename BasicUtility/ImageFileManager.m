//
//  ImageFileManager.m
//
//  Created by Ted Cheng on 19/11/12.
//  Copyright (c) 2012 Ted Cheng. All rights reserved.
//

#import "ImageFileManager.h"

static NSMutableDictionary *_imageCacheDict;
static dispatch_queue_t _imageFileManagerQueue;
static NSString *_documentationDirectory;
static NSArray *_dirContents;

@implementation ImageFileManager

+ (dispatch_queue_t)ImageFileManagerQueue
{
    if (!_imageFileManagerQueue) {
        _imageFileManagerQueue = dispatch_queue_create("com.imageFileManager.fileQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _imageFileManagerQueue;
}

+ (NSMutableDictionary *) imageCacheDict
{
    if (!_imageCacheDict) {
        _imageCacheDict = [[NSMutableDictionary alloc] init];
    }
    return _imageCacheDict;
}

+ (void)clearCache
{
    dispatch_async([self ImageFileManagerQueue], ^{
        [[self imageCacheDict] removeAllObjects];
#ifdef ImageFileManagerShouldLog
        NSLog(@"*** ImageFileManager - Cache Clear");
#endif
    });
}

+ (NSString *)documentationDirectory
{
    if (!_documentationDirectory) {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);         _documentationDirectory = [paths objectAtIndex:0];
    }
    return _documentationDirectory;
}

+ (NSArray *)dirContents
{
    if (!_dirContents) {
        _dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self documentationDirectory] error:nil];
    }
    return _dirContents;
}

+ (void)dirContentsNeedUpdate
{
    _dirContents = nil;
}

#pragma method editing the storage

+ (void)saveImageData:(NSData *) data WithName:(NSString *) name completion: (void (^)(UIImage *image))completion;
{
//    [self currentStatus];

    dispatch_async([self ImageFileManagerQueue], ^{
        
        UIImage *tmpImage = [UIImage imageWithData:data];
        
        if (tmpImage.size.height != 0 && tmpImage.size.width != 0) {
            
            NSData *imageData = data;
            
            NSString *fullPath = [[self documentationDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", name, defaultImageExtension]]; 
            
            BOOL success = [[NSFileManager defaultManager] createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)

            [self dirContentsNeedUpdate];
      
#ifdef ImageFileManagerShouldLog
            NSLog(@"*** ImageFileManager - Image Saved - %@",  name);
#endif
            
#ifdef ImageFileManagerShouldLogDetails
            [self currentStatus];
#endif
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion((success ? tmpImage : nil));
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(nil);
            });
        }
        
    });
}

+ (void)removeAllImagesWithcompletion:(void (^)())completion
{    
    NSArray *onlyImages = [self allFileWithExtension:defaultImageExtension];
    [self removeImagesWithFileName:onlyImages Completion:completion];

}

+ (void)removeImagesWithFileName:(NSArray *) array Completion:(void (^)())completion
{
    [self clearCache];
    dispatch_async([self ImageFileManagerQueue], ^{
        [self removeImagesWithFileName:array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion();
        });
    });
}

//WARNiNG: the following methods run on main thread

+ (void)removeAllImages
{
    NSArray *onlyImages = [self allFileWithExtension:defaultImageExtension];
    [self removeImagesWithFileName:onlyImages];
}

+ (void)removeImagesWithFileName:(NSArray *)array
{
    [self clearCache];
        
    NSString *fullPath;
    
    NSError *error;
    for (NSString *str in array) {
        fullPath = [[self documentationDirectory] stringByAppendingPathComponent:str];
        error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
        
#ifdef ImageFileManagerShouldLog
        if (error) NSLog(@"*** ImageFileManager - Image Removal - Error - %@",  error);
        else NSLog(@"*** ImageFileManager - Image Removal - %@",  str);
#endif
    }

    [self dirContentsNeedUpdate];
    
#ifdef ImageFileManagerShouldLogDetails
    [self currentStatus];
#endif

}


+ (void)loadImageWithName:(NSString *) name completion: (void (^)(UIImage *image))completion
{
    dispatch_async([self ImageFileManagerQueue], ^{
        
        NSString *fullPath = [[self documentationDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", name, defaultImageExtension]];
        
        __block UIImage *tmpImage = [UIImage imageWithContentsOfFile:fullPath];
        
        if (tmpImage) [[self imageCacheDict] setObject:tmpImage forKey:name];
        
#ifdef ImageFileManagerShouldLog
        NSLog(@"*** ImageFileManager - Image Load - %@",  name);
#endif
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(tmpImage);
            tmpImage = nil;
        });
    });
}

+ (BOOL) isImageExistWithName:(NSString *) name
{
    return [[self dirContents] containsObject:[NSString stringWithFormat:@"%@%@",name,defaultImageExtension]];
}


+ (void)currentStatus
{
    NSString *tmp = [NSString stringWithFormat:@"self ENDSWITH '%@'", defaultImageExtension];
    NSArray *onlyImages = [[self dirContents] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:tmp]];
#ifdef ImageFileManagerShouldLog    
    NSLog(@"*** ImageFileManager ***\n\n ===== Folder Current Status===== \n"
          @"All Images Files = %@\n", onlyImages);
#endif    
}

+ (NSArray *)allFileWithExtension:(NSString *) extenstion
{
    NSArray *filteredFiles = [[self dirContents] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH %@",extenstion]];
    return filteredFiles;
}

@end
