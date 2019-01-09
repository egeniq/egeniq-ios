//
//  This is basically EGORefreshTableHeaderView, but heavily cleaned up by Johan Kool.
//

//
//  EGORefreshTableHeaderView.m
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

#import "EFRefreshHeaderView.h"


#define TEXT_COLOR              [UIColor whiteColor]
//[UIColor colorWithRed:87.0 / 255.0 green:108.0 / 255.0 blue:137.0 / 255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EFRefreshHeaderView () {
    PullRefreshState state_;
}

@property (nonatomic, retain) CALayer *arrowImage;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) PullRefreshState state;

- (void)setupWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

@end

@implementation EFRefreshHeaderView

@synthesize delegate=delegate_;
@synthesize instructionLabel=instructionLabel_;
@synthesize statusLabel=statusLabel_;
@synthesize arrowImage=arrowImage_;
@synthesize activityView=activityView_;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if ((self = [super initWithFrame:frame])) {
        [self setupWithFrame:frame arrowImageName:arrow textColor:textColor];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame arrowImageName:@"whiteArrow.png" textColor:TEXT_COLOR];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect frame = self.frame;
    UIColor *textColor = TEXT_COLOR;
    NSString *arrow = @"blueArrow.png";
    [self setupWithFrame:frame arrowImageName:arrow textColor:textColor];
}

- (void)setupWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor orangeColor];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(48.0f, frame.size.height - 48.0f, frame.size.width - 48.0f, 32.0f)] autorelease];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    self.instructionLabel = label;
    
    // Note: statusLabel not used in this app
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(8.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contents = (id)[UIImage imageNamed : arrow].CGImage;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        layer.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    
    [[self layer] addSublayer:layer];
    self.arrowImage = layer;
    
    UIActivityIndicatorView *view = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    view.frame = CGRectMake(20.0f, frame.size.height - 44.0f, 20.0f, 20.0f);
    [self addSubview:view];
    self.activityView = view;
    
    self.state = PullRefreshNormal;
}

- (PullRefreshState)state {
    return state_;
}

- (void)setState:(PullRefreshState)state {

    switch (state) {
        case PullRefreshPulling:

            self.instructionLabel.text = NSLocalizedString(@"Laat de kolom los om de nieuwste berichten te zien", @"Release to refresh status");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            self.arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];

            break;
        case PullRefreshNormal:

            if (self.state == PullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                self.arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }

            self.instructionLabel.text = NSLocalizedString(@"Trek de kolom omlaag om de nieuwste berichten te zien", @"Pull down to refresh status");
            [self.activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
            self.arrowImage.hidden = NO;
            self.arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];

            if ([self.delegate respondsToSelector:@selector(refreshHeaderViewStatusLabelText:)]) {
                self.statusLabel.text = [self.delegate refreshHeaderViewStatusLabelText:self];
            } else {
                self.statusLabel.text = nil;
            }

            break;
        case PullRefreshLoading:

            self.instructionLabel.text = NSLocalizedString(@"Nieuwste berichten laden…", @"Loading Status");
            [self.activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
            self.arrowImage.hidden = YES;
            [CATransaction commit];

            break;
        default:
            break;
    }

    state_ = state;
}

#pragma mark - ScrollView Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.state == PullRefreshLoading) {

        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);

    } else if (scrollView.isDragging) {

        BOOL loading = NO;
        if ([self.delegate respondsToSelector:@selector(refreshHeaderViewDataSourceIsLoading:)]) {
            loading = [self.delegate refreshHeaderViewDataSourceIsLoading:self];
        }
        if (self.state == PullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !loading) {
            [self setState:PullRefreshNormal];
        } else if (self.state == PullRefreshNormal && scrollView.contentOffset.y < -65.0f && !loading) {
            [self setState:PullRefreshPulling];
        }
        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    BOOL loading = NO;

    if ([self.delegate respondsToSelector:@selector(refreshHeaderViewDataSourceIsLoading:)]) {
        loading = [self.delegate refreshHeaderViewDataSourceIsLoading:self];
    }
    
    if (scrollView.contentOffset.y <= -65.0f && !loading) {

        if ([self.delegate respondsToSelector:@selector(refreshHeaderViewDidTriggerRefresh:)]) {
            [self.delegate refreshHeaderViewDidTriggerRefresh:self];
        }
        self.state = PullRefreshLoading;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];

    }
}

- (void)dataSourceDidFinishLoading:(UIScrollView *)scrollView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];

    self.state = PullRefreshNormal;
}

#pragma mark - Dealloc
- (void)dealloc {
    self.delegate = nil;
    self.activityView = nil;
    self.instructionLabel = nil;
    self.arrowImage = nil;
    self.statusLabel = nil;
    [super dealloc];
}

@end
