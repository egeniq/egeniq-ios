//
//  EFNibView.m
//  iPortfolio
//
//  Created by Ivo Jansch on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EFNibViewController.h"


@implementation EFNibViewController

@synthesize view;

- (id) initWithNibName: (NSString *)nibName {
    self = [super init];
    NSArray* nibViews =  [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];

    // Assumes the UIView in the nib is the first object we encounter. Is this always the case?
    view = [nibViews objectAtIndex: 0];
    
    return self;
    
}

- (void) dealloc {

    [view release];
    [super dealloc];

}


@end
