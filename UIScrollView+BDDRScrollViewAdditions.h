#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BDDROneFingerZoomGestureRecognizer;


/*!
 * \brief \c UIScrollView category to center content, enable additional zoom gestures and add getters for animated properties.
 */
@interface UIScrollView (BDDRScrollViewAdditions)

/*!
 * \brief A Boolean value that determines whether the receiver's content view is centered.
 * \details Setting the value of this property to \c YES centers the receiver's content view and setting it to \c NO stops the centering.
 * \details The default value is \c NO.
 * \attention The receiver's \c contentInset is added to a calculated \c UIEdgeInsets that centers the content view.
 */
@property (nonatomic, assign) BOOL bddr_centersContent;

/*!
 * \brief A Boolean value that determines whether zooming in by double-tapping is enabled.
 * \details If the value of this property is \c YES, the scroll view zooms in the content when the user taps two times with one finger:
 * \code self.zoomScale *= self.bddr_zoomScaleStepFactor; \endcode
 * \details The default value is \c NO.
 * \attention When zooming is disabled, the scroll view does not enable zooming via this property.
 * See the documentation of \c UIScrollView on how to enable zooming.
 * \see bddr_zoomScaleStepFactor, bddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale, bddr_doubleTapZoomInGestureRecognizer
 */
@property (nonatomic, assign) BOOL bddr_doubleTapZoomInEnabled;

/*!
 * \brief A Boolean value that determines whether zooming to \c minimumZoomScale when double-tapping at \c maximumZoomScale is enabled.
 * \details If the value of this property is \c YES, the scroll view zooms to \c minimumZoomScale when the user taps two times with one finger 
 * and \c zoomScale is equal to \c maximumZoomScale.
 * \details The default value is \c YES.
 * \see minimumZoomScale, maximumZoomScale, zoomScale
 */
@property (nonatomic, assign) BOOL bddr_doubleTapZoomsToMinimumZoomScaleWhenAtMaximumZoomScale;

/*!
 * \brief The underlying gesture recognizer for double-tap-zoom-in gestures. (read-only)
 * \details Your application accesses this property when it wants to more precisely control which double-tap-zoom-in gestures are
 * recognized by the scroll view.
 * \details This property is \c nil if \c bddr_doubleTapZoomInEnabled is \c NO.
 * \see bddr_doubleTapZoomInEnabled
 */
@property (nonatomic, strong, readonly) UITapGestureRecognizer *bddr_doubleTapZoomInGestureRecognizer;

/*!
 * \brief A Boolean value that determines whether zooming out by two-finger-tapping is enabled.
 * \details If the value of this property is \c YES, the scroll view zooms out the content when the user taps with two fingers:
 * \code self.zoomScale /= self.bddr_zoomScaleStepFactor; \endcode
 * \details The default value is \c NO.
 * \attention When zooming is disabled, the scroll view does not enable zooming via this property.
 See the documentation of \c UIScrollView on how to enable zooming.
 * \see bddr_zoomScaleStepFactor, bddr_twoFingerZoomOutGestureRecognizer
 */
@property (nonatomic, assign) BOOL bddr_twoFingerZoomOutEnabled;

/*!
 * \brief The underlying gesture recognizer for two-finger-zoom-out gestures. (read-only)
 * \details Your application accesses this property when it wants to more precisely control which two-finger-zoom-out gestures are
 * recognized by the scroll view.
 * \details This property is \c nil if \c bddr_twoFingerZoomOutEnabled is \c NO.
 * \see bddr_twoFingerZoomOutEnabled
 */
@property (nonatomic, strong, readonly) UITapGestureRecognizer *bddr_twoFingerZoomOutGestureRecognizer;

/*!
 * \brief A Boolean value that determines whether zooming with one finger is enabled.
 * \details If the value of this property is \c YES, the scroll view zooms the content when the user double taps and then moves the finger.
 * This uses \c bddr_zoomScaleStepFactor for the zooming and respects \c bouncesZoom.
 * \details The default value is \c NO.
 * \attention When zooming is disabled, the scroll view does not enable zooming via this property.
 * See the documentation of \c UIScrollView on how to enable zooming.
 * \see bddr_zoomScaleStepFactor, bddr_oneFingerZoomGestureRecognizer, bouncesZoom
 */
@property (nonatomic, assign) BOOL bddr_oneFingerZoomEnabled;

/*!
 * \brief The underlying gesture recognizer for one-finger-zoom gestures. (read-only)
 * \details Your application accesses this property when it wants to more precisely control which one-finger-zoom gestures are
 * recognized by the scroll view.
 * \details This property is \c nil if \c bddr_oneFingerZoomEnabled is \c NO.
 * \see bddr_oneFingerZoomEnabled
 */
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *bddr_oneFingerZoomGestureRecognizer;

/*!
 * \brief A floating-point value that specifies the scale factor applied to the scroll view's \c zoomScale when double-tap-zoom-in,
 * two-finger-zoom-out or one-finger-zoom gestures occur.
 * \details This value determines by how much the receiver's \c zoomScale is changed.
 * \details The default value is \c 1.5.
 * \see bddr_doubleTapZoomInEnabled, bddr_twoFingerZoomOutEnabled, bddr_oneFingerZoomEnabled
 */
@property (nonatomic, assign) CGFloat bddr_zoomScaleStepFactor;

/*!
 * \brief The visible rectangle, which describes the content view's location and size in the receiver's coordinate system.
 */
@property (nonatomic, assign, readonly) CGRect bddr_visibleRect;

/*!
 * \brief Calculates a rectangle for a specified zoom scale and center point in the receiver's coordinate system.
 * \param zoomScale The zoom scale of the receiver for the calculation of the returned rectangle.
 * \param center The center of the returned rectangle.
 * \returns A rectangle defining an area of the content view, centered at \c center and scaled by \c zoomScale.
 */
- (CGRect)bddr_zoomRectForZoomScale:(CGFloat)zoomScale center:(CGPoint)center;

/*!
 * \brief The receiver's \c contentOffset property, during animations. (read-only)
 * \details \c contentOffset returns the wrong value if the receiver is animating, for example when \c zoomBouncing is \c YES.
 * \see contentOffset
 */
@property (nonatomic, assign, readonly) CGPoint bddr_presentationLayerContentOffset;

/*!
 * \brief The receiver's \c contentSize property, during animations. (read-only)
 * \details \c contentSize returns the wrong value if the receiver is animating, for example when \c zoomBouncing is \c YES.
 * \see contentSize
 */
@property (nonatomic, assign, readonly) CGSize bddr_presentationLayerContentSize;

/*!
 * \brief The receiver's \c zoomScale property, during animations. (read-only)
 * \details \c zoomScale returns the wrong value if the receiver is animating, for example when \c zoomBouncing is \c YES.
 * \see zoomScale
 */
@property (nonatomic, assign, readonly) CGFloat bddr_presentationLayerZoomScale;

@end
