//
//  UIColor+colorWithHex.m
//
//  Created by Peter Wong on 24/9/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import "UIColor+colorWithHex.h"

@implementation UIColor (colorWithHex)

+ (UIColor *)colorWithHex:(NSString *)hexValue alpha:(float)alpha
{
    unsigned rgb = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexValue];
    if ([hexValue characterAtIndex:0] == '#') {
        [scanner setScanLocation:1];
    }
    [scanner scanHexInt:&rgb];
    return [UIColor colorWithRed:((rgb & 0xFF0000) >> 16)/255.0
                           green:((rgb & 0xFF00) >> 8)/255.0
                            blue:(rgb & 0xFF)/255.0
                           alpha:alpha];
}

@end
