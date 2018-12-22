/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectToolbar: UIToolbar {

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    convenience init(_ toolbarType: ToolbarType = .bottom) {
        self.init()
        setConfig(toolbarType)
    }

    func setConfig(_ toolbarType: ToolbarType = .bottom) {
        switch toolbarType {
        case .bottom:
            frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIPreferences.toolbarHeight,
                           width: UIScreen.main.bounds.width,
                           height: UIPreferences.toolbarHeight)
            autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleTopMargin]
        case .top:
            frame = CGRect(x: 0, y: UIPreferences.statusBarHeight,
                           width: UIScreen.main.bounds.width,
                           height: UIPreferences.toolbarHeight)
            autoresizingMask = [UIViewAutoresizing.flexibleWidth]
        }
        sizeToFit()
        barTintColor = UIColor(red: AppColors.primaryColorRed,
                               green: AppColors.primaryColorGreen,
                               blue: AppColors.primaryColorBlue,
                               alpha: CGFloat(1.0))
    }

    func setTransparent() {
        setBackgroundImage(
            UIImage(),
            forToolbarPosition: .any,
            barMetrics: .default
        )
        setShadowImage(UIImage(), forToolbarPosition: .any)
    }

    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
