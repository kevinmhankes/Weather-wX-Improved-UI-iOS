// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class UtilitySpc {

    static func getTstormOutlookUrls() -> [String] {
        let html = (GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/enhtstm/").getHtml()
        let imageNames = html.parseColumn("OnClick.\"show_tab\\(.([0-9]{4}).\\)\".*?")
        return imageNames.map { GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/enhtstm/imgs/enh_" + $0 + ".gif" }
    }
}
