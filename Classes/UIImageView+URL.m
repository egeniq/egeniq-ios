//
//  UIImageView+URL.m
//  Koolistov
//
//  Created by Johan Kool on 28-10-10.
//  Copyright 2010-2011 Koolistov. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are 
//  permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this list of 
//    conditions and the following disclaimer.
//  * Neither the name of KOOLISTOV nor the names of its contributors may be used to 
//    endorse or promote products derived from this software without specific prior written 
//    permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
//  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
//  THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT 
//  OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "UIImageView+URL.h"

#import "EFImageCache.h"

#define kActivityIndicatorTag 18942347

@implementation UIImageView (URL)

- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)indicatorStyle {
    // Ensure we don't get multiple spinners
    [[self viewWithTag:kActivityIndicatorTag] removeFromSuperview];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorStyle];

    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    CGRect currentFrame = activityIndicator.frame;
    CGRect newFrame = CGRectMake(CGRectGetMidX(self.bounds) - 0.5f * currentFrame.size.width,
                                 CGRectGetMidY(self.bounds) - 0.5f * currentFrame.size.height,
                                 currentFrame.size.width,
                                 currentFrame.size.height);
    activityIndicator.frame = newFrame;
    activityIndicator.tag = kActivityIndicatorTag;
    [activityIndicator startAnimating];
    [self addSubview:activityIndicator];
    [activityIndicator release];
}

- (void)hideActivityIndicator {
    UIView *activityIndicator = [self viewWithTag:kActivityIndicatorTag];

    [activityIndicator removeFromSuperview];
}

- (void)setImageAtURL:(NSURL *)imageURL {
    [self setImageAtURL:imageURL showActivityIndicator:YES activityIndicatorStyle:UIActivityIndicatorViewStyleGray loadingImage:nil notAvailableImage:nil];
}

- (void)setImageAtURL:(NSURL *)imageURL cache:(BOOL)cache completionHandler:(void(^)(UIImage *image))completionHandler {
    [self setImageAtURL:imageURL cacheURL:cache ? imageURL : nil showActivityIndicator:YES activityIndicatorStyle:UIActivityIndicatorViewStyleGray loadingImage:nil notAvailableImage:nil completionHandler:completionHandler];
}

- (void)setImageAtURL:(NSURL *)imageURL showActivityIndicator:(BOOL)showActivityIndicator activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingImage:(UIImage *)loadingImage notAvailableImage:(UIImage *)notAvailableImage {
    [self setImageAtURL:imageURL cacheURL:imageURL showActivityIndicator:showActivityIndicator activityIndicatorStyle:indicatorStyle loadingImage:loadingImage notAvailableImage:notAvailableImage];
}

- (void)setImageAtURL:(NSURL *)imageURL cacheURL:(NSURL *)cacheURL showActivityIndicator:(BOOL)showActivityIndicator activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingImage:(UIImage *)loadingImage notAvailableImage:(UIImage *)notAvailableImage {
    [self setImageAtURL:imageURL cacheURL:cacheURL showActivityIndicator:showActivityIndicator activityIndicatorStyle:indicatorStyle loadingImage:loadingImage notAvailableImage:notAvailableImage completionHandler:NULL];
}

- (void)setImageAtURL:(NSURL *)imageURL cacheURL:(NSURL *)cacheURL showActivityIndicator:(BOOL)showActivityIndicator activityIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingImage:(UIImage *)loadingImage notAvailableImage:(UIImage *)notAvailableImage completionHandler:(void(^)(UIImage *image))completionHandler {
    NSAssert([NSThread isMainThread], @"This method should be called from the main thread.");
    // Cancel any previous downloads
    [[EFImageCache defaultCache] cancelDownloadForImageView:self];    
    [self hideActivityIndicator];

    self.image = loadingImage;

    if (!imageURL) {
        self.image = notAvailableImage;
        return;
    }
    
    if (showActivityIndicator) {
        [self showActivityIndicatorWithStyle:indicatorStyle];
    }
    
    [[EFImageCache defaultCache] loadImageAtURL:imageURL cacheURL:cacheURL imageView:self withHandler:^(UIImage * image) {
        if (!image) {
            self.image = notAvailableImage;
        } else {
            self.image = image;
        }
        if (showActivityIndicator) {
            [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
        }
        
        if (completionHandler) {
            completionHandler(image);
        }
     }];
}

- (void)cancelImageDownload {
    NSAssert([NSThread isMainThread], @"This method should be called from the main thread.");

    [self hideActivityIndicator];
    [[EFImageCache defaultCache] cancelDownloadForImageView:self];
}

@end