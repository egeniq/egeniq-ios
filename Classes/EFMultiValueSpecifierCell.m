//
//  MultiValueTableViewCell.m
//  AxisControl
//
//  Created by Peter Verhage on 17-11-10.
//  Copyright 2010 Egeniq. All rights reserved.
//

#import "EFMultiValueSpecifierCell.h"

@interface EFMultiValueSpecifierCell_TableViewController : UITableViewController

@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@end

@implementation EFMultiValueSpecifierCell_TableViewController

@synthesize selectedIndexPath = selectedIndexPath_;

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView scrollToRowAtIndexPath:self.selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    [super viewWillAppear:animated];
}

- (void)dealloc {
    self.selectedIndexPath = nil;
    [super dealloc];
}

@end



@implementation EFMultiValueSpecifierCell

@synthesize delegate=delegate_;
@synthesize values=values_;
@synthesize titles=titles_;

- (id)initWithName:(NSString *)name {
    if ((self = [super initWithName:name]) != nil) {
        self.accessoryType = self.editable ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
		
		self.values = [NSArray array];
		self.titles = [NSArray array];		
		self.value = nil;
    }
	
    return self;
}

- (void)setEditable:(BOOL)editable {
    [super setEditable:editable];
    self.accessoryType = editable ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
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
    return self.isEditable;
}

- (UIViewController *)detailsViewController {
	EFMultiValueSpecifierCell_TableViewController *viewController = [[EFMultiValueSpecifierCell_TableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	viewController.navigationItem.title = self.textLabel.text;		
	viewController.tableView.dataSource = self;
	viewController.tableView.delegate = self;
    NSInteger index = [self.values indexOfObject:self.value];
    viewController.selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    return [viewController autorelease];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = [self.values indexOfObject:self.value];		
    if (indexPath.row == index && cell.accessoryType != UITableViewCellAccessoryCheckmark) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
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
	} else {
        if (self.value != [self.values objectAtIndex:indexPath.row] && cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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
    
	if ([self.delegate respondsToSelector:@selector(multiValueSpecifierCell:didSelectValueAtIndex:)]) {	
		[self.delegate multiValueSpecifierCell:self didSelectValueAtIndex:indexPath.row];
	}      
}

- (void)dealloc {
    [super dealloc];
}

@end
