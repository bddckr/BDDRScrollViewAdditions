#BDDRScrollViewExtensions

##Description

`UIScrollView` category to center content, add getters for animating properties.

Adds `zoomScale` and `contentOffset` getters that work when an animation is running on the `UIScrollView`.
This is especially useful if you use an invisible `UIScrollView` in your OpenGL View to scroll/zoom content: In your game loop you just poll the values to position and scale your rendered content.

Also adds a `centerContent` property so the content is always centered, even when zooming out.

# Installation

    $ cd /path/to/top/of/your/project
    $ git submodule add git://github.com/bddckr/BDDRScrollViewExtensions.git BDDRScrollViewExtensions
    $ git submodule init && git submodule update

#Reasons for Existence

`UIScrollView` defines `contentOffset` and `zoomScale` but this properties don't always return the correct values when `UIScrollView` is animating. These new properties are not KVO compliant but can be polled repeatedly.
`UIScrollView` isn't centering its subviews by default. Set `centersContent` to `YES` and it will center the content view, which means this also works for the view returned by `-viewForZoomingInScrollView:` of the `UIScrollViewDelegate` when zooming.
