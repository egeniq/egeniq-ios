//
//  EFDummySpecifierCell.m
//  Egeniq
//
//  Created by Peter Verhage on 11-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFDummySpecifierCell.h"

@implementation EFDummySpecifierCell

#ifdef __BLOCKS__
@synthesize detailsViewControllerBlock=detailsViewControllerBlock_;

- (BOOL)showDetailsOnSelect {
    return detailsViewControllerBlock_ != nil;
}

- (UIViewController *)detailsViewController {
    if (detailsViewControllerBlock_ != nil && self.isEditable) {
        return detailsViewControllerBlock_();
    } else {
        return nil;
    }
}
#endif

@end
