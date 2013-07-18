#import "UIScrollView+BDDRScrollViewExtensions.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

@implementation UIScrollView (BDDRScrollViewExtensions)

static void *const BDDRScrollViewExtensionsOneFingerZoomStartZoomScaleAssociationKey = (void *)&BDDRScrollViewExtensionsOneFingerZoomStartZoomScaleAssociationKey;
static void *const BDDRScrollViewExtensionsOneFingerZoomStartLocationAssociationKey = (void *)&BDDRScrollViewExtensionsOneFingerZoomStartLocationAssociationKey;

#pragma mark - Swizzling Methods

+ (void)load {
	NSError *error;
	if (![self jr_swizzleMethod:@selector(setContentOffset:) withMethod:@selector(bddr_setContentOffset:) error:&error])
		NSLog(@"%@", [error localizedDescription]);
	if (![self jr_swizzleMethod:@selector(contentInset) withMethod:@selector(bddr_contentInset) error:&error])
		NSLog(@"%@", [error localizedDescription]);
	if (![self jr_swizzleMethod:@selector(setContentInset:) withMethod:@selector(bddr_setContentInset:) error:&error])
		NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - Centering the Content

- (void)bddr_centerContentIfNeeded {
	if (!self.tracking)
		[self bddr_centerContent];
}

- (void)bddr_centerContent {
	CGSize contentSize = self.contentSize;
	CGSize boundsSize = self.bounds.size;
	UIEdgeInsets contentInset = self.contentInset;
	CGFloat horizontalInset = 0.0f;
	CGFloat verticalInset = 0.0f;
	
	if (self.bddr_centersContentHorizontally && contentSize.width < boundsSize.width)
		horizontalInset = (boundsSize.width - contentSize.width) / 2.0f;
	if (self.bddr_centersContentVertically && contentSize.height < boundsSize.height)
		verticalInset = (boundsSize.height - contentSize.height) / 2.0f;
	
	[self bddr_setContentInset:UIEdgeInsetsMake(verticalInset + contentInsets.top,
												horizontalInset + contentInsets.left,
												verticalInset + contentInsets.bottom,
												horizontalInset + contentInsets.right)];
}

#pragma mark - Zooming with one Finger

- (void)bddr_addOrRemoveOneFingerGestureRecognizer {
	UILongPressGestureRecognizer *oneFingerZoomGestureRecognizer;
	
	if (self.bddr_oneFingerZoomEnabled) {
		oneFingerZoomGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bddr_handleOneFingerZoomGestureRecognizer:)];
		oneFingerZoomGestureRecognizer.numberOfTapsRequired = 1;
		oneFingerZoomGestureRecognizer.minimumPressDuration = 0.0f;
		[self addGestureRecognizer:oneFingerZoomGestureRecognizer];
	} else
		[self removeGestureRecognizer:self.bddr_oneFingerZoomGestureRecognizer];
	
	self.bddr_oneFingerZoomGestureRecognizer = oneFingerZoomGestureRecognizer;
}

- (void)bddr_handleOneFingerZoomGestureRecognizer:(UILongPressGestureRecognizer *)oneFingerZoomGestureRecognizer {
	CGPoint currentLocation = [oneFingerZoomGestureRecognizer locationInView:oneFingerZoomGestureRecognizer.view.window];
	
	switch (oneFingerZoomGestureRecognizer.state) {
		case UIGestureRecognizerStateBegan:
			objc_setAssociatedObject(self, BDDRScrollViewExtensionsOneFingerZoomStartZoomScaleAssociationKey, @(self.zoomScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
			objc_setAssociatedObject(self, BDDRScrollViewExtensionsOneFingerZoomStartLocationAssociationKey, [NSValue valueWithCGPoint:currentLocation], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
			break;
		case UIGestureRecognizerStateChanged: {
			CGFloat startZoomScale = [objc_getAssociatedObject(self, BDDRScrollViewExtensionsOneFingerZoomStartZoomScaleAssociationKey) floatValue];
			CGPoint startLocation = [objc_getAssociatedObject(self, BDDRScrollViewExtensionsOneFingerZoomStartLocationAssociationKey) CGPointValue];
			CGFloat newZoomScale = startZoomScale * (startLocation.y / currentLocation.y);
			self.zoomScale = MAX(MIN(newZoomScale, self.maximumZoomScale), self.minimumZoomScale);
			break;
		}
		default:
			break;
	}
}

#pragma mark - Overridden Getters and Setters

- (void)bddr_setContentOffset:(CGPoint)contentOffset {
	[self bddr_setContentOffset:contentOffset];
	[self bddr_centerContent];
}

- (UIEdgeInsets)bddr_contentInset {
	return [objc_getAssociatedObject(self, @selector(bddr_contentInset)) UIEdgeInsetsValue];
}

- (void)bddr_setContentInset:(UIEdgeInsets)contentInset {
	objc_setAssociatedObject(self, @selector(bddr_contentInset), [NSValue valueWithUIEdgeInsets:contentInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self bddr_centerContentIfNeeded];
}

#pragma mark - Getters of animated Properties

- (CGPoint)bddr_presentationLayerContentOffset {
	CALayer *presentationLayer = self.layer.presentationLayer;
	return presentationLayer.bounds.origin;
}

- (CGSize)bddr_presentationLayerContentSize {
	if ([self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
		UIView *zoomView = [self.delegate viewForZoomingInScrollView:self];
		CALayer *zoomPresentationLayer = zoomView.layer.presentationLayer;
		
		return zoomPresentationLayer.frame.size;
	} else
		return self.contentSize;
}

- (CGFloat)bddr_presentationLayerZoomScale {
	if ([self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
		UIView *zoomView = [self.delegate viewForZoomingInScrollView:self];
		CALayer *zoomPresentationLayer = zoomView.layer.presentationLayer;
		
		return zoomPresentationLayer.transform.m11;
	} else
		return self.zoomScale;
}

#pragma mark - Getters and Setters

- (void)bddr_setCentersContent:(BOOL)centersContent {
	self.bddr_centersContentHorizontally = centersContent;
	self.bddr_centersContentVertically = centersContent;
}

- (BOOL)bddr_centersContentHorizontally {
	return [objc_getAssociatedObject(self, @selector(bddr_centersContentHorizontally)) boolValue];
}

- (void)setBddr_centersContentHorizontally:(BOOL)centersContentHorizontally {
	objc_setAssociatedObject(self, @selector(bddr_centersContentHorizontally), @(centersContentHorizontally), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self bddr_centerContentIfNeeded];
}

- (BOOL)bddr_centersContentVertically {
	return [objc_getAssociatedObject(self, @selector(bddr_centersContentVertically)) boolValue];
}

- (void)setBddr_centersContentVertically:(BOOL)centersContentVertically {
	objc_setAssociatedObject(self, @selector(bddr_centersContentVertically), @(centersContentVertically), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self bddr_centerContentIfNeeded];
}

- (BOOL)bddr_oneFingerZoomEnabled {
	return [objc_getAssociatedObject(self, @selector(bddr_oneFingerZoomEnabled)) boolValue];
}

- (void)setBddr_oneFingerZoomEnabled:(BOOL)oneFingerZoomEnabled {
	objc_setAssociatedObject(self, @selector(bddr_oneFingerZoomEnabled), @(oneFingerZoomEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self bddr_addOrRemoveOneFingerGestureRecognizer];
}

- (UILongPressGestureRecognizer *)bddr_oneFingerZoomGestureRecognizer {
	return objc_getAssociatedObject(self, @selector(bddr_oneFingerZoomGestureRecognizer));
}

- (void)setBddr_oneFingerZoomGestureRecognizer:(UILongPressGestureRecognizer *)oneFingerZoomGestureRecognizer {
	objc_setAssociatedObject(self, @selector(bddr_oneFingerZoomGestureRecognizer), oneFingerZoomGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
