//
//  EFDownloadBlockDelegate.m
//  Egeniq
//
//  Created by Peter Verhage on 01-05-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFDownloadBlockDelegate.h"

@implementation EFDownloadBlockDelegate

@synthesize didReceiveDownloadBlock=didReceiveDownloadBlock_;
@synthesize didFinishLoadingBlock=didFinishLoadingBlock_;
@synthesize didFailWithErrorBlock=didFailWithErrorBlock_;

- (void)download:(EFDownload *)download didReceiveDownload:(NSData *)data response:(NSURLResponse *)response {
    if (self.didReceiveDownloadBlock != nil) {
        [self didReceiveDownloadBlock](data, response);
    }
}

- (void)downloadDidFinishLoading:(EFDownload *)download {
    if (self.didFinishLoadingBlock != nil) {
        [self didFinishLoadingBlock]();
    }
}

- (void)download:(EFDownload *)download didFailWithError:(NSError *)error {
    if (self.didFailWithErrorBlock != nil) {
        [self didFailWithErrorBlock](error);
    }
}

- (void)dealloc {
    self.didReceiveDownloadBlock = nil;
    self.didFinishLoadingBlock = nil;
    self.didFailWithErrorBlock = nil;
    [super dealloc];
}

@end
