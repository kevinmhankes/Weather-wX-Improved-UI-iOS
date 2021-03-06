// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class TextLarge {

    private let tv = UILabelInset()

    init(
        _ textPadding: CGFloat,
        text: String = "",
        color: UIColor = ColorCompatibility.label,
        isUserInteractionEnabled: Bool = true
    ) {
        tv.translatesAutoresizingMaskIntoConstraints = false
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        tv.widthAnchor.constraint(equalToConstant: width - textPadding).isActive = true
        tv.font = FontSize.medium.size
        tv.adjustsFontSizeToFitWidth = true
        tv.textColor = color
        self.text = text
        tv.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    func constrain() {
        let bounds = UtilityUI.getScreenBoundsCGFloat()
        tv.widthAnchor.constraint(equalToConstant: bounds.0).isActive = true
    }

    func resetTextSize() {
        tv.font = FontSize.medium.size
    }

    var text: String {
        get { tv.text! }
        set { tv.text = newValue }
    }
    
    var font: UIFont {
        get { tv.font! }
        set { tv.font = newValue }
    }
    
    var background: UIColor {
        get { tv.backgroundColor! }
        set { tv.backgroundColor = newValue }
    }
    
    var color: UIColor {
        get { tv.textColor! }
        set { tv.textColor = newValue }
    }
    
    var isAccessibilityElement: Bool {
        get { tv.isAccessibilityElement }
        set { tv.isAccessibilityElement = newValue }
    }
    
    var isHidden: Bool {
        get { tv.isHidden }
        set { tv.isHidden = newValue }
    }

    var view: UILabelInset { tv }
}
