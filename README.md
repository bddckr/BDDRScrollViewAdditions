# BDDRScrollViewAdditions

## Description

`UIScrollView` category to center content, enable additional zoom gestures and add getters for animated properties.

This category adds properties to enable and configure:

+ Centering the content view, even when zooming out and having the `UIScrollView` bouncing. This also works for the view returned by `-viewForZoomingInScrollView:` of the `UIScrollViewDelegate` when zooming.

+ Double-tapping to zoom in, two-finger-tapping to zoom out and one-finger-zooming ([like in the Google Maps iOS app](http://littlebigdetails.com/post/51559128905/)). Properties to access the gesture recognizers are provided.

Additionally, this category adds `zoomScale`, `contentOffset` and `contentSize` getters that return correct values when an animation is running on the `UIScrollView`. These new properties are not KVO compliant but can be polled repeatedly.  
This is especially useful if you use an `UIScrollView` in your OpenGL View to scroll/zoom content: In your game loop you just poll the values to position and scale your rendered content.

## Installation

    $ cd /path/to/top/of/your/project
    $ git submodule add git://github.com/bddckr/BDDRScrollViewAdditions.git BDDRScrollViewAdditions
    $ git submodule update --init --recursive

## Reasons for Existence

+ Centering the content view is not done by default.

+ By default there is no support for double-tap-zoom-in, two-finger-zoom-out or one-finger-zoom gestures.

+ `UIScrollView` defines `zoomScale`, `contentOffset` and `contentSize` but these properties don't always return the correct values when `UIScrollView` is animating, for example when `zoomBouncing` is `YES`.

## Contact

Follow [@bddckr](https://twitter.com/bddckr) on Twitter.

## Copyright and License

Copyright (c) 2013 Christopher - Marcel Böddecker  
Licensed under [The MIT License (MIT)](http://choosealicense.com/licenses/mit).
