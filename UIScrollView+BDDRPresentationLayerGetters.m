#import "UIScrollView+BDDRPresentationLayerGetters.h"

@implementation UIScrollView (BDDRPresentationLayerGetters)

#pragma mark - Getters

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
	return CGPointApplyAffineTransform(presentationLayer.bounds.origin, CGAffineTransformMakeScale(-1, -1));
}

@end
