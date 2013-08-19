#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * `UIGestureRecognizer` subclass to enable one-finger-zoom gestures.
 *
 * `BDDROneFingerZoomGestureRecognizer` is a concrete subclass of `UIGestureRecognizer` that looks for long-press gestures
 * followed by a move with one finger to calculate a scale factor. When the user moves the finger towards the bottom screen edge,
 * the conventional meaning is zoom-out; when the user moves the finger towards the top screen edge, the conventional meaning is zoom-in.
 *
 * One-finger-zoom gestures are continuous. The gesture begins (`UIGestureRecognizerStateBegan`) when one finger taps the specified
 * amount of times (`numberOfTapsRequired`), has been pressed for the specified period (`minimumPressDuration`) while not moving beyond the
 * allowable range of movement (`allowableMovement`), and then moves. The gesture changes (`UIGestureRecognizerStateChanged`) whenever the finger
 * moves, and it ends (`UIGestureRecognizerStateEnded`) when the finger is lifted.
 */
@interface BDDROneFingerZoomGestureRecognizer : UIGestureRecognizer

/**
 * The number of full taps required before the long-press gesture after which the gesture is recognized.
 *
 * The default value is `1`.
 */
@property (nonatomic, assign) NSUInteger numberOfTapsRequired;

/**
 * Time in seconds the finger must be held down for the gesture to be recognized.
 *
 * The default value is `0`.
 *
 * @see allowableMovement
 */
@property (nonatomic, assign) NSTimeInterval minimumPressDuration;

/**
 * A floating-point value that specifies the maximum movement on screen allowed before the gesture fails.
 *
 * Once recognized (after `minimumPressDuration`) there is no limit on finger movement for the remainder of the touch tracking.
 * The default value is `10`.
 *
 * @see minimumPressDuration
 */
@property (nonatomic, assign) CGFloat allowableMovement;

/**
 * A floating-point value that specifies the maximum scale factor to apply to `scale`.
 *
 * This value specifies the scale factor used to calculate `scale` when the user moves the finger from one screen edge
 * to the other (vertically only). For all movement in between the screen edges the receiver uses linear interpolation between `1` and this value.
 * The default value is `1.5`.
 *
 * @see scale
 */
@property (nonatomic, assign) CGFloat scaleFactor;

/**
 * A floating-point value that specifies the scale factor relative to the moved distance of the touch in screen coordinates.
 *
 * The scale value is an absolute value that varies over time. It is not the delta value from the last time that the scale was reported.
 * Apply the scale value to the state of the view when the gesture is first recognized (`UIGestureRecognizerStateBegan`) — do not
 * concatenate the value each time the handler is called.
 * The default value is `1`.
 *
 * @warning You should not change this value when the gesture changes (`UIGestureRecognizerStateChanged`).
 *
 * @see scaleFactor
 */
@property (nonatomic, assign) CGFloat scale;

/**
 * A Boolean value that determines whether the receiver adjusts `scale` when the scaling exceeds `minimumScale` or `maximumScale`.
 *
 * The default value is `NO`.
 *
 * @warning You should not change this value when the gesture changes (`UIGestureRecognizerStateChanged`).
 *
 * @see minimumScale, maximumScale
 */
@property (nonatomic, assign) BOOL bouncesScale;

/**
 * A floating-point value that specifies the minimum scale factor that can be applied to `scale`.
 *
 * This is only used when `bouncesScale` is `YES`.
 * The default value is `1`.
 *
 * @warning You should not change this value when the gesture changes (`UIGestureRecognizerStateChanged`).
 *
 * @see bouncesScale, maximumScale
 */
@property (nonatomic, assign) CGFloat minimumScale;

/**
 * A floating-point value that specifies the maximum scale factor that can be applied to `scale`.
 *
 * This is only used when `bouncesScale` is `YES`.
 * The default value is `1`.
 *
 * @warning You should not change this value when the gesture changes (`UIGestureRecognizerStateChanged`).
 *
 * @see bouncesScale, minimumScale
 */
@property (nonatomic, assign) CGFloat maximumScale;

@end
