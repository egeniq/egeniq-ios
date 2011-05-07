//
//  Downloader.h
//  iPortfolio
//
//  Created by Ivo Jansch on 7/31/10.
//  Copyright (c) 2010 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EFDownload;

@protocol EFDownloadDelegate <NSObject>
@optional
- (void)download:(EFDownload *)download didReceiveDownload:(NSData *)data response:(NSURLResponse *)response;
- (void)downloadDidFinishLoading:(EFDownload *)download;
- (void)download:(EFDownload *)download didFailWithError:(NSError *)error;
@end

@interface EFDownload : NSObject {

}

- (id)initWithURL:(NSURL *)anUrl;
- (void)start;
- (void)cancel;
- (void)addPayload:(id)object forKey:(NSString *)key;
- (id)getPayloadForKey:(NSString *)key;

@property (nonatomic, assign) id<EFDownloadDelegate> delegate;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *targetPath;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) BOOL allowSelfSignedSSLCertificate;

@property (nonatomic, retain, readonly) NSURLResponse *response;
@property (nonatomic, retain, readonly) NSData *data;

@end