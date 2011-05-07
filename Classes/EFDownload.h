//
//  Downloader.h
//  iPortfolio
//
//  Created by Ivo Jansch on 7/31/10.
//  Copyright (c) 2010 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EFDownload;

typedef void (^EFDownloadResponseBlock)(NSURLResponse *response, NSData *data);
typedef void (^EFDownloadCompletionBlock)(NSURLResponse *response, NSData *data, NSError *error);

@protocol EFDownloadDelegate <NSObject>
@optional
- (void)download:(EFDownload *)download didReceiveResponse:(NSURLResponse *)response data:(NSData *)data;
- (void)downloadDidFinishLoading:(EFDownload *)download;
- (void)download:(EFDownload *)download didFailWithError:(NSError *)error;
@end

@interface EFDownload : NSObject {

}

@property (nonatomic, assign) id<EFDownloadDelegate> delegate;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *targetPath;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) BOOL allowSelfSignedSSLCertificate;

@property (nonatomic, retain, readonly) NSURLResponse *response;
@property (nonatomic, retain, readonly) NSData *data;

- (id)initWithURL:(NSURL *)url;

- (void)start;
- (void)startWithCompletionHandler:(EFDownloadCompletionBlock)completionHandler;
- (void)startWithResponseHandler:(EFDownloadResponseBlock)responseHandler completionHandler:(EFDownloadCompletionBlock)completionHandler;
- (void)cancel;

- (void)addPayload:(id)object forKey:(NSString *)key;
- (id)getPayloadForKey:(NSString *)key;

@end