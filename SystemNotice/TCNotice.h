//
//  TCNotice.h
//
//  Created by Ted Cheng on 23/8/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCNoticeManager.h"

@interface TCNotice : NSObject

@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) TCNoticeType type;
@property (nonatomic, weak) NSTimer *dismissTimer;

@end
