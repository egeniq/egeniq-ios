//
//  EFError.h
//  Egeniq
//
//  Useful common error messages that are used by the library but may also used by
//  applications that deal with errors that are application specific but still very
//  common (e.g. 'backend api not available').
// 
//  Modeled after NSError practices and the way cocoa does it in NSError. All
//  constants defined here can be used with NSError.
//
//  Ranges start with a minimum and end with a maximum error number; this makes
//  it possible to check if an error is in a certain range and this one of 
//  the errors in a certain set. It also reserves an error range for use 
//  in the components. 
// 
//  Created by Ivo Jansch on 8/17/11.
//  Copyright 2011 Egeniq. All rights reserved.
//

extern NSString *const EFErrorDomain;

typedef enum {
    
    EFErrorMinimum=0,
    
    // Generic errors
    EFUnknownError=0,
    EFInvalidParametersError=1,
     
    EFRequestErrorMinimum=100,
    EFRequestErrorMaximum=199,
    
    EFKeyChainErrorMinimum=200,
    EFKeyChainErrorMaximum=299,
    
    EFErrorMaximum = INT_MAX
    
} EFError;
