//
//  Extenstion.h
//
//  Created by Ted Cheng on 12/3/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define iPad    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define iOS7 (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


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
