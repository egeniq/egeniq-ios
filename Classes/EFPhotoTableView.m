#import "EFPhotoTableView.h"

@interface EFPhotoTableView () <UITableViewDelegate, UITableViewDataSource>
- (void)setup;
@end

@implementation EFPhotoTableView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];	
	if (self != nil) {
		[self setup];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self != nil) {
		[self setup];
	}
	return self;
}

- (void)setup {
	self.autoresizesSubviews = YES;
	tableView = [[UITableView alloc] initWithFrame:[self frame]];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	tableView.delegate = self;
	[self addSubview:tableView];
}

- (void)dealloc {
	[tableView release];
    tableView = nil;
	[indexPathForSelectedPhoto release];
	indexPathForSelectedPhoto = nil;
	[super dealloc];	
}

#pragma mark -
#pragma mark Table view delegate / dataSource methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	id<EFPhoto> photo = [self.dataSource photoView:self photoAtIndexPath:indexPath];
	CGSize size = [photo sizeForVersion:EFPhotoVersionThumbnail];
	return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PhotoTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    cell.textLabel.text = @"Test";
    return cell;	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.dataSource photoView:self numberOfPhotosInCollection:0];
}

#pragma mark -
#pragma mark Photo view method overrides

- (void)setDataSource:(id<EFPhotoViewDataSource>)newDataSource {
    [super setDataSource:newDataSource];
	tableView.dataSource = newDataSource == nil ? nil : self;	
    [self reloadData];
}

- (void)reloadData {
	[tableView reloadData];
}

#pragma mark -
#pragma mark Photo table view specific public methods

- (NSIndexPath *)indexPathForSelectedPhoto {
    return indexPathForSelectedPhoto;
}

- (void)selectPhotoAtIndexPath:(NSIndexPath *)indexPath {
    indexPathForSelectedPhoto = [indexPath copy];
}

@end
