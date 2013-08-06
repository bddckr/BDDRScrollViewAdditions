#import "BDDRViewController.h"
#import "UIScrollView+BDDRScrollViewAdditions.h"

typedef NS_ENUM(NSUInteger, BDDRScrollViewFeature) {
	BDDRScrollViewFeatureCentering,
	BDDRScrollViewFeatureDoubleTapZoomIn,
	BDDRScrollViewFeatureDoubleTapZoomToMinimum,
	BDDRScrollViewFeatureTwoFingerZoomOut,
	BDDRScrollViewFeatureOneFingerZoom
};


@interface BDDRViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIView *zoomView;
@property (nonatomic, assign) BOOL scrollViewIsSetUpCompletly;

@end


@implementation BDDRViewController

#pragma mark - Managing the View

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.scrollView.bddr_centersContent = YES;
	self.scrollView.bddr_doubleTapZoomInEnabled = YES;
	self.scrollView.bddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale = YES;
	self.scrollView.bddr_twoFingerZoomOutEnabled = YES;
	self.scrollView.bddr_oneFingerZoomEnabled = YES;
	
	self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	self.scrollView.delegate = self;
	self.scrollView.minimumZoomScale = 0.5f;
	self.scrollView.maximumZoomScale = 2.0f;
	
	NSUInteger numberOfCellsInHorizontalDirection = 10;
	NSUInteger numberOfCellsInVerticalDirection = 10;
	CGSize viewSize = self.scrollView.bounds.size;
	CGSize cellViewSize = (CGSize){viewSize.width / numberOfCellsInHorizontalDirection, viewSize.height / numberOfCellsInVerticalDirection};
	
	self.zoomView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, self.scrollView.bounds.size}];
	[self.scrollView addSubview:self.zoomView];
	self.scrollView.contentSize = viewSize;
	
	for (NSUInteger x = 0; x < 10; x++)
		for (NSUInteger y = 0; y < 10; y++) {
			UIView *view = [[UIView alloc] initWithFrame:(CGRect){x * cellViewSize.width, y * cellViewSize.height, cellViewSize}];
			view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0f
												   green:arc4random_uniform(255) / 255.0f
													blue:arc4random_uniform(255) / 255.0f
												   alpha:1.0f];
			[self.zoomView addSubview:view];
		}
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	if (self.scrollViewIsSetUpCompletly) return;
	
	self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
	self.scrollViewIsSetUpCompletly = YES;
}

#pragma mark - UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	if (scrollView != self.scrollView) return nil;
	return self.zoomView;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	BOOL featureOn;
	
	if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
		cell.accessoryType = UITableViewCellAccessoryNone;
		featureOn = NO;
	} else {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		featureOn = YES;
	}
	
	if (indexPath.row == BDDRScrollViewFeatureDoubleTapZoomIn) {
		UITableViewCell *doubleTapZoomToMinimumCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:BDDRScrollViewFeatureDoubleTapZoomToMinimum
																										  inSection:indexPath.section]];
		doubleTapZoomToMinimumCell.textLabel.enabled = featureOn;
		doubleTapZoomToMinimumCell.userInteractionEnabled = featureOn;
	}
	
	switch (indexPath.row) {
		case BDDRScrollViewFeatureCentering:
			self.scrollView.bddr_centersContent = featureOn;
			break;
		case BDDRScrollViewFeatureDoubleTapZoomIn:
			self.scrollView.bddr_doubleTapZoomInEnabled = featureOn;
			break;
		case BDDRScrollViewFeatureDoubleTapZoomToMinimum:
			self.scrollView.bddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale = featureOn;
			break;
		case BDDRScrollViewFeatureTwoFingerZoomOut:
			self.scrollView.bddr_twoFingerZoomOutEnabled = featureOn;
			break;
		case BDDRScrollViewFeatureOneFingerZoom:
			self.scrollView.bddr_oneFingerZoomEnabled = featureOn;
			break;
		default:
			break;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
