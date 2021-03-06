// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ObjectCardPlayListItem {

    init(
        _ uiv: UIwXViewController,
        _ product: String,
        _ middleLine: String,
        _ bottomLines: String,
        _ gesture: GestureData
    ) {
        let boxV = ObjectStackView(.fill, .vertical, spacing: 0)
        let tvProduct = Text(boxV, product, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvMiddle = Text(boxV, middleLine, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvBottom = Text(boxV, bottomLines.replaceAll(GlobalVariables.newline, " "), isUserInteractionEnabled: false, isZeroSpacing: true)
        tvProduct.font = FontSize.medium.size
        tvMiddle.font = FontSize.small.size
        tvBottom.font = FontSize.small.size
        tvProduct.color = ColorCompatibility.highlightText
        tvMiddle.color = ColorCompatibility.label
        tvBottom.color = ColorCompatibility.systemGray2
        uiv.stackView.addLayout(boxV)
        [tvProduct, tvMiddle, tvBottom].forEach {
            $0.constrain(uiv.scrollView)
        }
        boxV.addGesture(gesture)
        boxV.constrain(uiv.stackView)
    }
}
