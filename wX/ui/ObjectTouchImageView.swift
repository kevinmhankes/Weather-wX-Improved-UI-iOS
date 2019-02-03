/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTouchImageView {

    var img = ImageScrollView()
    private var uiv: UIViewController?
    var bitmap = Bitmap()

    convenience init(_ uiv: UIViewController, _ toolbar: UIToolbar) {
        self.init()
        let (width, height) = UtilityUI.getScreenBoundsCGFloat()
        img = ImageScrollView(
            frame: CGRect(
                x: 0,
                y: UtilityUI.getTopPadding(),
                width: width,
                height: height - toolbar.frame.height - UtilityUI.getTopPadding()
            )
        )
        img.contentMode = UIView.ContentMode.scaleAspectFit
        img.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        uiv.view.addSubview(img)
        self.uiv = uiv
    }

    convenience init(_ uiv: UIViewController, _ toolbar: UIToolbar, _ bitmap: Bitmap) {
        self.init(uiv, toolbar)
        img.display(image: bitmap.image)
        self.uiv = uiv
        self.bitmap = bitmap
    }

    convenience init(_ uiv: UIViewController, _ toolbar: UIToolbar, _ action: Selector) {
        self.init(uiv, toolbar)
        addGestureRecognizer(action)
    }

    func setBitmap(_ bitmap: Bitmap) {
        img.display(image: bitmap.image)
        self.bitmap = bitmap
    }

    func updateBitmap(_ bitmap: Bitmap) {
        img.zoomView?.image = bitmap.image
        self.bitmap = bitmap
    }

    func addGestureRecognizer( _ leftSwipe: UISwipeGestureRecognizer, _ rightSwipe: UISwipeGestureRecognizer) {
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        img.addGestureRecognizer(leftSwipe)
        img.addGestureRecognizer(rightSwipe)
    }

    func addGestureRecognizer(_ action: Selector) {
        let leftSwipe = UISwipeGestureRecognizer(target: uiv, action: action)
        let rightSwipe = UISwipeGestureRecognizer(target: uiv, action: action)
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        img.addGestureRecognizer(leftSwipe)
        img.addGestureRecognizer(rightSwipe)
    }

    func startAnimating(_ animDrawable: AnimationDrawable) {
        self.img.zoomView?.animationImages = animDrawable.imageArray
        self.img.zoomView?.animationDuration = animDrawable.animationDelay
        self.img.zoomView?.startAnimating()
    }

    func setMaxScaleFromMinScale(_ value: CGFloat) {
        img.maxScaleFromMinScale = value
    }

    func setKZoomInFactorFromMinWhenDoubleTap(_ value: CGFloat) {
        img.kZoomInFactorFromMinWhenDoubleTap = value
    }
}
