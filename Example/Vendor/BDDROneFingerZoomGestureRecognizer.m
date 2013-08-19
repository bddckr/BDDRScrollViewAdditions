#import "BDDROneFingerZoomGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface BDDROneFingerZoomGestureRecognizer ()

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) CGPoint initialLocationOnScreen;
@property (nonatomic, assign) CGFloat initialScale;
@property (nonatomic, assign) BOOL pressedLongEnough;

@end


@implementation BDDROneFingerZoomGestureRecognizer

#pragma mark - Initialization

- (instancetype)initWithTarget:(id)target action:(SEL)action {
	self = [super initWithTarget:target action:action];
	if (!self) return nil;
	
	_numberOfTapsRequired = 1;
	_allowableMovement = 10.0f;
	_scaleFactor = 1.5f;
	_scale = 1.0f;
	_minimumScale = 1.0f;
	_maximumScale = 1.0f;
	
	return self;
}

#pragma mark - Private Utility Methods

- (CGFloat)screenLocationYOfTouch:(UITouch *)touch {
	return [touch.window convertPoint:[touch locationInView:nil] toWindow:nil].y;
}

- (CGFloat)zoomRubberBandScaleForZoomScale:(CGFloat)scale minimumZoomScale:(CGFloat)minimumZoomScale maximumZoomScale:(CGFloat)maximumZoomScale {
	if (scale <= maximumZoomScale) {
		if (scale >= minimumZoomScale)
			return scale;
		else
			scale = minimumZoomScale / (2.0f - (scale / minimumZoomScale));
	} else
		scale = maximumZoomScale * (2.0f - (maximumZoomScale / scale));
	
	return scale;
}

- (CGFloat)zoomScaleForRubberBandScale:(CGFloat)zoomRubberBandScale minimumZoomScale:(CGFloat)minimumZoomScale maximumZoomScale:(CGFloat)maximumZoomScale {
	if (zoomRubberBandScale <= maximumZoomScale) {
		if (zoomRubberBandScale >= minimumZoomScale)
			return zoomRubberBandScale;
		else
			zoomRubberBandScale = minimumZoomScale * (2.0f - (minimumZoomScale / zoomRubberBandScale));
	} else
		zoomRubberBandScale = -(powf(maximumZoomScale, 2.0f) / (zoomRubberBandScale - (2.0f * maximumZoomScale)));
	
	return zoomRubberBandScale;
}

#pragma mark - Getting the Location of a Gesture

- (CGPoint)locationInView:(UIView *)view {
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	CGPoint locationOnScreen = (CGPoint){screenSize.width / 2.0f, screenSize.height / 2.0f};
	return [view convertPoint:[self.view.window convertPoint:locationOnScreen fromWindow:nil] fromView:self.view.window];
}

#pragma mark - Gesture Recognition

- (void)handleTimer:(NSTimer *)timer {
	self.pressedLongEnough = YES;
	self.timer = nil;
}

- (void)reset {
	[super reset];
	
	[self.timer invalidate];
	self.timer = nil;
	self.initialLocationOnScreen = CGPointZero;
	self.initialScale = 1.0f;
	self.pressedLongEnough = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	if (self.state == UIGestureRecognizerStatePossible && [touches count] == 1 && touch.tapCount == self.numberOfTapsRequired + 1) {
		NSTimer *timer = [NSTimer timerWithTimeInterval:self.minimumPressDuration target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
		
		self.timer = timer;
		self.initialLocationOnScreen = [touch.window convertPoint:[touch locationInView:nil] toWindow:nil];
	} else if (self.state != UIGestureRecognizerStateFailed)
		self.state = UIGestureRecognizerStateCancelled;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	if (self.state != UIGestureRecognizerStatePossible &&
		self.state != UIGestureRecognizerStateBegan &&
		self.state != UIGestureRecognizerStateChanged) return;
	
	UITouch *touch = [touches anyObject];
	if (touch.tapCount != self.numberOfTapsRequired + 1) return;
	
	CGPoint currentLocationOnScreen = [touch.window convertPoint:[touch locationInView:nil] toWindow:nil];
	if (self.state == UIGestureRecognizerStatePossible) {
		if (self.pressedLongEnough)
			self.state = UIGestureRecognizerStateBegan;
		else {
			CGFloat movedDistance = sqrtf(powf(currentLocationOnScreen.x - self.initialLocationOnScreen.x, 2.0f) +
										  powf(currentLocationOnScreen.y - self.initialLocationOnScreen.y, 2.0f));
			if (movedDistance > self.allowableMovement)
				self.state = UIGestureRecognizerStateFailed;
		}
	} else if (self.state == UIGestureRecognizerStateBegan) {
		self.initialScale = self.scale;
		self.state = UIGestureRecognizerStateChanged;
	} else if (self.state == UIGestureRecognizerStateChanged) {
		CGFloat movedDistance = self.initialLocationOnScreen.y - currentLocationOnScreen.y;
		CGFloat movedPercent = ABS(movedDistance) / [UIScreen mainScreen].bounds.size.height;
		CGFloat scalePercent = 1.0f + (self.scaleFactor - 1.0f) * movedPercent;
		CGFloat newScale = self.initialScale * (movedDistance > 0.0f ? scalePercent : 1.0f / scalePercent);
		
		if (self.bouncesScale)
			self.scale = [self zoomRubberBandScaleForZoomScale:newScale minimumZoomScale:self.minimumScale maximumZoomScale:self.maximumScale];
		else
			self.scale = newScale;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	if (self.state == UIGestureRecognizerStateBegan)
		self.state = UIGestureRecognizerStateCancelled;
	else if (self.state == UIGestureRecognizerStateChanged)
		self.state = UIGestureRecognizerStateEnded;
	else
		self.state = UIGestureRecognizerStateFailed;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	
	if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged)
		self.state = UIGestureRecognizerStateCancelled;
	else
		self.state = UIGestureRecognizerStateFailed;
}

#pragma mark - Interaction with other UIGestureRecognizers

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
	if ([preventedGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]])
		return NO;
	else
		return [super canPreventGestureRecognizer:preventedGestureRecognizer];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
- (BOOL)shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
		return YES;
	else {
		if ([[self class] instancesRespondToSelector:_cmd])
			return [super shouldBeRequiredToFailByGestureRecognizer:otherGestureRecognizer];
		else
			return NO;
	}
}
#endif

#pragma mark - Getters and Setters

- (void)setScaleFactor:(CGFloat)scaleFactor {
	_scaleFactor = MAX(1.0f, scaleFactor);
}

@end
