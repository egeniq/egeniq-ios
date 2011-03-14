//
//  EFDummySpecifierCell.h
//  Egeniq
//
//  Created by Peter Verhage on 11-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFSpecifierCell.h"

#ifdef __BLOCKS__
typedef UIViewController *(^EFDetailsViewControllerBlock)(void);
#endif

@interface EFDummySpecifierCell : EFSpecifierCell {

}

#ifdef __BLOCKS__
@property(nonatomic, copy) EFDetailsViewControllerBlock detailsViewControllerBlock;
#endif

- (BOOL)showDetailsOnSelect;

@end
