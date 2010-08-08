//
//  EFPhotoModel.h
//  Egeniq
//
//  Created by Peter C. Verhage on 25-07-10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//- (NSUInteger *)photoSizeAtIndex:

@protocol EFPhoto;

@protocol EFPhotoModel <NSObject>

/**
 * An array of objects that conform to the EFPhotoModelDelegate protocol.
 */
- (NSMutableArray*)delegates;
    
/**
 * The total number of photos in the source, independent of the number that have been loaded.
 */
@property (nonatomic, readonly) NSUInteger numberOfPhotos; 

/**
 * The photo at the given index.
 */
- (id<EFPhoto>)photoAtIndex:(NSUInteger)index;

@end
