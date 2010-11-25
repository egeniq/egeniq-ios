//
//  MultiValueTableViewCell.m
//  AxisControl
//
//  Created by Peter Verhage on 17-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFMultiValueSpecifierCell.h"
#import "EFMultiValueValueCell.h"


@implementation EFMultiValueSpecifierCell

@synthesize navigationController;
@synthesize values=values_, titles=titles_, value=value_;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithReuseIdentifier:reuseIdentifier]) != nil) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
		[self addGestureRecognizer:recognizer];
		
		self.values = [NSArray array];
		self.titles = [NSArray array];		
		self.value = nil;
    }
	
    return self;
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

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateEnded) {
		UITableViewController *viewController = [[[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
		viewController.navigationItem.title = self.textLabel.text;		
		viewController.tableView.dataSource = self;
		viewController.tableView.delegate = self;

		[self.navigationController pushViewController:viewController animated:YES];
		
		
		NSUInteger index = [self.values indexOfObject:self.value];		
		if (index != NSNotFound) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
			[viewController.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
		}
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
		cell = [[[EFMultiValueValueCell alloc] initWithReuseIdentifier:@"ValueCell"] autorelease];
	}	
	
	cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.value = [self.values objectAtIndex:indexPath.row];
}

- (void)dealloc {
    [super dealloc];
}

@end