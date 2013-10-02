//
//  UIColor+colorWithHex.h
//
//  Created by Peter Wong on 24/9/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (colorWithHex)

// hexValue should be in the following format:
//   #a1b2c3
+ (UIColor *) colorWithHex:(NSString *)hexValue alpha:(float)alpha;

@end
