#import "EFPhotoTableView.h"

#define PHOTOVIEW_TAG 1

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
	tableView.dataSource = self;
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
	CGFloat height = round(size.height / (size.width / 90));
	return height;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(photoView:willSelectPhotoAtIndexPath:)]) {
		indexPath = [delegate photoView:self willSelectPhotoAtIndexPath:indexPath];
	}
	
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(photoView:didSelectPhotoAtIndexPath:)]) {
		[delegate photoView:self didSelectPhotoAtIndexPath:indexPath];
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(photoView:willDeselectPhotoAtIndexPath:)]) {
		indexPath = [delegate photoView:self willDeselectPhotoAtIndexPath:indexPath];
	}
	
	return indexPath;	
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(photoView:didDeselectPhotoAtIndexPath:)]) {
		[delegate photoView:self didDeselectPhotoAtIndexPath:indexPath];
	}	
}

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

	id<EFPhoto> photo = [self.dataSource photoView:self photoAtIndexPath:indexPath];	
	NSString *path = [photo pathForVersion:EFPhotoVersionThumbnail];
	photoView.image = [UIImage imageWithContentsOfFile:path];
	CGRect frame = photoView.frame;
	frame.size.height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
	photoView.frame = frame;
    return cell;	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([self.dataSource respondsToSelector:@selector(numberOfCollectionsInPhotoView:)]) {
		return [self.dataSource numberOfCollectionsInPhotoView:self];
	} else {
		return 1;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.dataSource respondsToSelector:@selector(photoView:numberOfPhotosInCollection:)]) {
		return [self.dataSource photoView:self numberOfPhotosInCollection:section];
	} else {
		return 0;
	}
}

#pragma mark -
#pragma mark Photo view method overrides

- (void)setDataSource:(id<EFPhotoViewDataSource>)theDataSource {
    [super setDataSource:theDataSource];
    [self reloadData];
}

- (void)reloadData {
	[tableView reloadData];
}

#pragma mark -
#pragma mark Photo table view specific public methods

- (void)selectPhotoAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    indexPathForSelectedPhoto = [indexPath copy];
	[tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionMiddle];
}

- (NSIndexPath *)indexPathForSelectedPhoto {
    return [[indexPathForSelectedPhoto copy] autorelease];
}

@end
