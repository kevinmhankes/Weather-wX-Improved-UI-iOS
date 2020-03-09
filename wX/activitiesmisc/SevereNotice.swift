/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class SevereNotice {
    
    var numberList = [String]()
    var bitmaps = [Bitmap]()
    var type = ""
    
    init(_ type: String) {
        self.type = type
    }
    
    func getBitmaps(_ html: String) {
        var noAlertsVerbiage = ""
        var url = ""
        var text = ""
        bitmaps = [Bitmap]()
        switch type {
        case "SPCMCD":
            noAlertsVerbiage = "<center>No Mesoscale Discussions are currently in effect."
        case "SPCWAT":
            noAlertsVerbiage = "<center><strong>No watches are currently valid"
        case "WPCMPD":
            noAlertsVerbiage = "No MPDs are currently in effect."
        default:
            break
        }
        if !html.contains(noAlertsVerbiage) {
            text = html
        } else {
            text = ""
        }
        numberList = text.split(":").filter { $0 != "" }
        if text != "" {
            numberList.indices.forEach { index in
                switch type {
                case "SPCMCD":
                    url = MyApplication.nwsSPCwebsitePrefix + "/products/md/mcd" + numberList[index] + ".gif"
                case "SPCWAT":
                    url = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + numberList[index] + "_radar.gif"
                case "WPCMPD":
                    url = MyApplication.nwsWPCwebsitePrefix + "/metwatch/images/mcd" + numberList[index] + ".gif"
                default:
                    break
                }
                bitmaps.append(Bitmap(url))
            }
        }
    }
}
