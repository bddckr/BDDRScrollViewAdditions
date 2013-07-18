#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 * \brief \c UIScrollView category to center content and add getters for animated properties.
 */
@interface UIScrollView (BDDRScrollViewExtensions)

/*!
 * \brief Sets the \c bddr_centersContentHorizontally and \c bddr_centersContentVertically properties of the receiver.
 * \param centersContent The new value to use for the receiver's \c bddr_centersContentHorizontally and \c bddr_centersContentVertically properties.
 * \attention The receiver's \c contentInset is added to a calculated \c UIEdgeInsets that centers the content view.
 * \see bddr_centersContentHorizontally, bddr_centersContentVertically
 */
- (void)bddr_setCentersContent:(BOOL)centersContent;

/*!
 * \brief A Boolean value that determines whether the receiver's content view is centered horizontally.
 * \details Setting the value of this property to \c YES centers the receiver's content view horizontally and setting it to \c NO stops the horizontal centering.
 * \details The default value is \c NO.
 * \attention The receiver's \c contentInset is added to a calculated \c UIEdgeInsets that centers the content view horizontally.
 * \see bddr_centersContentVertically
 */
@property (nonatomic, assign) BOOL bddr_centersContentHorizontally;

/*!
 * \brief A Boolean value that determines whether the receiver's content view is centered vertically.
 * \details Setting the value of this property to \c YES centers the receiver's content view vertically and setting it to \c NO stops the vertical centering.
 * \details The default value is \c NO.
 * \attention The receiver's \c contentInset is added to a calculated \c UIEdgeInsets that centers the content view vertically.
 * \see bddr_centersContentHorizontally
 */
@property (nonatomic, assign) BOOL bddr_centersContentVertically;

/*!
 * \brief A Boolean value that determines whether zooming in by double-tapping is enabled.
 * \details If the value of this property is \c YES, the scroll view zooms in the content when the user taps two times with one finger: \code self.zoomScale *= self.bddr_zoomScaleStepFactor; \endcode
 * \details The default value is \c NO.
 * \attention When zooming is disabled, the scroll view does not enable zooming via this property. See the documentation of \c UIScrollView on how to enable zooming.
 * \see bddr_zoomScaleStepFactor, bddr_doubleTapZoomInGestureRecognizer
 */
@property (nonatomic, assign) BOOL bddr_doubleTapZoomInEnabled;

/*!
 * \brief The underlying gesture recognizer for double-tap-zoom-in gestures. (read-only)
 * \details Your application accesses this property when it wants to more precisely control which double-tap-zoom-in gestures are recognized by the scroll view.
 * \details This property is \c nil if \c bddr_doubleTapZoomInEnabled is set to \c NO.
 * \see bddr_doubleTapZoomInEnabled
 */
@property (nonatomic, strong, readonly) UITapGestureRecognizer *bddr_doubleTapZoomInGestureRecognizer;

/*!
 * \brief A Boolean value that determines whether zooming out by two-finger-tapping is enabled.
 * \details If the value of this property is \c YES, the scroll view zooms out the content when the user taps with two fingers: \code self.zoomScale /= self.bddr_zoomScaleStepFactor; \endcode
 * \details The default value is \c NO.
 * \attention When zooming is disabled, the scroll view does not enable zooming via this property. See the documentation of \c UIScrollView on how to enable zooming.
 * \see bddr_zoomScaleStepFactor, bddr_twoFingerZoomOutGestureRecognizer
 */
@property (nonatomic, assign) BOOL bddr_twoFingerZoomOutEnabled;

/*!
 * \brief The underlying gesture recognizer for two-finger-zoom-out gestures. (read-only)
 * \details Your application accesses this property when it wants to more precisely control which two-finger-zoom-out gestures are recognized by the scroll view.
 * \details This property is \c nil if \c bddr_twoFingerZoomOutEnabled is set to \c NO.
 * \see bddr_twoFingerZoomOutEnabled
 */
@property (nonatomic, strong, readonly) UITapGestureRecognizer *bddr_twoFingerZoomOutGestureRecognizer;

/*!
 * \brief A floating-point value that specifies the scale factor applied to the scroll view's \c zoomScale when double-tap-zoom-in or two-finger-zoom-out gestures occur.
 * \details This value determines by how much the receiver's \c zoomScale is changed.
 * \details The default value is \c 1.5.
 * \see bddr_doubleTapZoomInEnabled, bddr_twoFingerZoomOutEnabled
 */
@property (nonatomic, assign) CGFloat bddr_zoomScaleStepFactor;

/*!
 * \brief A Boolean value that determines whether zooming with one finger is enabled.
 * \details If the value of this property is \c YES, the scroll view zooms the content when the user double taps and then moves the finger.
 * \details The default value is \c NO.
 * \attention When zooming is disabled, the scroll view does not enable zooming via this property. See the documentation of \c UIScrollView on how to enable zooming.
 * \see bddr_oneFingerZoomGestureRecognizer
 */
@property (nonatomic, assign) BOOL bddr_oneFingerZoomEnabled;

/*!
 * \brief The underlying gesture recognizer for one-finger-zoom gestures. (read-only)
 * \details Your application accesses this property when it wants to more precisely control which one-finger-zoom gestures are recognized by the scroll view.
 * \details This property is \c nil if \c bddr_oneFingerZoomEnabled is set to \c NO.
 * \see bddr_oneFingerZoomEnabled
 */
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *bddr_oneFingerZoomGestureRecognizer;

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
