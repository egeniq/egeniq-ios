//
//  NSString+Utilities.h
//  Egeniq
//
//  Created by Johan Kool on 18/4/2012.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utilities)

+ (NSString *)randomStringOfLength:(NSUInteger)length;

- (NSString *)md5Hash;
- (NSString *)sha1Hash;

- (NSString *)decodeHTMLCharacterEntities;
- (NSString *)encodeHTMLCharacterEntities;

- (NSString *)luceneEscapedString;

@end
