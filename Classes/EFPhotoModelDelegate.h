//
//  EFPhotoModelDelegate.h
//  Egeniq
//
//  Created by Peter C. Verhage on 06-08-10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

@protocol EFPhoto;
@protocol EFPhotoModel;

@protocol EFPhotoModelDelegate

@optional

/**
 * Informs the delegate that a photo has been updated.
 */
- (void)model:(id<EFPhotoModel>)model didUpdatePhoto:(id<EFPhoto>)photo atIndex:(NSUInteger)index;

/**
 * Informs the delegate that a photo has been inserted.
 */
- (void)model:(id<EFPhotoModel>)model didInsertPhoto:(id<EFPhoto>)photo atIndex:(NSUInteger)index;

/**
 * Informs the delegate that a photo has been deleted.
 */
- (void)model:(id<EFPhotoModel>)model didDeletePhoto:(id<EFPhoto>)photo atIndex:(NSUInteger)index;


/**
 * Informs the delegate that the model has changed in some fundamental way.
 *
 * The change is not described specifically, so the delegate must assume that the entire
 * contents of the model may have changed, and react almost as if it was given a new model.
 */
- (void)modelDidChange:(id<EFPhotoModel>)model;

/**
 * Informs the delegate that the model is about to begin a multi-stage update.
 *
 * Models should use this method to condense multiple updates into a single visible update.
 * This avoids having the view update multiple times for each change. Instead, the user will
 * only see the end result of all of your changes when you call modelDidEndUpdates.
 */
- (void)modelDidBeginUpdates:(id<EFPhotoModel>)model;

/**
 * Informs the delegate that the model has completed a multi-stage update.
 *
 * The exact nature of the change is not specified, so the receiver should investigate the
 * new state of the model by examining its properties.
 */
- (void)modelDidEndUpdates:(id<EFPhotoModel>)model;

@end
