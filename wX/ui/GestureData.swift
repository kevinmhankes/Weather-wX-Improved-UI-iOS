// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class GestureData: UITapGestureRecognizer {

    var data = 0
    var strData = ""

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }

    init(_ strData: String, _ target: Any?, _ action: Selector?) {
        self.strData = strData
        super.init(target: target, action: action)
    }

    init(_ data: Int, _ strData: String, _ target: Any?, _ action: Selector?) {
        self.data = data
        self.strData = strData
        super.init(target: target, action: action)
    }

    init(_ data: Int, _ target: Any?, _ action: Selector?) {
        self.data = data
        super.init(target: target, action: action)
    }
}
