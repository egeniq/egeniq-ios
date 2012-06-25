//
//  This is basically EGORefreshTableHeaderView, but heavily cleaned up by Johan Kool.
//

//
//  EGORefreshTableHeaderView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    PullRefreshPulling = 0,
    PullRefreshNormal,
    PullRefreshLoading,
} PullRefreshState;

@protocol EFRefreshHeaderViewDelegate;

@interface EFRefreshHeaderView : UIView 

@property (nonatomic, assign) IBOutlet id <EFRefreshHeaderViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

// The delegate of the UITableView should call these methods at the appropriate time
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)dataSourceDidFinishLoading:(UIScrollView *)scrollView;

@end

@protocol EFRefreshHeaderViewDelegate <NSObject>

- (void)refreshHeaderViewDidTriggerRefresh:(EFRefreshHeaderView *)view;
- (BOOL)refreshHeaderViewDataSourceIsLoading:(EFRefreshHeaderView *)view;

@optional
// Use this method to for example inform the user when the data was last updated
- (NSString *)refreshHeaderViewStatusLabelText:(EFRefreshHeaderView *)view;

@end
