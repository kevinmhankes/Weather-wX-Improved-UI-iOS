// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ObjectCardBlackHeaderText {

    private let objectCardStackView: ObjectCardStackView
    private let verticalTextContainer: ObjectStackView

    init(_ uiv: UIwXViewController, _ text: String) {
        let tvLocation = TextLarge(80.0, color: UIColor.blue, isUserInteractionEnabled: false)
        tvLocation.text = text
        tvLocation.color = UIColor.white
        tvLocation.background = UIColor.black
        tvLocation.font = FontSize.extraLarge.size
        verticalTextContainer = ObjectStackView(.fill, .vertical, spacing: 0, arrangedSubviews: [tvLocation.view])
        objectCardStackView = ObjectCardStackView(verticalTextContainer)
        objectCardStackView.color = UIColor.black
        uiv.stackView.addLayout(objectCardStackView.view)
        verticalTextContainer.constrain(uiv.scrollView)
    }
    
    init(_ stackView: ObjectStackView, _ text: String) {
        let tvLocation = TextLarge(80.0, color: UIColor.blue, isUserInteractionEnabled: false)
        tvLocation.text = text
        tvLocation.color = UIColor.white
        tvLocation.background = UIColor.black
        tvLocation.font = FontSize.extraLarge.size
        verticalTextContainer = ObjectStackView(.fill, .vertical, spacing: 0, arrangedSubviews: [tvLocation.view])
        objectCardStackView = ObjectCardStackView(verticalTextContainer)
        objectCardStackView.color = UIColor.black
        stackView.addLayout(objectCardStackView.view)
    }
    
    func constrain(_ uiv: UIwXViewController) {
        verticalTextContainer.constrain(uiv.scrollView)
    }
}
