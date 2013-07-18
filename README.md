# BDDRScrollViewExtensions

## Description

`UIScrollView` category to center content, enable one finger zooming and add getters for animated properties.

This category adds `zoomScale`, `contentOffset` and `contentSize` getters that return correct values when an animation is running on the `UIScrollView`. These new properties are not KVO compliant but can be polled repeatedly.
This is especially useful if you use an invisible `UIScrollView` in your OpenGL View to scroll/zoom content: In your game loop you just poll the values to position and scale your rendered content.

Enable one finger zooming ([like in the Google Maps iOS app](http://littlebigdetails.com/post/51559128905/)) with this category by setting `oneFingerZoomEnabled` to `YES`. You can customize the gesture recognizer by accessing the `oneFingerZoomGestureRecognizer` property.

It also adds properties to center the content view, even when zooming out and having the `UIScrollView` bouncing. This also works for the view returned by `-viewForZoomingInScrollView:` of the `UIScrollViewDelegate` when zooming.

## Installation

    $ cd /path/to/top/of/your/project
    $ git submodule add git://github.com/bddckr/BDDRScrollViewExtensions.git BDDRScrollViewExtensions
    $ git submodule init && git submodule update

## Reasons for Existence

+ `UIScrollView` defines `zoomScale`, `contentOffset` and `contentSize` but these properties don't always return the correct values when `UIScrollView` is animating, for example when `zoomBouncing` is `YES`.
+ Zooming with two fingers is cumbersome, `oneFingerZoomEnabled` enables the user to zoom with just one finger.
+ Centering the content view is not done by default, so `-setCentersContent:`, `centersContentHorizontally` and `centersContentVertically` make this configurable.

## Contact
Follow Christopher - Marcel Böddecker ([@bddckr](https://twitter.com/bddckr)) on Twitter.

## Copyright and License
Copyright (c) 2013 Christopher - Marcel Böddecker  
Licensed under [The MIT License (MIT)](http://choosealicense.com/licenses/mit).
