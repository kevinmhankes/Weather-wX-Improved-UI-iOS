/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectImageAndText {
    
    //
    // Used in SPC Swo(below), SPC Fireoutlook, and WPC Excessive Rain image/text combo
    //
    
    init(_ uiv: UIwXViewControllerWithAudio, _ bitmap: Bitmap, _ html: String) {
        var tabletInLandscape = UtilityUI.isTablet() && UtilityUI.isLandscape()
        #if targetEnvironment(macCatalyst)
        tabletInLandscape = true
        #endif
        if tabletInLandscape {
            uiv.stackView.axis = .horizontal
            uiv.stackView.alignment = .firstBaseline
        }
        var views = [UIView]()
        let objectImage: ObjectImage
        if tabletInLandscape {
            objectImage = ObjectImage(
                uiv.stackView,
                bitmap,
                UITapGestureRecognizerWithData(0, uiv, #selector(imageClicked)),
                widthDivider: 2
            )
        } else {
            objectImage = ObjectImage(
                uiv.stackView,
                bitmap,
                UITapGestureRecognizerWithData(0, uiv, #selector(imageClicked))
            )
        }
        objectImage.img.accessibilityLabel = html
        objectImage.img.isAccessibilityElement = true
        views.append(objectImage.img)
        if tabletInLandscape {
            uiv.objectTextView = ObjectTextView(uiv.stackView, html, widthDivider: 2)
        } else {
            uiv.objectTextView = ObjectTextView(uiv.stackView, html)
        }
        uiv.objectTextView.tv.isAccessibilityElement = true
        views.append(uiv.objectTextView.tv)
        uiv.scrollView.accessibilityElements = views
    }
    
    // SPC SWO
    init(_ uiv: UIwXViewControllerWithAudio, _ bitmaps: [Bitmap], _ html: String) {
        var imageCount = 0
        var imagesPerRow = 2
        var imageStackViewList = [ObjectStackView]()
        if UtilityUI.isTablet() && UtilityUI.isLandscape() { imagesPerRow = 4 }
        #if targetEnvironment(macCatalyst)
        imagesPerRow = 4
        #endif
        if bitmaps.count == 2 { imagesPerRow = 2 }
        bitmaps.enumerated().forEach { imageIndex, image in
            let stackView: UIStackView
            if imageCount % imagesPerRow == 0 {
                let objectStackView = ObjectStackView(UIStackView.Distribution.fillEqually, NSLayoutConstraint.Axis.horizontal)
                imageStackViewList.append(objectStackView)
                stackView = objectStackView.view
                uiv.stackView.addArrangedSubview(stackView)
            } else {
                stackView = imageStackViewList.last!.view
            }
            _ = ObjectImage(
                stackView,
                image,
                UITapGestureRecognizerWithData(imageIndex, uiv, #selector(imageClickedWithIndex(sender:))),
                widthDivider: imagesPerRow
            )
            imageCount += 1
        }
        var views = [UIView]()
        uiv.objectTextView = ObjectTextView(uiv.stackView, html)
        uiv.objectTextView.constrain(uiv.scrollView)
        uiv.objectTextView.tv.isAccessibilityElement = true
        views.append(uiv.objectTextView.tv)
        uiv.scrollView.accessibilityElements = views
    }
    
    @objc func imageClickedWithIndex(sender: UITapGestureRecognizerWithData) {}
    
    @objc func imageClicked() {}
}
