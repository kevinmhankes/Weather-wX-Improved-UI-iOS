/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectToolbar: UIToolbar {

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        //layer.shadowOpacity = 1.0
        // TOP layer.shadowOffset = CGSize(width: 0, height: -5)
        //layer.shadowOffset = CGSize(width: 0, height: 5)
        //layer.shadowColor = UIColor.lightGray.cgColor
    }

    convenience init(_ toolbarType: ToolbarType = .bottom) {
        self.init()
        setConfig(toolbarType)
    }

    func setConfig(_ toolbarType: ToolbarType = .bottom) {
        let (width, height) = UtilityUI.getScreenBoundsCGFloat()
        switch toolbarType {
        case .bottom:
            frame = CGRect(
                x: 0,
                y: height - UIPreferences.toolbarHeight - UtilityUI.getBottomPadding(),
                width: width,
                height: UIPreferences.toolbarHeight
            )
            autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleTopMargin]
        case .top:
            frame = CGRect(
                x: 0,
                y: UtilityUI.getTopPadding(),
                width: width,
                height: UIPreferences.toolbarHeight
            )
            autoresizingMask = [UIView.AutoresizingMask.flexibleWidth]
        }
        barTintColor = UIColor(
            red: AppColors.primaryColorRed,
            green: AppColors.primaryColorGreen,
            blue: AppColors.primaryColorBlue,
            alpha: CGFloat(1.0)
        )
    }

    func setTransparent() {
        setBackgroundImage(
            UIImage(),
            forToolbarPosition: .any,
            barMetrics: .default
        )
        setShadowImage(UIImage(), forToolbarPosition: .any)
    }

    func resize() {
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        frame = CGRect(
            x: 0,
            y: UtilityUI.getTopPadding(),
            width: width,
            height: UIPreferences.toolbarHeight
        )
        autoresizingMask = [UIView.AutoresizingMask.flexibleWidth]
    }

    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
