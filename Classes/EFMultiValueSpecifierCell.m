//
//  MultiValueTableViewCell.m
//  AxisControl
//
//  Created by Peter Verhage on 17-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFMultiValueSpecifierCell.h"

@implementation EFMultiValueSpecifierCell

@synthesize values=values_, titles=titles_;

- (id)initWithName:(NSString *)name {
    if ((self = [super initWithName:name]) != nil) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		self.values = [NSArray array];
		self.titles = [NSArray array];		
		self.value = nil;
    }
	
    return self;
}

- (id)value {
    return [value_ copy];
}

- (void)setValue:(id)value {
	NSUInteger index = [self.values indexOfObject:value];
	
	if (index != NSNotFound) {
		value_ = [value retain];
		self.detailTextLabel.text = [self.titles objectAtIndex:index];
	} else {
		value_ = nil;
		self.detailTextLabel.text = @" ";
	}
}

- (BOOL)showDetailsOnSelect {
    return YES;
}

- (UIViewController *)detailsViewController {
	UITableViewController *viewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	viewController.navigationItem.title = self.textLabel.text;		
	viewController.tableView.dataSource = self;
	viewController.tableView.delegate = self;
    return [viewController autorelease];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = [self.values indexOfObject:self.value];		
    if (indexPath.row == index && cell.accessoryType != UITableViewCellAccessoryCheckmark) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.values count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ValueCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ValueCell"] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}	
	
	cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger oldIndex = [self.values indexOfObject:self.value];
	if (oldIndex != NSNotFound) {
		NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldIndex inSection:indexPath.section];
		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
		oldCell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;

	self.value = [self.values objectAtIndex:indexPath.row];	
	
	[tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)dealloc {
    [super dealloc];
}

@end