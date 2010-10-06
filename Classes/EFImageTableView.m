#import "EFImageTableView.h"

#define PHOTOVIEW_TAG 1

@interface EFImageTableView () <UITableViewDelegate, UITableViewDataSource>
- (void)configureTableView;
@end

@implementation EFImageTableView

@synthesize imageVersion;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];	
	if (self != nil) {
		[self configureTableView];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self != nil) {
		[self configureTableView];
	}
	return self;
}

- (void)configureTableView {
	self.imageVersion = nil;
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
	[indexPathForSelectedImage release];
	indexPathForSelectedImage = nil;
	[super dealloc];	
}

#pragma mark -
#pragma mark Table view delegate / dataSource methods

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(imageView:willSelectImageAtIndexPath:)]) {
		indexPath = [self.delegate imageView:self willSelectImageAtIndexPath:indexPath];
	}
	
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(imageView:didSelectImageAtIndexPath:)]) {
		[self.delegate imageView:self didSelectImageAtIndexPath:indexPath];
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(imageView:willDeselectImageAtIndexPath:)]) {
		indexPath = [self.delegate imageView:self willDeselectImageAtIndexPath:indexPath];
	}
	
	return indexPath;	
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(imageView:didDeselectImageAtIndexPath:)]) {
		[self.delegate imageView:self didDeselectImageAtIndexPath:indexPath];
	}	
}

- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	id<EFImage> image = [self.dataSource imageView:self imageAtIndexPath:indexPath];
	CGSize size = [image sizeForVersion:self.imageVersion];
	CGFloat height = round(size.height / (size.width / tableView.bounds.size.width));
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ImageTableViewCell";
    
	UIImageView *imageView = nil;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, tableView.bounds.size.width)] autorelease];
        imageView.tag = PHOTOVIEW_TAG;
        [cell.contentView addSubview:imageView];
    } else {
		imageView = (UIImageView *)[cell.contentView viewWithTag:PHOTOVIEW_TAG];
	}

	id<EFImage> image = [self.dataSource imageView:self imageAtIndexPath:indexPath];	
	NSString *path = [image pathForVersion:self.imageVersion];
	imageView.image = [UIImage imageWithContentsOfFile:path];
	CGRect frame = imageView.frame;
	frame.size.height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
	imageView.frame = frame;
    return cell;	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([self.dataSource respondsToSelector:@selector(numberOfCollectionsInImageView:)]) {
		return [self.dataSource numberOfCollectionsInImageView:self];
	} else {
		return 1;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.dataSource respondsToSelector:@selector(imageView:numberOfImagesInCollection:)]) {
		return [self.dataSource imageView:self numberOfImagesInCollection:section];
	} else {
		return 0;
	}
}

#pragma mark -
#pragma mark Image view method overrides

- (void)setDataSource:(id<EFImageViewDataSource>)theDataSource {
    [super setDataSource:theDataSource];
    [self reloadData];
}

- (void)reloadData {
	[tableView reloadData];
}

#pragma mark -
#pragma mark Image table view specific public methods

- (void)selectImageAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    indexPathForSelectedImage = [indexPath copy];
	[tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionBottom];
}

- (NSIndexPath *)indexPathForSelectedImage {
    return [[indexPathForSelectedImage copy] autorelease];
}

@end
