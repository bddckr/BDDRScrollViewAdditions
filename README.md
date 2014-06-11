# BDDRScrollViewAdditions
[![The MIT License (MIT)](https://go-shields.herokuapp.com/license-MIT-blue.png)][MIT]
[![Platform](https://cocoapod-badges.herokuapp.com/p/BDDRScrollViewAdditions/badge.png)][CocoaDocs]
[![Version](https://cocoapod-badges.herokuapp.com/v/BDDRScrollViewAdditions/badge.png)][CocoaDocs]

## Description

`UIScrollView` category to center content, enable additional zoom gestures and add getters for animated properties.

This category adds properties to enable and configure:

+ Centering the content view, even when zooming out and having the `UIScrollView` bouncing. This also works for the view returned by `-viewForZoomingInScrollView:` of the `UIScrollViewDelegate` when zooming.

+ Double-tapping to zoom in, two-finger-tapping to zoom out and one-finger-zooming ([see BDDROneFingerZoomGestureRecognizer](https://github.com/bddckr/BDDROneFingerZoomGestureRecognizer)). Properties to access the gesture recognizers are provided.

Additionally, this category adds `zoomScale`, `contentOffset` and `contentSize` getters that return correct values when an animation is running on the `UIScrollView`. These new properties are not KVO compliant but can be polled repeatedly.  
This is especially useful if you use an `UIScrollView` in your OpenGL View to scroll/zoom content: In your game loop you just poll the values to position and scale your rendered content.

For more info see the [header].

<img src="https://github.com/bddckr/BDDRScrollViewAdditions/raw/master/Example.png" alt="Example" style="height: 400px;"/>

## Installation

Simply add the files in the `UIScrollView+BDDRScrollViewAdditions.h` and `UIScrollView+BDDRScrollViewAdditions.m` to your project or add `BDDRScrollViewAdditions` to your Podfile if you're using CocoaPods. Alternatively use the configured submodules.

To run the example project clone the repo and run `pod install` in the Example folder.

## Documentation

Everything is documented in the [header file][header]. A rendered version is available on [CocoaDocs].

## Reasons for Existence

+ Centering the content view is not done by default.

+ By default there is no support for double-tap-zoom-in, two-finger-zoom-out or one-finger-zoom gestures.

+ `UIScrollView` defines `zoomScale`, `contentOffset` and `contentSize` but these properties don't always return the correct values when `UIScrollView` is animating, for example when `zoomBouncing` is `YES`.

## Contact

Follow [@bddckr](https://twitter.com/bddckr) on Twitter.

## Copyright and License

Copyright (c) 2013-2014 Christopher - Marcel Böddecker  
Licensed under [The MIT License (MIT)][MIT].

[MIT]: http://choosealicense.com/licenses/mit
[CocoaDocs]: http://cocoadocs.org/docsets/BDDRScrollViewAdditions
[header]: https://github.com/bddckr/BDDRScrollViewAdditions/blob/master/BDDRScrollViewAdditions/UIScrollView+BDDRScrollViewAdditions.h
