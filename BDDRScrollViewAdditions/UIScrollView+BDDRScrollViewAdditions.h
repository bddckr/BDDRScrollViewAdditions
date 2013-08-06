@class BDDROneFingerZoomGestureRecognizer;


/**
 * `UIScrollView` category to center content, enable additional zoom gestures and add getters for animated properties.
 */
@interface UIScrollView (BDDRScrollViewAdditions)

/**
 * A Boolean value that determines whether the receiver's content view is centered.
 *
 * Setting the value of this property to `YES` centers the receiver's content view and setting it to `NO` stops the centering.
 * The default value is `NO`.
 */
@property (nonatomic, assign) BOOL bddr_centersContent;

/**
 * A Boolean value that determines whether zooming in by double-tapping is enabled.
 *
 * If the value of this property is `YES`, the scroll view zooms in the content when the user taps two times with one finger:
 * @code self.zoomScale *= self.bddr_zoomScaleStepFactor; @endcode
 * The default value is `NO`.
 *
 * @warning When zooming is disabled, the scroll view does not enable zooming via this property.
 * See the documentation of `UIScrollView` on how to enable zooming.
 *
 * @see bddr_zoomScaleStepFactor, bddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale, bddr_doubleTapZoomInGestureRecognizer
 */
@property (nonatomic, assign) BOOL bddr_doubleTapZoomInEnabled;

/**
 * A Boolean value that determines whether zooming to `minimumZoomScale` when double-tapping at `maximumZoomScale` is enabled.
 *
 * If the value of this property is `YES`, the scroll view zooms to `minimumZoomScale` when the user taps two times with one finger
 * and `zoomScale` is equal to `maximumZoomScale`.
 * The default value is `YES`.
 *
 * @see minimumZoomScale, maximumZoomScale, zoomScale
 */
@property (nonatomic, assign) BOOL bddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale;

/**
 * The underlying gesture recognizer for double-tap-zoom-in gestures. (read-only)
 *
 * Your application accesses this property when it wants to more precisely control which double-tap-zoom-in gestures are
 * recognized by the scroll view.
 * This property is `nil` if `bddr_doubleTapZoomInEnabled` is `NO`.
 *
 * @see bddr_doubleTapZoomInEnabled
 */
@property (nonatomic, strong, readonly) UITapGestureRecognizer *bddr_doubleTapZoomInGestureRecognizer;

/**
 * A Boolean value that determines whether zooming out by two-finger-tapping is enabled.
 *
 * If the value of this property is `YES`, the scroll view zooms out the content when the user taps with two fingers:
 * @code self.zoomScale /= self.bddr_zoomScaleStepFactor; @endcode
 * The default value is `NO`.
 *
 * @warning When zooming is disabled, the scroll view does not enable zooming via this property.
 * See the documentation of `UIScrollView` on how to enable zooming.
 *
 * @see bddr_zoomScaleStepFactor, bddr_twoFingerZoomOutGestureRecognizer
 */
@property (nonatomic, assign) BOOL bddr_twoFingerZoomOutEnabled;

/**
 * The underlying gesture recognizer for two-finger-zoom-out gestures. (read-only)
 *
 * Your application accesses this property when it wants to more precisely control which two-finger-zoom-out gestures are
 * recognized by the scroll view.
 * This property is `nil` if `bddr_twoFingerZoomOutEnabled` is `NO`.
 *
 * @see bddr_twoFingerZoomOutEnabled
 */
@property (nonatomic, strong, readonly) UITapGestureRecognizer *bddr_twoFingerZoomOutGestureRecognizer;

/**
 * A Boolean value that determines whether zooming with one finger is enabled.
 *
 * If the value of this property is `YES`, the scroll view zooms the content when the user double taps and then moves the finger.
 * This uses `bddr_zoomScaleStepFactor` for the zooming and respects `bouncesZoom`.
 * The default value is `NO`.
 *
 * @warning When zooming is disabled, the scroll view does not enable zooming via this property.
 * See the documentation of `UIScrollView` on how to enable zooming.
 *
 * @see bddr_zoomScaleStepFactor, bddr_oneFingerZoomGestureRecognizer, bouncesZoom
 */
@property (nonatomic, assign) BOOL bddr_oneFingerZoomEnabled;

/**
 * The underlying gesture recognizer for one-finger-zoom gestures. (read-only)
 *
 * Your application accesses this property when it wants to more precisely control which one-finger-zoom gestures are
 * recognized by the scroll view.
 * This property is `nil` if `bddr_oneFingerZoomEnabled` is `NO`.
 *
 * @see bddr_oneFingerZoomEnabled
 */
@property (nonatomic, strong, readonly) BDDROneFingerZoomGestureRecognizer *bddr_oneFingerZoomGestureRecognizer;

/**
 * A floating-point value that specifies the scale factor applied to the scroll view's `zoomScale` when double-tap-zoom-in,
 * two-finger-zoom-out or one-finger-zoom gestures occur.
 *
 * This value determines by how much the receiver's `zoomScale` is changed.
 * The default value is `1.5`.
 *
 * @see bddr_doubleTapZoomInEnabled, bddr_twoFingerZoomOutEnabled, bddr_oneFingerZoomEnabled
 */
@property (nonatomic, assign) CGFloat bddr_zoomScaleStepFactor;

/**
 * The visible rectangle, which describes the content view's location and size in the receiver's coordinate system.
 */
@property (nonatomic, assign, readonly) CGRect bddr_visibleRect;

/**
 * Calculates a rectangle for a specified zoom scale and center point in the receiver's coordinate system.
 *
 * @param zoomScale The zoom scale of the receiver for the calculation of the returned rectangle.
 * @param center The center of the returned rectangle.
 *
 * @return A rectangle defining an area of the content view, centered at `center` and scaled by `zoomScale`.
 */
- (CGRect)bddr_zoomRectForZoomScale:(CGFloat)zoomScale center:(CGPoint)center;

/**
 * The receiver's `contentOffset` property, during animations. (read-only)
 *
 * `contentOffset` returns the wrong value if the receiver is animating, for example when `zoomBouncing` is `YES`.
 *
 * @see contentOffset
 */
@property (nonatomic, assign, readonly) CGPoint bddr_presentationLayerContentOffset;

/**
 * The receiver's `contentSize` property, during animations. (read-only)
 *
 * `contentSize` returns the wrong value if the receiver is animating, for example when `zoomBouncing` is `YES`.
 *
 * @see contentSize
 */
@property (nonatomic, assign, readonly) CGSize bddr_presentationLayerContentSize;

/**
 * The receiver's `zoomScale` property, during animations. (read-only)
 *
 * `zoomScale` returns the wrong value if the receiver is animating, for example when `zoomBouncing` is `YES`.
 *
 * @see zoomScale
 */
@property (nonatomic, assign, readonly) CGFloat bddr_presentationLayerZoomScale;

@end
