/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

public class ObjectFab {

    private let floaty = Floaty(frame: UIScreen.main.bounds, size: 56)

    init(_ uiv: UIViewController, _ action: Selector) {
        floaty.sticky = true
        floaty.paddingY = 62.0
        floaty.buttonColor = AppColors.primaryColorFab
        floaty.buttonImage = UtilityImg.resizeImage(UIImage(named: "ic_flash_on_24dp")!, 0.50)
        floaty.addGestureRecognizer(UITapGestureRecognizer(target: uiv, action: action))
    }

    var view: Floaty {
        return floaty
    }
}
