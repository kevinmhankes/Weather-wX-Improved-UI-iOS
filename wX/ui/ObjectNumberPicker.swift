/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectNumberPicker {

    let numberPicker = UIPickerView()
    let button = UIButton(type: UIButton.ButtonType.system)

    init(_ stackView: UIStackView, _ prefVar: String, _ pickerMap: [String: String]) {
        let label = pickerMap[prefVar]
        button.setTitle(label, for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = UIColor.white
        numberPicker.backgroundColor = UIColor.white
        let horizontalContainer = ObjectCardStackView(arrangedSubviews: [button, numberPicker], alignment: .center)
        stackView.addArrangedSubview(horizontalContainer.view)
    }
}
