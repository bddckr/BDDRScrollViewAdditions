#import "UIScrollView+BDDRScrollViewExtensions.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

@implementation UIScrollView (BDDRScrollViewExtensions)

static void *const BDDRScrollViewExtensionsCentersContentAssociationKey = (void *)&BDDRScrollViewExtensionsCentersContentAssociationKey;

#pragma mark - Initializing the Class

+ (void)load {
	NSError *error;
	if (![self jr_swizzleMethod:@selector(setContentOffset:) withMethod:@selector(bddr_setContentOffset:) error:&error])
		NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - Getters and Setters

- (void)bddr_setContentOffset:(CGPoint)contentOffset {
	[self bddr_setContentOffset:contentOffset];
	
	if (!self.bddr_centersContent)
		return;
	
	CGSize contentSize = self.contentSize;
	CGSize boundsSize = self.bounds.size;
	
    CGFloat top = 0.0f;
	CGFloat left = 0.0f;
	
    if (contentSize.width < boundsSize.width)
        left = (boundsSize.width - contentSize.width) / 2.0f;
	
    if (contentSize.height < boundsSize.height)
        top = (boundsSize.height - contentSize.height) / 2.0f;
	
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

- (BOOL)bddr_centersContent {
	return [objc_getAssociatedObject(self, BDDRScrollViewExtensionsCentersContentAssociationKey) boolValue];
}

- (void)setBddr_centersContent:(BOOL)centersContent {
	BOOL centersContentCurrently = [objc_getAssociatedObject(self, BDDRScrollViewExtensionsCentersContentAssociationKey) boolValue];
	
	if (centersContentCurrently == centersContent)
		return;
	
	objc_setAssociatedObject(self, BDDRScrollViewExtensionsCentersContentAssociationKey, @(centersContent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	self.contentOffset = self.contentOffset;
}

- (CGFloat)bddr_presentationLayerZoomScale {
	if ([self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
		UIView *zoomView = [self.delegate viewForZoomingInScrollView:self];
		CALayer *zoomPresentationLayer = zoomView.layer.presentationLayer;
		
		return zoomPresentationLayer.transform.m11;
	} else
		return self.zoomScale;
}

- (CGPoint)bddr_presentationLayerContentOffset {
	CALayer *presentationLayer = self.layer.presentationLayer;
	return presentationLayer.bounds.origin;
}

@end
