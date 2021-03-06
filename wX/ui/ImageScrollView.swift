//
//  ImageScrollView.swift
//  Beauty
//
//  Created by Nguyen Cong Huy on 1/19/16.
//  Copyright © 2016 Nguyen Cong Huy. All rights reserved.
//

/*
 
 License as shown here: https://github.com/huynguyencong/ImageScrollView/blob/master/LICENSE
 
 The MIT License (MIT)
 
 Copyright (c) 2016 Huy Nguyen
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 
 */

import UIKit

open class ImageScrollView: UIScrollView {

    // static let kZoomInFactorFromMinWhenDoubleTap: CGFloat = 3 // was 2
    var kZoomInFactorFromMinWhenDoubleTap: CGFloat = 3.0
    var zoomView: UIImageView?
    var imageSize = CGSize.zero
    // following 2 were fileprivate
    var pointToCenterAfterResize = CGPoint.zero
    var scaleToRestoreAfterResize: CGFloat = 1.0
    var maxScaleFromMinScale: CGFloat = 5.0 // was 3.0
    // var idx = 0
    // var imageSized = false

    override open var frame: CGRect {
        willSet {
            if frame.equalTo(newValue) == false
                && newValue.equalTo(CGRect.zero) == false
                && imageSize.equalTo(CGSize.zero) == false {
                prepareToResize()
            }
        }

        didSet {
            if frame.equalTo(oldValue) == false
                && frame.equalTo(CGRect.zero) == false
                && imageSize.equalTo(CGSize.zero) == false {
                recoverFromResizing()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    fileprivate func initialize() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        decelerationRate = UIScrollView.DecelerationRate.fast
        delegate = self
    }

    func adjustFrameToCenter() {
        guard zoomView != nil else {
            return
        }
        var frameToCenter = zoomView!.frame
        // center horizontally
        if frameToCenter.size.width < bounds.width {
            frameToCenter.origin.x = (bounds.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        // center vertically
        if frameToCenter.size.height < bounds.height {
            frameToCenter.origin.y = (bounds.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        zoomView!.frame = frameToCenter
    }

    fileprivate func prepareToResize() {
        let boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        pointToCenterAfterResize = convert(boundsCenter, to: zoomView)
        scaleToRestoreAfterResize = zoomScale
        // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
        // allowable scale when the scale is restored.
        // if scaleToRestoreAfterResize <= minimumZoomScale + CGFloat(FLT_EPSILON) {
        if scaleToRestoreAfterResize <= minimumZoomScale + CGFloat(Float.ulpOfOne) {
            scaleToRestoreAfterResize = 0
        }
    }

    fileprivate func recoverFromResizing() {
        setMaxMinZoomScalesForCurrentBounds()
        // restore zoom scale, first making sure it is within the allowable range.
        let maxZoomScale = max(minimumZoomScale, scaleToRestoreAfterResize)
        zoomScale = min(maximumZoomScale, maxZoomScale)
        // restore center point, first making sure it is within the allowable range.
        // convert our desired center point back to our own coordinate space
        let boundsCenter = convert(pointToCenterAfterResize, to: zoomView)
        // calculate the content offset that would yield that center point
        var offset = CGPoint(x: boundsCenter.x - bounds.size.width/2.0, y: boundsCenter.y - bounds.size.height/2.0)
        // restore offset, adjusted to be within the allowable range
        let maxOffset = maximumContentOffset()
        let minOffset = minimumContentOffset()
        var realMaxOffset = min(maxOffset.x, offset.x)
        offset.x = max(minOffset.x, realMaxOffset)
        realMaxOffset = min(maxOffset.y, offset.y)
        offset.y = max(minOffset.y, realMaxOffset)
        contentOffset = offset
    }

    fileprivate func maximumContentOffset() -> CGPoint { CGPoint(x: contentSize.width - bounds.width, y: contentSize.height - bounds.height) }

    fileprivate func minimumContentOffset() -> CGPoint { CGPoint.zero }

    open func display(image: UIImage) {
        if let zoomView = zoomView {zoomView.removeFromSuperview()}
        zoomView = UIImageView(image: image)
        zoomView!.isUserInteractionEnabled = true
        addSubview(zoomView!)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageScrollView.doubleTapGestureRecognizer(_:)))
        tapGesture.numberOfTapsRequired = 2
        zoomView!.addGestureRecognizer(tapGesture)
        // the one line below is what causes image data to reset after another image is shown,
        // add logic to only run first time
        // if (!imageSized) {
        configureImageForSize(image.size)
        // imageSized = true
        
        // }
    }

//    func resetUI() {
//        if let zoomView = zoomView {zoomView.removeFromSuperview()}
//        zoomView!.isUserInteractionEnabled = true
//        addSubview(zoomView!)
//    }

//    func displayAnim( image: UIImage, anim: AnimationDrawable) {
//        // if (!imageSized) {
//        if let zoomView = zoomView {
//            zoomView.removeFromSuperview()
//        }
//        zoomView = UIImageView(image: image)
//        zoomView!.isUserInteractionEnabled = true
//        addSubview(zoomView!)
//        // }
//        zoomView?.animationImages = anim.images
//        zoomView?.animationDuration = 3.0
//        zoomView?.startAnimating()
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageScrollView.doubleTapGestureRecognizer(_:)))
//        tapGesture.numberOfTapsRequired = 2
//        zoomView!.addGestureRecognizer(tapGesture)
//        configureImageForSize(image.size)
//    }

    fileprivate func configureImageForSize(_ size: CGSize) {
        imageSize = size
        contentSize = imageSize
        setMaxMinZoomScalesForCurrentBounds()
        zoomScale = minimumZoomScale
        contentOffset = CGPoint.zero
    }

    fileprivate func setMaxMinZoomScalesForCurrentBounds() {
        // calculate min/max zoomscale
        let xScale = bounds.width / imageSize.width    // the scale needed to perfectly fit the image width-wise
        let yScale = bounds.height / imageSize.height   // the scale needed to perfectly fit the image height-wise
        // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
        // let imagePortrait = imageSize.height > imageSize.width
        // let phonePortrait = bounds.height >= bounds.width
        // commenting out the below line and implementing the one below it causes landscape
        // images to be not zoomed in at all
        // var minScale = (imagePortrait == phonePortrait) ? xScale : min(xScale, yScale)
        var minScale = min(xScale, yScale)
        let maxScale = maxScaleFromMinScale * minScale
        // don't let minScale exceed maxScale. (If the image is smaller
        // than the screen, we don't want to force it to be zoomed.)
        if minScale > maxScale {
            minScale = maxScale
        }
        maximumZoomScale = maxScale
        minimumZoomScale = minScale * 0.999 // the multiply factor to prevent user cannot scroll page
                                            // while they use this control in UIPageViewController
    }

    // MARK: - Gesture
    @objc func doubleTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        // zoom out if it bigger than middle scale point. Else, zoom in
        if zoomScale >= maximumZoomScale / 2.0 {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            let center = gestureRecognizer.location(in: gestureRecognizer.view)
            let zoomRect = zoomRectForScale(kZoomInFactorFromMinWhenDoubleTap * minimumZoomScale, center: center)
            zoom(to: zoomRect, animated: true)
        }
    }

//    func restorePosition(_ scale: CGFloat, center: CGPoint) {
//        let zoomRect = zoomRectForScale(scale, center: center)
//        zoom(to: zoomRect, animated: true)
//    }

    fileprivate func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        // print(scale)
        // print(center.x)
        // print(center.y)
        // the zoom rect is in the content view's coordinates.
        // at a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
        // as the zoom scale decreases, so more content is visible, the size of the rect grows.
        zoomRect.size.height = frame.size.height / scale
        zoomRect.size.width  = frame.size.width  / scale
        // choose an origin so as to get the right center.
        zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    open func refresh() {
        if let image = zoomView?.image { display(image: image) }
    }
}

extension ImageScrollView: UIScrollViewDelegate {

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? { zoomView }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustFrameToCenter()
    }
}
