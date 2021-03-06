// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ObjectToolbar: UIToolbar {

    private var toolbarHeightConstraint: NSLayoutConstraint?

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func setConfigWithUiv(uiv: UIViewController, toolbarType: ToolbarType = .bottom) {
        switch toolbarType {
        case .bottom:
            let bottomSpace = -UtilityUI.getBottomPadding()
            translatesAutoresizingMaskIntoConstraints = false
            bottomAnchor.constraint(equalTo: uiv.view.bottomAnchor, constant: bottomSpace).isActive = true
            heightAnchor.constraint(equalToConstant: UIPreferences.toolbarHeight).isActive = true
            leftAnchor.constraint(equalTo: uiv.view.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: uiv.view.rightAnchor).isActive = true
        case .top:
            translatesAutoresizingMaskIntoConstraints = false
            toolbarHeightConstraint = topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: UtilityUI.getTopPadding())
            uiv.view.addConstraint(toolbarHeightConstraint!)
            leftAnchor.constraint(equalTo: uiv.view.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: uiv.view.rightAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: UIPreferences.toolbarHeight).isActive = true
        }
        setColorToTheme()
    }

    func resize(uiv: UIViewController) {
        if toolbarHeightConstraint != nil {
            uiv.view.removeConstraint(toolbarHeightConstraint!)
        }
        toolbarHeightConstraint = topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: UtilityUI.getTopPadding())
        uiv.view.addConstraint(toolbarHeightConstraint!)
    }

    func setColorToTheme() {
        barTintColor = UIColor(
            red: AppColors.primaryColorRed,
            green: AppColors.primaryColorGreen,
            blue: AppColors.primaryColorBlue,
            alpha: CGFloat(1.0)
        )
    }

    func setTransparent() {
        setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        setShadowImage(UIImage(), forToolbarPosition: .any)
    }

    var height: CGFloat { frame.size.height }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
