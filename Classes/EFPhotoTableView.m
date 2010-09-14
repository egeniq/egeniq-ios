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
	tableView.backgroundColor = [UIColor blackColor];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
	NSIndexPath *photoIndexPath = [NSIndexPath indexPathWithIndex:[indexPath indexAtPosition:1]];
	id<EFPhoto> photo = [self.dataSource photoView:self photoAtIndexPath:photoIndexPath];
	CGSize size = [photo sizeForVersion:EFPhotoVersionThumbnail];
	CGFloat height = round(size.height / (size.width / 90));
	return height;
}


#define PHOTOVIEW_TAG 1

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PhotoTableViewCell";
    
	UIImageView *photoView = nil;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        photoView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 90.0, 90.0)] autorelease];
        photoView.tag = PHOTOVIEW_TAG;
        [cell.contentView addSubview:photoView];
    } else {
		photoView = (UIImageView *)[cell.contentView viewWithTag:PHOTOVIEW_TAG];
	}
	NSIndexPath *photoIndexPath = [NSIndexPath indexPathWithIndex:[indexPath indexAtPosition:1]];
	id<EFPhoto> photo = [self.dataSource photoView:self photoAtIndexPath:photoIndexPath];	
	NSString *path = [photo pathForVersion:EFPhotoVersionThumbnail];
	photoView.image = [UIImage imageWithContentsOfFile:path];
	CGRect frame = photoView.frame;
	frame.size.height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
	photoView.frame = frame;
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
