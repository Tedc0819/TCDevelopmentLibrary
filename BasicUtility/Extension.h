//
//  Extenstion.h
//  mytvHD
//
//  Created by Ted Cheng on 12/3/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

- (NSString *)MD5String;

- (NSString *)sha1EncryptionValue;

- (NSString *)URLEncodeString;

@end

#import "UINavigationController+ShowNotice.h"
#import "NSString+Encryption.h"
#import "UIView+FindViewsByClass.h"
#import "UIColor+colorWithHex.h"

@interface NSNumber (frontEnd)

- (NSString *) hmsString;

@end

@interface NSDate (frontEnd)

- (NSString *)diplayDate;

@end
@interface UIButton (setBackgroundColorForState)

- (void) setBackgroundColor:(UIColor *) backgroundColor forState:(UIControlState) state;

@end

@interface UITableViewController(LazyLoadingSupport)

//- (NSURL *)tableview:(UITableView *) tableview imageURLAtIndexPath:(NSIndexPath *) indexPath;
//
//- (void)updataImageDownLoadRequest;

@end

@interface NSArray (selfCheckingSupport)

- (BOOL)onlyContainClass:(NSString *) className;

- (NSArray *)objectsOfKindOfClassName:(NSString *) className;

@end

@interface NSArray(KeyPathSupport)

- (id)objectWithKeyPath:(NSArray *)keys;
- (id)dictionaryWithKeyPath:(NSArray *)keys;
- (id)arrayWithKeyPath:(NSArray *)keys;

@end

@interface NSDictionary(KeyPathSupport)

- (id)objectWithKeyPath:(NSArray *)keys;
- (id)dictionaryWithKeyPath:(NSArray *)keys;
- (id)arrayWithKeyPath:(NSArray *)keys;

@end
