//
//  EFNibView.h
//  iPortfolio
//
//  Created by Ivo Jansch on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EFNibViewController : NSObject {

    UIView *view;
    
}

- (id) initWithNibName: (NSString *)nibName;

@property (nonatomic, retain) UIView *view;


@end
