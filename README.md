# BDDRScrollViewExtensions

## Description

`UIScrollView` category to center content and add getters for animated properties.

This category adds `zoomScale`, `contentOffset` and `contentSize` getters that return correct values when an animation is running on the `UIScrollView`. These new properties are not KVO compliant but can be polled repeatedly.
This is especially useful if you use an invisible `UIScrollView` in your OpenGL View to scroll/zoom content: In your game loop you just poll the values to position and scale your rendered content.

It also adds properties to center the content view, even when zooming out. This also works for the view returned by `-viewForZoomingInScrollView:` of the `UIScrollViewDelegate` when zooming.

## Installation

    $ cd /path/to/top/of/your/project
    $ git submodule add git://github.com/bddckr/BDDRScrollViewExtensions.git BDDRScrollViewExtensions
    $ git submodule init && git submodule update

## Reasons for Existence

`UIScrollView` defines `zoomScale`, `contentOffset` and `contentSize` but these properties don't always return the correct values when `UIScrollView` is animating, for example when `zoomBouncing` is `YES`.
`UIScrollView` isn't centering its subviews by default, `-setCentersContent:`, `centersContentHorizontally` and `centersContentVertically` make this configurable.

## Contact
Follow Christopher - Marcel Böddecker ([@bddckr](https://twitter.com/bddckr)) on Twitter.

## Copyright and License
Copyright (c) 2013 Christopher - Marcel Böddecker  
Licensed under [The MIT License (MIT)](http://choosealicense.com/licenses/mit).
