//
//  EFMACROS.h
//  
//
//  Created by Johan Kool on 28/9/2013.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

#ifndef EFMACROS_h
#define EFMACROS_h

/*
 *  Sanity Check Preprocessor Macros
 */

#define NIL_IF_NULL(foo)                                (([foo isKindOfClass:[NSNull class]]) ? nil : foo)
#define NIL_IF_NOT_CLASS(className, foo)                (([foo isKindOfClass:[className class]]) ? (className *)foo : nil)
#define DEFAULT_IF_NULL(foo, default)                   ((foo == nil || [foo isKindOfClass:[NSNull class]]) ? default : foo)
#define DEFAULT_IF_NOT_CLASS(className, foo, default)   (([foo isKindOfClass:[className class]]) ? (className *)foo : default)
#define NULL_IF_NIL(foo)                                ((foo == nil) ? [NSNull null] : foo)
#define EMPTY_STRING_IF_NIL(foo)                        ((foo == nil) ? @"" : foo)

/*
 *  Equality Preprocessor Macros
 */

#define FLOAT_EQUAL(a, b)                               (fabs((a) - (b)) < FLT_EPSILON)
#define FLOAT_EQUAL_ZERO(a)                             (fabs(a) < FLT_EPSILON)

/*
 *  Color Preprocessor Macros
 */

#define UICOLOR_FROM_RGB(rgbValue)                      [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                                        green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                                         blue:((float)(rgbValue & 0xFF))/255.0 \
                                                                        alpha:1.0]
#define UICOLOR_FROM_RGBA(rgbValue, a)                  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                                        green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                                         blue:((float)(rgbValue & 0xFF))/255.0 \
                                                                        alpha:a]

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)         ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif
