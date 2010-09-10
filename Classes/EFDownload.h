//
//  Downloader.h
//  iPortfolio
//
//  Created by Ivo Jansch on 7/31/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShowDirectoryModelDelegate;


@interface EFDownload : NSObject {

    NSMutableDictionary *payload;

    id delegate;
    
    NSURL *url;
   
    NSMutableData *data;
    
    NSString *targetPath;
    
}

- (id) initWithURL: (NSURL *)anUrl;
- (void) start;
- (void) addPayload: (id)object forKey: (NSString *)key;
- (id) getPayloadForKey: (NSString *)key;

@property (assign) id delegate;
@property (nonatomic, retain, readonly) NSMutableData *data;
@property (nonatomic, retain) NSString* targetPath;
@property (nonatomic, retain) NSURL* url;

@end

@interface NSObject (EFDownloadDelegateMethods)

- (void)downloadDidFinishLoading:(EFDownload*)download;
- (void)download:(EFDownload*)download didFailWithError:(NSError*)error;

@end