// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class UtilityHourlyOldApi {

    static func getHourlyString(_ locNumber: Int) -> String {
        let latLon = Location.getLatLon(locNumber)
        let html = UtilityIO.getHtml("https://forecast.weather.gov/MapClick.php?lat=" +
               latLon.latString + "&lon=" +
               latLon.lonString + "&FcstType=digitalDWML")
        let header = "Time".ljust(13) + " " + "Temp".ljust(5) + "Dew".ljust(5) + "Precip%".ljust(7) + "Cloud%".ljust(6) + GlobalVariables.newline
        return GlobalVariables.newline + header + parseHourly(html)
    }
       
    static func parseHourly(_ html: String) -> String {
        let regexpList = [
            "<temperature type=.hourly.*?>(.*?)</temperature>",
            "<temperature type=.dew point.*?>(.*?)</temperature>",
            "<time-layout.*?>(.*?)</time-layout>",
            "<probability-of-precipitation.*?>(.*?)</probability-of-precipitation>",
            "<cloud-amount type=.total.*?>(.*?)</cloud-amount>"
        ]
        let rawData = UtilityString.parseXmlExt(regexpList, html)
        let temp2List = UtilityString.parseXmlValue(rawData[0])
        let temp3List = UtilityString.parseXmlValue(rawData[1])
        var time2List = UtilityString.parseXml(rawData[2], "start-valid-time")
        let temp4List = UtilityString.parseXmlValue(rawData[3])
        let temp5List = UtilityString.parseXmlValue(rawData[4])

        var sb = ""
        let year = UtilityTime.getYear()

        let temp2Len = temp2List.count
        let temp3Len = temp3List.count
        let temp4Len = temp4List.count
        let temp5Len = temp5List.count

        for j in 1..<temp2Len {
            time2List[j] = UtilityString.replaceAllRegexp(time2List[j], "-0[0-9]:00", "")
            time2List[j] = UtilityString.replaceAllRegexp(time2List[j], "^.*?-", "")
            time2List[j] = time2List[j].replace("T", " ")
            time2List[j] = time2List[j].replace("00:00", "00")

            let timeSplit = time2List[j].split(" ")
            let timeSplit2 = timeSplit[0].split("-")
            let month = to.Int(timeSplit2[0])
            let day = to.Int(timeSplit2[1])
            let dayOfTheWeek = UtilityTime.dayOfWeek(year, month, day)
            var temp3Val = "."
            var temp4Val = "."
            var temp5Val = "."
            if temp2Len == temp3Len {
               temp3Val = temp3List[j]
            }
            if temp2Len == temp4Len {
               temp4Val = temp4List[j]
            }
            if temp2Len == temp5Len {
               temp5Val = temp5List[j]
            }
            time2List[j] = time2List[j].replace(":00", "")
            time2List[j] = time2List[j].strip()

            sb += (dayOfTheWeek + " " + time2List[j]).replace("\n", "").ljust(9)
            sb += "   "
            sb += temp2List[j].ljust(5)
            sb += temp3Val.ljust(5)
            sb += temp4Val.ljust(7)
            sb += temp5Val.ljust(6)
            sb += GlobalVariables.newline
        }
        return sb
    }
}
