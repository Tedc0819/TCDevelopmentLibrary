//
//  Extenstion.m
//
//  Created by Ted Cheng on 12/3/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
///

#import "Extension.h"
#import "ImageFileManager.h"

#define IndicatorTag 1111

@implementation UIImageView(AsyncLoadImageFromWebSupport)

- (void)showLoadingIndicator
{
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self viewWithTag:IndicatorTag];
    if (!indicator) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        [indicator setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
        [indicator startAnimating];
        [indicator setTag:IndicatorTag];
        [self addSubview:indicator];
    }
    [indicator setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
    [indicator setHidden:NO];
    [indicator startAnimating];
}

- (void)hideLoadingIndicator
{
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self viewWithTag:IndicatorTag];
    [indicator stopAnimating];
    [indicator setHidden:YES];
}
@end

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)MD5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, strlen(cstr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

- (NSString *)sha1EncryptionValue
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSString *)URLEncodeString {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end

@implementation NSNumber(frontEnd)

- (NSString *)hmsString
{
    int totalSeconds = self.intValue;
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

@end

@implementation NSDate (frontEnd)

- (NSString *)diplayDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];    
    return [formatter stringFromDate:self];
}

@end

@implementation UIButton (setBackgroundColorForState)

- (void) setBackgroundColor:(UIColor *) backgroundColor forState:(UIControlState) state {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(3, 3), NO, [UIScreen mainScreen].scale);
    UIBezierPath* p = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 3, 3)];
    [backgroundColor setFill];
    [p fill];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    [self setBackgroundImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)] forState:state];
}

@end

@implementation NSArray (selfCheckingSupport)

- (BOOL)onlyContainClass:(NSString *) className
{
    __block BOOL result = YES;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(className)]) result = NO;
    }];
    return result;
}

- (NSArray *)objectsOfKindOfClassName:(NSString *) className
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(className)]) [result addObject:obj];
    }];
    return result;
}

@end

@implementation NSArray(KeyPathSupport)

- (id)objectWithKeyPath:(NSArray *)keys
{
    if (!keys || keys.count == 0)  return nil;
    id returnObj = nil;
    NSNumber *tmpKey = keys[0];
    keys = [keys subarrayWithRange:NSMakeRange(1, keys.count - 1)];
    if (![tmpKey isKindOfClass:[NSNumber class]]) return returnObj;
    
    id tmpObj = nil;
    @try {
        tmpObj = self[tmpKey.intValue];
    }
    @catch (NSException *exception) {
    }
    
    if (keys.count) {
        id tmpContainer = tmpObj;
        if ([tmpContainer isKindOfClass:[NSDictionary class]] || [tmpContainer isKindOfClass:[NSArray class]]) {
            returnObj = [tmpContainer objectWithKeyPath:keys];
        }
    } else {
        returnObj = tmpObj;
    }
    
    return returnObj;
}

- (id)dictionaryWithKeyPath:(NSArray *)keys
{
    id object = [self objectWithKeyPath:keys];
    return [object isKindOfClass:[NSDictionary class]] ? object : nil;
}

- (id)arrayWithKeyPath:(NSArray *)keys
{
    id object = [self objectWithKeyPath:keys];
    return [object isKindOfClass:[NSArray class]] ? object : nil;
}

@end

@implementation NSDictionary(KeyPathSupport)

- (id)objectWithKeyPath:(NSArray *)keys
{
    if (!keys || keys.count == 0)  return nil;
    id returnObj = nil;
    
    id tmpKey = keys[0];
    keys = [keys subarrayWithRange:NSMakeRange(1, keys.count - 1)];
    
    id tmpObj = self[tmpKey];
    if (keys.count) {
        id tmpContainer = tmpObj;
        if ([tmpContainer isKindOfClass:[NSDictionary class]] || [tmpContainer isKindOfClass:[NSArray class]]) {
            returnObj = [tmpContainer objectWithKeyPath:keys];
        }
    } else {
        returnObj = tmpObj;
    }
    return returnObj;
}

- (id)dictionaryWithKeyPath:(NSArray *)keys
{
    id object = [self objectWithKeyPath:keys];
    return [object isKindOfClass:[NSDictionary class]] ? object : nil;
}

- (id)arrayWithKeyPath:(NSArray *)keys
{
    id object = [self objectWithKeyPath:keys];
    return [object isKindOfClass:[NSArray class]] ? object : nil;
}

@end

//@implementation NSMutableDictionary(KeyPathSupport)
//
//- (void)deleteObjectWithKeyPath:(NSArray *)keys
//{
//    if (!keys || keys.count == 0)  return;    
//    id lastKey = [keys lastObject];
//    keys = [keys subarrayWithRange:NSMakeRange(0, keys.count - 1)];
//    
//    id tmpObj;
//    if (keys.count) {
//        tmpObj = [self objectWithKeyPath:keys];
//        NSLog(@"tmpObj = %@",tmpObj);
//    } else {
//        tmpObj = self;
//    }
//        if (!tmpObj) return;
//        if ([tmpObj isKindOfClass:[NSDictionary class]]) {
//            tmpObj = ((NSDictionary *)tmpObj).mutableCopy;
//            [tmpObj removeObjectForKey:lastKey];
//            tmpObj = ((NSMutableDictionary *)tmpObj).copy;
//        }
//        if ([tmpObj isKindOfClass:[NSArray class]]) {
//            if (![lastKey isKindOfClass:[NSNumber class]]) return;
//            tmpObj = ((NSArray *)tmpObj).mutableCopy;
//            [tmpObj removeObjectAtIndex:((NSNumber *)lastKey).intValue];
//            tmpObj = ((NSMutableArray *)tmpObj).copy;
//        }
//
//}
//
//@end



@implementation UITableViewController(LazyLoadingSupport)

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self updataImageDownLoadRequest];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (!decelerate) {
//        [self updataImageDownLoadRequest];
//    }
//}
//
//- (NSURL *)tableview:(UITableView *)tableview imageURLAtIndexPath:(NSIndexPath *)indexPath
//{
//    return nil;
//}
//
//- (void)updataImageDownLoadRequest
//{
//    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
//    
//    NSMutableArray *mutablePaths = [NSMutableArray arrayWithArray:visiblePaths];
//    //    NSIndexPath *minPath = [visiblePaths objectAtIndex:0];
//    //    NSIndexPath *maxPath = [visiblePaths lastObject];
//    //    for (int i = 1 ; i <= 2 ; i ++ ){
//    //        [mutablePaths addObject:[NSIndexPath indexPathForRow:minPath.row - i inSection:minPath.section]];
//    //        [mutablePaths addObject:[NSIndexPath indexPathForRow:maxPath.row + i inSection:maxPath.section]];
//    //    }
//    
//    for (NSIndexPath *indexPath in mutablePaths)
//    {
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        [ImageCache loadImageForURL:[self tableview:self.tableView imageURLAtIndexPath:indexPath]
//                          LocalOnly:NO
//                         completion:^(UIImage *image) {
//                             [cell.imageView setImage: image ? image : [UIImage imageNamed:DefaultImage]];
//        }];
//    }
//}
//

@end

