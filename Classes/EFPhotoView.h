//
//  EFPhotoView.h
//  Egeniq
//
//  Created by Peter C. Verhage on 25-07-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFPhotoModel.h"

@interface EFPhotoView : UIView <UIScrollViewDelegate> {
    UIScrollView *pagingScrollView;    
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
}

/**
 * The photo model for this photo view. The current photo
 * index will be reset to 0, unless thto model doesn't contain
 * any photos in which case the index is reset to -1.
 */
@property (retain) id<EFPhotoModel> photoModel;

/**
 * The index within the model of the current photo that is shown
 * or (on assignment) needs to be shown.
 */
@property (assign) NSUInteger photoIndex;

@end




