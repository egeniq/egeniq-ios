//
//  EFDownloadBlockDelegate.h
//  Egeniq
//
//  Created by Peter Verhage on 01-05-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFDownload.h"

typedef void (^EFDownloadDidReceiveDownloadBlock)(NSData *data, NSURLResponse *response);
typedef void (^EFDownloadDidFinishLoadingBlock)();
typedef void (^EFDownloadDidFailWithErrorBlock)(NSError *error);

@interface EFDownloadBlockDelegate : NSObject <EFDownloadDelegate> {
    
}

@property (nonatomic, copy) EFDownloadDidReceiveDownloadBlock didReceiveDownloadBlock;
@property (nonatomic, copy) EFDownloadDidFinishLoadingBlock didFinishLoadingBlock;
@property (nonatomic, copy) EFDownloadDidFailWithErrorBlock didFailWithErrorBlock;

@end
