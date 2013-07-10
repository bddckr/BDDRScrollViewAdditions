BDDRScrollViewExtensions
=========================================

`UIScrollView` category to center content, add getters for animating properties.

Adds `zoomScale` and `contentOffset` getters that work when an animation is running on the `UIScrollView`.
This is especially useful if you use an invisible `UIScrollView` in your OpenGL View to scroll/zoom content: In your game loop you just poll the values to position and scale your rendered content.

Also adds a `centerContent` property so the content is always centered, even when zooming out.
