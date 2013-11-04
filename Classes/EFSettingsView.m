//
//  EFSettingsView.m
//  Egeniq
//
//  Created by Peter Verhage on 10-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFSettingsView.h"

@interface EFSettingsView () <UITableViewDelegate, UITableViewDataSource>
- (void)setupTableView;
@end

@implementation EFSettingsView

@synthesize delegate=delegate_;
@synthesize dataSource=dataSource_;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
		[self setupTableView];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self != nil) {
		[self setupTableView];
	}
	return self;
}

- (void)setupTableView {
	tableView_ = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
	tableView_.delegate = self;
	tableView_.dataSource = self;
	tableView_.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    if ([tableView_ respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView_ setSeparatorInset:UIEdgeInsetsZero];
    }

	[self addSubview:tableView_];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInSettingsView:)]) {
        return [self.dataSource numberOfSectionsInSettingsView:self];
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(settingsView:titleForSection:)]) {
        if ([tableView_ respondsToSelector:@selector(setSeparatorInset:)] && [self.dataSource settingsView:self titleForSection:section] != nil) {
            // Setting seperator edge inset also removes inset from titleheader. Add 2 whitespaces to 'fix' this.
            return [NSString stringWithFormat:@"\u00A0\u00A0%@", [self.dataSource settingsView:self titleForSection:section]];
        } else {
            return [self.dataSource settingsView:self titleForSection:section];
        }
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource settingsView:self numberOfFieldsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource settingsView:self fieldAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EFSpecifierCell *field = (EFSpecifierCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return field.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(settingsView:didSelectField:)]) {   
        EFSpecifierCell *field = (EFSpecifierCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        [self.delegate settingsView:self didSelectField:field];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(settingsView:viewForFooterInSection:)]) {       
        return [self.delegate settingsView:self viewForFooterInSection:section];
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(settingsView:viewForFooterInSection:)]) {       
        UIView *view = [self.delegate settingsView:self viewForFooterInSection:section];
        return view != nil ? view.bounds.size.height : 0.0;
    } else {
        return 0.0;
    }
}

- (void)reloadFields {
    [tableView_ reloadData];
}

- (void)dealloc {
	[tableView_ release];
	tableView_ = nil;
	[super dealloc];
}

@end
