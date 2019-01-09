//
//  Downloader.h
//  iPortfolio
//
//  Created by Ivo Jansch on 7/31/10.
//  Copyright (c) 2010 Egeniq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFRequest.h"
#import "EFQueue.h"

typedef NSData * (^EFDownloadPreProcessBlock)(NSURLResponse *response, NSData *data, NSError **error);
typedef void (^EFDownloadResultBlock)(NSURLResponse *response, NSURL *targetURL, NSError *error);
typedef void (^EFDownloadProgressBlock)(long long bytesWritten, long long totalBytesWritten, long long expectedTotalBytes);
typedef void (^EFDownloadCompletionBlock)(void);

@interface EFDownload : NSObject <EFQueueable> {

}

@property (nonatomic, retain) EFRequest *request;
@property (nonatomic, retain) NSURL *targetURL;
@property (nonatomic, copy) EFDownloadPreProcessBlock preProcessHandler;
@property (nonatomic, copy) EFDownloadProgressBlock progressHandler;
@property (nonatomic, copy) EFDownloadResultBlock resultHandler;

+ (id)download;
+ (id)downloadWithRequest:(EFRequest *)request 
                targetURL:(NSURL *)targetURL;
+ (id)downloadWithRequest:(EFRequest *)request 
                targetURL:(NSURL *)targetURL
        preProcessHandler:(EFDownloadPreProcessBlock)preProcessHandler
            resultHandler:(EFDownloadResultBlock)resultHandler;

- (id)init;
- (id)initWithRequest:(EFRequest *)request 
            targetURL:(NSURL *)targetURL;
- (id)initWithRequest:(EFRequest *)request 
            targetURL:(NSURL *)targetURL
    preProcessHandler:(EFDownloadPreProcessBlock)preProcessHandler
        resultHandler:(EFDownloadResultBlock)resultHandler;

- (void)startWithCompletionHandler:(EFDownloadCompletionBlock)completionHandler;
- (void)start;
- (void)cancel;

@end
