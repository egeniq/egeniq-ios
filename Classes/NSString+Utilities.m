//
//  NSString+Utilities.m
//  Egeniq
//
//  Created by Johan Kool on 18/4/2012.
//  Copyright (c) 2012 Egeniq. All rights reserved.
//

#import "NSString+Utilities.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Utilities)

+ (NSString *)randomStringOfLength:(NSUInteger)length {
    srandom([[NSDate date] timeIntervalSince1970]);
    
    char randoms[length+1];
    int i = 0;
    char aRandom = 0;
    for (i = 0; i < length; i++) {
        while (YES) {
            aRandom = (char)random() + 128;
            if (((aRandom >= '0') && (aRandom <= '9')) || ((aRandom >= 'a') && (aRandom <= 'z'))) {
                randoms[i] = aRandom;
                break; // we found an alphanumeric character, move on
            }
        }
    }
    randoms[length] = '\0';
    
    return [NSString stringWithUTF8String:(const char*)randoms];
}

- (NSString *)md5Hash {
    unsigned char hashedChars[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self UTF8String],
            [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], 
            hashedChars);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", hashedChars[i]];
    }
    return output;
}

- (NSString *)sha1Hash {
    unsigned char hashedChars[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([self UTF8String],
            [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], 
            hashedChars);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", hashedChars[i]];
    }
    return output; 
}

// Method based on code obtained from:
// http://www.thinkmac.co.uk/blog/2005/05/removing-entities-from-html-in-cocoa.html
//

- (NSString *)decodeHTMLCharacterEntities {
    if ([self rangeOfString:@"&"].location == NSNotFound) {
        return self;
    } else {
        NSMutableString *escaped = [NSMutableString stringWithString:self];
        NSArray *codes = [NSArray arrayWithObjects:
                          @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", @"&brvbar;",
                          @"&sect;", @"&uml;", @"&copy;", @"&ordf;", @"&laquo;", @"&not;", @"&shy;", @"&reg;",
                          @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", @"&sup3;", @"&acute;", @"&micro;",
                          @"&para;", @"&middot;", @"&cedil;", @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;",
                          @"&frac12;", @"&frac34;", @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;",
                          @"&Atilde;", @"&Auml;", @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;",
                          @"&Eacute;", @"&Ecirc;", @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;",
                          @"&ETH;", @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;",
                          @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", @"&Yacute;",
                          @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", @"&atilde;", @"&auml;",
                          @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", @"&eacute;", @"&ecirc;", @"&euml;",
                          @"&igrave;", @"&iacute;", @"&icirc;", @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;",
                          @"&oacute;", @"&ocirc;", @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;",
                          @"&uacute;", @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;", nil];
        
        NSUInteger i, count = [codes count];
        
        // Html
        for (i = 0; i < count; i++) {
            NSRange range = [self rangeOfString:[codes objectAtIndex:i]];
            if (range.location != NSNotFound) {
                [escaped replaceOccurrencesOfString:[codes objectAtIndex:i]
                                         withString:[NSString stringWithFormat:@"%C", 160 + i]
                                            options:NSLiteralSearch
                                              range:NSMakeRange(0, [escaped length])];
            }
        }
        
        // The following five are not in the 160+ range
        
        // @"&amp;"
        NSRange range = [self rangeOfString:@"&amp;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&amp;"
                                     withString:[NSString stringWithFormat:@"%C", 38]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&lt;"
        range = [self rangeOfString:@"&lt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&lt;"
                                     withString:[NSString stringWithFormat:@"%C", 60]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&gt;"
        range = [self rangeOfString:@"&gt;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&gt;"
                                     withString:[NSString stringWithFormat:@"%C", 62]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&apos;"
        range = [self rangeOfString:@"&apos;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&apos;"
                                     withString:[NSString stringWithFormat:@"%C", 39]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // @"&quot;"
        range = [self rangeOfString:@"&quot;"];
        if (range.location != NSNotFound) {
            [escaped replaceOccurrencesOfString:@"&quot;"
                                     withString:[NSString stringWithFormat:@"%C", 34]
                                        options:NSLiteralSearch
                                          range:NSMakeRange(0, [escaped length])];
        }
        
        // Decimal & Hex
        NSRange start, finish, searchRange = NSMakeRange(0, [escaped length]);
        i = 0;
        
        while (i < [escaped length]) {
            start = [escaped rangeOfString:@"&#"
                                   options:NSCaseInsensitiveSearch
                                     range:searchRange];
            
            finish = [escaped rangeOfString:@";"
                                    options:NSCaseInsensitiveSearch
                                      range:searchRange];
            
            if (start.location != NSNotFound && finish.location != NSNotFound &&
                finish.location > start.location) {
                NSRange entityRange = NSMakeRange(start.location, (finish.location - start.location) + 1);
                NSString *entity = [escaped substringWithRange:entityRange];
                NSString *value = [entity substringWithRange:NSMakeRange(2, [entity length] - 2)];
                
                [escaped deleteCharactersInRange:entityRange];
                
                if ([value hasPrefix:@"x"]) {
                    unsigned tempInt = 0;
                    NSScanner *scanner = [NSScanner scannerWithString:[value substringFromIndex:1]];
                    [scanner scanHexInt:&tempInt];
                    [escaped insertString:[NSString stringWithFormat:@"%C", tempInt] atIndex:entityRange.location];
                } else {
                    [escaped insertString:[NSString stringWithFormat:@"%C", [value intValue]] atIndex:entityRange.location];
                } i = start.location;
            } else { i++; }
            searchRange = NSMakeRange(i, [escaped length] - i);
        }
        
        return escaped;    // Note this is autoreleased
    }
}

- (NSString *)encodeHTMLCharacterEntities {
    NSMutableString *encoded = [NSMutableString stringWithString:self];
    
    // @"&amp;"
    NSRange range = [self rangeOfString:@"&"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"&"
                                 withString:@"&amp;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    // @"&lt;"
    range = [self rangeOfString:@"<"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@"<"
                                 withString:@"&lt;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    // @"&gt;"
    range = [self rangeOfString:@">"];
    if (range.location != NSNotFound) {
        [encoded replaceOccurrencesOfString:@">"
                                 withString:@"&gt;"
                                    options:NSLiteralSearch
                                      range:NSMakeRange(0, [encoded length])];
    }
    
    return encoded;
}

- (NSString *)luceneEscapedString {
    // + - && || ! ( ) { } [ ] ^ " ~ * ? : \
    
    NSArray *characters = [NSArray arrayWithObjects:@"\\", @"+", @"-", @"&&", @"||", @"!", @"(", @")", @"{", @"}", @"[", @"]", @"^" @"\"", @"~", @"*", @"?", @":", nil];
    NSMutableString *escapedString = [self mutableCopy];
    for (NSString *character in characters) {
        [escapedString replaceOccurrencesOfString:character withString:[@"\\" stringByAppendingString:character] options:0 range:NSMakeRange(0, [escapedString length])];
    }
    
    return [escapedString autorelease];
}
  

@end
