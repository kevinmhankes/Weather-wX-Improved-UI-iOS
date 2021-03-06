// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class UtilityModelSpcHrrrInputOutput {
    
    static func getRunTime() -> RunTimeData {
        let runData = RunTimeData()
        let htmlRunStatus = (GlobalVariables.nwsSPCwebsitePrefix + "/exper/hrrr/data/hrrr3/cron.log").getHtml()
        runData.validTime = htmlRunStatus.parse("Latest Run: ([0-9]{10})")
        runData.mostRecentRun = runData.validTime
        runData.appendListRun(runData.mostRecentRun)
        let runTimes = htmlRunStatus.parseColumn("Run: ([0-9]{8}/[0-9]{4})")
        for time in runTimes.reversed() {
            var t = time.replace("/", "")
            if t != (runData.mostRecentRun + "00") {
                t = String(t.dropLast(2))
                runData.appendListRun(t)
            }
        }
        return runData
    }

    static func getImage(_ om: ObjectModel) -> Bitmap {
        let imgUrl = GlobalVariables.nwsSPCwebsitePrefix + "/exper/hrrr/data/hrrr3/"
            + getSectorCode(om.sector).lowercased() + "/R" + om.run.replaceAll("Z", "") + "_F" + om.time
            + "_V" + getValidTime(om.run, om.time, om.runTimeData.validTime) + "_"
            + getSectorCode(om.sector) + "_" + om.param + ".gif"
        return UtilityImg.getBitmapAddWhiteBackground(imgUrl)
    }

    static func getSectorCode(_ sectorName: String) -> String {
        var sectorCode = "S19"
        for index in UtilityModelSpcHrrrInterface.sectors.indices
            where sectorName == UtilityModelSpcHrrrInterface.sectors[index] {
                sectorCode = UtilityModelSpcHrrrInterface.sectorCodes[index]
                break
        }
        return sectorCode
    }

    static func getValidTime(_ run: String, _ validTimeForecast: String, _ validTime: String) -> String {
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone(secondsFromGMT: 0)
        dateFmt.dateFormat = "yyyyMMddHH"
        if let date = dateFmt.date(from: run) {
            let timeChange = 60.0 * 60.0 * (Double(validTimeForecast) ?? 0.0)
            let validTimeCurrent = dateFmt.string(from: (date + timeChange) as Date)
            return validTimeCurrent
        } else {
            return validTime
        }
    }
}
