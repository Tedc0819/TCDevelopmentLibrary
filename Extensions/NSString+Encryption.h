//
//  NSString+Encryption.h
//
//  Created by Peter Wong on 22/8/13.
//  Copyright (c) 2013 Ted Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encryption)

- (NSString *) MD5String;

- (NSString *) sha1EncryptionValue;

- (NSString *) URLEncodeString;

@end
