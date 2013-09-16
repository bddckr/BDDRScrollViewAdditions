#import "UIScrollView+BDDRScrollViewAdditions.h"
#import "BDDROneFingerZoomGestureRecognizer.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

@implementation UIScrollView (BDDRScrollViewAdditions)

#pragma mark - Method Swizzling

+ (void)load {
	NSError *error;
	if (![self jr_swizzleMethod:@selector(setContentOffset:) withMethod:@selector(bddr_setContentOffset:) error:&error])
		NSLog(@"%@", [error localizedDescription]);
	if (![self jr_swizzleMethod:@selector(contentInset) withMethod:@selector(bddr_contentInset) error:&error])
		NSLog(@"%@", [error localizedDescription]);
	if (![self jr_swizzleMethod:@selector(setContentInset:) withMethod:@selector(bddr_setContentInset:) error:&error])
		NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - Private Utility Methods

- (CGRect)bddr_zoomRectForZoomScale:(CGFloat)zoomScale locationOfGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
	UIView *zoomView = [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)] ? [self.delegate viewForZoomingInScrollView:self] : self;
	CGPoint location = [gestureRecognizer locationInView:zoomView];
	return [self bddr_zoomRectForZoomScale:zoomScale center:location];
}

#pragma mark - Content Centering

- (void)bddr_centerContent {
	CGSize contentSize = self.contentSize;
	CGSize boundsSize = self.bounds.size;
	UIEdgeInsets contentInset = self.contentInset;
	CGFloat horizontalInset = 0.0f;
	CGFloat verticalInset = 0.0f;
	
	if (self.bddr_centersContent) {
		if (contentSize.width < boundsSize.width)
			horizontalInset = (boundsSize.width - contentSize.width) / 2.0f;
		if (contentSize.height < boundsSize.height)
			verticalInset = (boundsSize.height - contentSize.height) / 2.0f;
	}
	
	contentInset.top += verticalInset;
	contentInset.bottom += verticalInset;
	contentInset.left += horizontalInset;
	contentInset.right += horizontalInset;
	
	[self bddr_setContentInset:contentInset];
}

#pragma mark - Double Tap Zoom In

- (void)bddr_addOrRemoveDoubleTapZoomInGestureRecognizer {
	UITapGestureRecognizer *doubleTapZoomInGestureRecognizer;
	
	if (self.bddr_doubleTapZoomInEnabled) {
		doubleTapZoomInGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bddr_handleDoubleTapZoomInGestureRecognizer:)];
		doubleTapZoomInGestureRecognizer.numberOfTapsRequired = 2;
		[self addGestureRecognizer:doubleTapZoomInGestureRecognizer];
	} else
		[self removeGestureRecognizer:self.bddr_doubleTapZoomInGestureRecognizer];
	
	self.bddr_doubleTapZoomInGestureRecognizer = doubleTapZoomInGestureRecognizer;
}

- (void)bddr_handleDoubleTapZoomInGestureRecognizer:(UITapGestureRecognizer *)doubleTapZoomInGestureRecognizer {
	if (doubleTapZoomInGestureRecognizer.state != UIGestureRecognizerStateEnded) return;
	
	if (self.zoomScale == self.maximumZoomScale && self.bddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
		return;
	}
	
	CGFloat newZoomScale = self.zoomScale * self.bddr_zoomScaleStepFactor;
	CGRect zoomRect = [self bddr_zoomRectForZoomScale:newZoomScale locationOfGestureRecognizer:doubleTapZoomInGestureRecognizer];
	[self zoomToRect:zoomRect animated:YES];
}

#pragma mark - Two Finger Zoom Out

- (void)bddr_addOrRemoveTwoFingerZoomOutGestureRecognizer {
	UITapGestureRecognizer *twoFingerZoomOutGestureRecognizer;
	
	if (self.bddr_twoFingerZoomOutEnabled) {
		twoFingerZoomOutGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bddr_handleTwoFingerZoomOutGestureRecognizer:)];
		twoFingerZoomOutGestureRecognizer.numberOfTouchesRequired = 2;
		[self addGestureRecognizer:twoFingerZoomOutGestureRecognizer];
	} else
		[self removeGestureRecognizer:self.bddr_twoFingerZoomOutGestureRecognizer];
	
	self.bddr_twoFingerZoomOutGestureRecognizer = twoFingerZoomOutGestureRecognizer;
}

- (void)bddr_handleTwoFingerZoomOutGestureRecognizer:(UITapGestureRecognizer *)twoFingerZoomOutGestureRecognizer {
	if (twoFingerZoomOutGestureRecognizer.state != UIGestureRecognizerStateEnded) return;
	
	CGFloat newZoomScale = self.zoomScale / self.bddr_zoomScaleStepFactor;
	CGRect zoomRect = [self bddr_zoomRectForZoomScale:newZoomScale locationOfGestureRecognizer:twoFingerZoomOutGestureRecognizer];
	[self zoomToRect:zoomRect animated:YES];
}

#pragma mark - One Finger Zoom

- (void)bddr_addOrRemoveOneFingerZoomGestureRecognizer {
	BDDROneFingerZoomGestureRecognizer *oneFingerZoomGestureRecognizer;
	
	if (self.bddr_oneFingerZoomEnabled) {
		oneFingerZoomGestureRecognizer = [[BDDROneFingerZoomGestureRecognizer alloc] initWithTarget:self action:@selector(bddr_handleOneFingerZoomGestureRecognizer:)];
		oneFingerZoomGestureRecognizer.bouncesScale = YES;
		[self addGestureRecognizer:oneFingerZoomGestureRecognizer];
	} else
		[self removeGestureRecognizer:self.bddr_oneFingerZoomGestureRecognizer];
	
	self.bddr_oneFingerZoomGestureRecognizer = oneFingerZoomGestureRecognizer;
}

- (void)bddr_handleOneFingerZoomGestureRecognizer:(BDDROneFingerZoomGestureRecognizer *)oneFingerZoomGestureRecognizer {
	switch (oneFingerZoomGestureRecognizer.state) {
		case UIGestureRecognizerStateBegan:
			oneFingerZoomGestureRecognizer.scaleFactor = self.maximumZoomScale / self.minimumZoomScale;
			oneFingerZoomGestureRecognizer.scale = self.zoomScale;
			oneFingerZoomGestureRecognizer.minimumScale = self.minimumZoomScale;
			oneFingerZoomGestureRecognizer.maximumScale = self.maximumZoomScale;
			
			if (self.bouncesZoom) {
				self.minimumZoomScale /= 2.0f;
				self.maximumZoomScale *= 2.0f;
			}
			
			if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
				[self.delegate scrollViewWillBeginZooming:self withView:[self.delegate viewForZoomingInScrollView:self]];
			break;
		case UIGestureRecognizerStateChanged:
			self.zoomScale = oneFingerZoomGestureRecognizer.scale;
			break;
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
			if ([self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
				[self.delegate scrollViewDidEndZooming:self withView:[self.delegate viewForZoomingInScrollView:self] atScale:oneFingerZoomGestureRecognizer.scale];
			
			if (self.bouncesZoom) {
				self.minimumZoomScale *= 2.0f;
				self.maximumZoomScale /= 2.0f;
				
				if (self.zoomScale < self.minimumZoomScale)
					[self setZoomScale:self.minimumZoomScale animated:YES];
				else if (self.zoomScale > self.maximumZoomScale)
					[self setZoomScale:self.maximumZoomScale animated:YES];
			}
			break;
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
	[self bddr_centerContent];
}

#pragma mark - Calculated Rectangles

- (CGRect)bddr_visibleRect {
	UIView *zoomView = [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)] ? [self.delegate viewForZoomingInScrollView:self] : self;
	return [self convertRect:self.bounds toView:zoomView];
}

- (CGRect)bddr_zoomRectForZoomScale:(CGFloat)zoomScale center:(CGPoint)center {
	CGSize boundsSize = self.bounds.size;
	CGRect zoomRect;
	
	zoomRect.size.width = boundsSize.width / zoomScale;
	zoomRect.size.height = boundsSize.height / zoomScale;
	zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0f);
	zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0f);
	
	return zoomRect;
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

- (BOOL)bddr_centersContent {
	return [objc_getAssociatedObject(self, @selector(bddr_centersContent)) boolValue];
}

- (void)setBddr_centersContent:(BOOL)centersContent {
	objc_setAssociatedObject(self, @selector(bddr_centersContent), @(centersContent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self bddr_centerContent];
}

- (BOOL)bddr_doubleTapZoomInEnabled {
	return [objc_getAssociatedObject(self, @selector(bddr_doubleTapZoomInEnabled)) boolValue];
}

- (void)setBddr_doubleTapZoomInEnabled:(BOOL)doubleTapZoomInEnabled {
	objc_setAssociatedObject(self, @selector(bddr_doubleTapZoomInEnabled), @(doubleTapZoomInEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self bddr_addOrRemoveDoubleTapZoomInGestureRecognizer];
}

- (BOOL)bddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale {
	NSNumber *doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScaleNumber = objc_getAssociatedObject(self, @selector(bddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale));
	
	if (!doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScaleNumber) {
		doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScaleNumber = @(YES);
		objc_setAssociatedObject(self, @selector(bddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale), doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScaleNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return [doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScaleNumber boolValue];
}

- (void)setBddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale:(BOOL)bddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale {
	objc_setAssociatedObject(self, @selector(bddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale), @(bddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITapGestureRecognizer *)bddr_doubleTapZoomInGestureRecognizer {
	return objc_getAssociatedObject(self, @selector(bddr_doubleTapZoomInGestureRecognizer));
}

- (void)setBddr_doubleTapZoomInGestureRecognizer:(UITapGestureRecognizer *)doubleTapZoomInGestureRecognizer {
	objc_setAssociatedObject(self, @selector(bddr_doubleTapZoomInGestureRecognizer), doubleTapZoomInGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bddr_twoFingerZoomOutEnabled {
	return [objc_getAssociatedObject(self, @selector(bddr_twoFingerZoomOutEnabled)) boolValue];
}

- (void)setBddr_twoFingerZoomOutEnabled:(BOOL)twoFingerZoomOutEnabled {
	objc_setAssociatedObject(self, @selector(bddr_twoFingerZoomOutEnabled), @(twoFingerZoomOutEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self bddr_addOrRemoveTwoFingerZoomOutGestureRecognizer];
}

- (UITapGestureRecognizer *)bddr_twoFingerZoomOutGestureRecognizer {
	return objc_getAssociatedObject(self, @selector(bddr_twoFingerZoomOutGestureRecognizer));
}

- (void)setBddr_twoFingerZoomOutGestureRecognizer:(UITapGestureRecognizer *)twoFingerZoomOutGestureRecognizer {
	objc_setAssociatedObject(self, @selector(bddr_twoFingerZoomOutGestureRecognizer), twoFingerZoomOutGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bddr_oneFingerZoomEnabled {
	return [objc_getAssociatedObject(self, @selector(bddr_oneFingerZoomEnabled)) boolValue];
}

- (void)setBddr_oneFingerZoomEnabled:(BOOL)oneFingerZoomEnabled {
	objc_setAssociatedObject(self, @selector(bddr_oneFingerZoomEnabled), @(oneFingerZoomEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self bddr_addOrRemoveOneFingerZoomGestureRecognizer];
}

- (BDDROneFingerZoomGestureRecognizer *)bddr_oneFingerZoomGestureRecognizer {
	return objc_getAssociatedObject(self, @selector(bddr_oneFingerZoomGestureRecognizer));
}

- (void)setBddr_oneFingerZoomGestureRecognizer:(BDDROneFingerZoomGestureRecognizer *)oneFingerZoomGestureRecognizer {
	objc_setAssociatedObject(self, @selector(bddr_oneFingerZoomGestureRecognizer), oneFingerZoomGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)bddr_zoomScaleStepFactor {
	NSNumber *zoomScaleStepFactorNumber = objc_getAssociatedObject(self, @selector(bddr_zoomScaleStepFactor));
	
	if (!zoomScaleStepFactorNumber) {
		zoomScaleStepFactorNumber = @(1.5f);
		objc_setAssociatedObject(self, @selector(bddr_zoomScaleStepFactor), zoomScaleStepFactorNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return [zoomScaleStepFactorNumber floatValue];
}

- (void)setBddr_zoomScaleStepFactor:(CGFloat)zoomScaleStepFactor {
	zoomScaleStepFactor = MAX(1.0f, zoomScaleStepFactor);
	objc_setAssociatedObject(self, @selector(bddr_zoomScaleStepFactor), @(zoomScaleStepFactor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
