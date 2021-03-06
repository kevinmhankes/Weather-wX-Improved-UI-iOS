// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class UtilityModelSpcHrefInputOutput {

    static func getRunTime() -> RunTimeData {
        let runData = RunTimeData()
        let htmlRunStatus = (GlobalVariables.nwsSPCwebsitePrefix + "/exper/href/").getHtml()
        let html = htmlRunStatus.parse("\\{model: \"href\",product: \"500mb_mean\",sector: \"conus\",(rd: .[0-9]{8}\",rt: .[0-9]{4}\",\\})")
        let day = html.parse("rd:.(.*?),.*?").replaceAll("\"", "")
        let time = html.parse("rt:.(.*?)00.,.*?").replaceAll("\"", "")
        let mostRecentRun = day + time
        runData.appendListRun(mostRecentRun)
        runData.appendListRun(UtilityTime.genModelRuns(mostRecentRun, 12, "yyyyMMddHH"))
        runData.mostRecentRun = mostRecentRun
        return runData
    }

    static func getImage(_ om: ObjectModel) -> Bitmap {
        let year = om.run.substring(0, 4)
        let month = om.run.substring(4, 6)
        let day = om.run.substring(6, 8)
        let hour = om.run.substring(8, 10)
        let products = om.param.split(",")
        var urls = [GlobalVariables.nwsSPCwebsitePrefix + "/exper/href/graphics/spc_white_1050px.png"]
        urls.append(GlobalVariables.nwsSPCwebsitePrefix + "/exper/href/graphics/noaa_overlay_1050px.png")
        let sectorIndex = UtilityModelSpcHrefInterface.sectorsLong.firstIndex(of: om.sector) ?? 0
        let sector = UtilityModelSpcHrefInterface.sectors[sectorIndex]
        products.forEach { product in
            var url = ""
            if product.contains("cref_members") {
                let paramArr = product.split(" ")
                url = GlobalVariables.nwsSPCwebsitePrefix + "/exper/href/graphics/models/href/" + year + "/"
                    + month + "/" + day + "/" + hour + "00/f0" + om.time + "00/" + paramArr[0]
                    + "." + sector + ".f0" + om.time + "00." + paramArr[1] + ".tl00.png"
            } else {
                url = GlobalVariables.nwsSPCwebsitePrefix + "/exper/href/graphics/models/href/" + year + "/" + month
                    + "/" + day + "/" + hour + "00/f0" + om.time
                    + "00/" + product + "." + sector + ".f0" + om.time + "00.png"
            }
            urls.append(url)
        }
        urls.append(GlobalVariables.nwsSPCwebsitePrefix + "/exper/href/graphics/blank_maps/" + sector + ".png")
        let bitmaps = urls.map { Bitmap($0) }
        return Bitmap(UtilityImg.addColorBackground(UtilityImg.layerDrawableToUIImage(bitmaps), UIColor.white))
    }
}
