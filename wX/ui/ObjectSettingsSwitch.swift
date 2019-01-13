/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSettingsSwitch {

    let vw = UIButton(type: UIButton.ButtonType.system)
    let sw = UISwitch()
    var prefMap = [String: String]()

    init(_ stackView: UIStackView, _ prefVar: String, _ boolDefArray: [String: String], _ prefMap: [String: String]) {
        self.prefMap = prefMap
        let sV = ObjectStackView(.fill, .horizontal)
        [vw, sw].forEach {
            $0.backgroundColor = UIColor.white
        }
        vw.contentHorizontalAlignment = .left
        vw.setTitle(prefMap[prefVar], for: .normal)
        vw.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        sw.thumbTintColor = AppColors.primaryDarkBlueUIColor
        sw.onTintColor = AppColors.primaryColorUIColor
        sw.setOn(preferences.getString(prefVar, boolDefArray[prefVar]!).hasPrefix("t"), animated: true)
        sV.addArrangedSubviews([vw, sw])
        sV.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        stackView.addArrangedSubview(sV.view)
    }
}
