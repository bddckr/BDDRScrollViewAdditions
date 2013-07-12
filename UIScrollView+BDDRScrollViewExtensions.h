#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIScrollView (BDDRScrollViewExtensions)

@property (nonatomic, assign) BOOL bddr_centersContent;

@property (nonatomic, assign, readonly) CGFloat bddr_presentationLayerZoomScale;
@property (nonatomic, assign, readonly) CGPoint bddr_presentationLayerContentOffset;
@property (nonatomic, assign, readonly) CGSize bddr_presentationLayerContentSize;

@end
