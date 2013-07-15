#import "UIScrollView+BDDRScrollViewExtensions.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

@implementation UIScrollView (BDDRScrollViewExtensions)

static void *const BDDRScrollViewExtensionsContentInsetAssociationKey = (void *)&BDDRScrollViewExtensionsContentInsetAssociationKey;
static void *const BDDRScrollViewExtensionsCentersContentHorizontallyAssociationKey = (void *)&BDDRScrollViewExtensionsCentersContentHorizontallyAssociationKey;
static void *const BDDRScrollViewExtensionsCentersContentVerticallyAssociationKey = (void *)&BDDRScrollViewExtensionsCentersContentVerticallyAssociationKey;

#pragma mark - Initializing the Class

+ (void)load {
	NSError *error;
	if (![self jr_swizzleMethod:@selector(setContentOffset:) withMethod:@selector(bddr_setContentOffset:) error:&error])
		NSLog(@"%@", [error localizedDescription]);
	if (![self jr_swizzleMethod:@selector(contentInset) withMethod:@selector(bddr_contentInset) error:&error])
		NSLog(@"%@", [error localizedDescription]);
	if (![self jr_swizzleMethod:@selector(setContentInset:) withMethod:@selector(bddr_setContentInset:) error:&error])
		NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - Helper Methods

- (void)bddr_centerContent {
	CGSize contentSize = self.contentSize;
	CGSize boundsSize = self.bounds.size;
	UIEdgeInsets contentInsets = self.contentInset;
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

- (void)bddr_refreshContentOffsetIfNeeded {
	if (!self.tracking)
		[self bddr_centerContent];
}

#pragma mark - Overridden Getters and Setters

- (void)bddr_setContentOffset:(CGPoint)contentOffset {
	[self bddr_setContentOffset:contentOffset];
	[self bddr_centerContent];
}

- (UIEdgeInsets)bddr_contentInset {
	return [objc_getAssociatedObject(self, BDDRScrollViewExtensionsContentInsetAssociationKey) UIEdgeInsetsValue];
}

- (void)bddr_setContentInset:(UIEdgeInsets)contentInset {
	objc_setAssociatedObject(self, BDDRScrollViewExtensionsContentInsetAssociationKey, [NSValue valueWithUIEdgeInsets:contentInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self bddr_refreshContentOffsetIfNeeded];
}

#pragma mark - Getters and Setters

- (void)bddr_setCentersContent:(BOOL)centersContent {
	self.bddr_centersContentHorizontally = centersContent;
	self.bddr_centersContentVertically = centersContent;
}

- (BOOL)bddr_centersContentHorizontally {
	return [objc_getAssociatedObject(self, BDDRScrollViewExtensionsCentersContentHorizontallyAssociationKey) boolValue];
}

- (void)setBddr_centersContentHorizontally:(BOOL)centersContentHorizontally {
	objc_setAssociatedObject(self, BDDRScrollViewExtensionsCentersContentHorizontallyAssociationKey, @(centersContentHorizontally), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self bddr_refreshContentOffsetIfNeeded];
}

- (BOOL)bddr_centersContentVertically {
	return [objc_getAssociatedObject(self, BDDRScrollViewExtensionsCentersContentVerticallyAssociationKey) boolValue];
}

- (void)setBddr_centersContentVertically:(BOOL)centersContentVertically {
	objc_setAssociatedObject(self, BDDRScrollViewExtensionsCentersContentVerticallyAssociationKey, @(centersContentVertically), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self bddr_refreshContentOffsetIfNeeded];
}

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

@end
