// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class UtilityLocationFragment {

    static let nws7dayTemp1 = "with a low around (-?[0-9]{1,3})\\."
    static let nws7dayTemp2 = "with a high near (-?[0-9]{1,3})\\."
    static let nws7dayTemp3 = "teady temperature around (-?[0-9]{1,3})\\."
    static let nws7dayTemp4 = "Low around (-?[0-9]{1,3})\\."
    static let nws7dayTemp5 = "High near (-?[0-9]{1,3})\\."
    static let nws7dayTemp6 = "emperature falling to around (-?[0-9]{1,3}) "
    static let nws7dayTemp7 = "emperature rising to around (-?[0-9]{1,3}) "
    static let nws7dayTemp8 = "emperature falling to near (-?[0-9]{1,3}) "
    static let nws7dayTemp9 = "emperature rising to near (-?[0-9]{1,3}) "
    static let nws7dayTemp10 = "High near (-?[0-9]{1,3}),"
    static let nws7dayTemp11 = "Low around (-?[0-9]{1,3}),"
    static let ca7dayTemp1 = "Temperature falling to (minus [0-9]{1,2}) this"
    static let ca7dayTemp2 = "Low (minus [0-9]{1,2})\\."
    static let ca7dayTemp3 = "High (minus [0-9]{1,2})\\."
    static let ca7dayTemp4 = "Low plus ([0-9]{1,2})\\."
    static let ca7dayTemp5 = "High plus ([0-9]{1,2})\\."
    static let ca7dayTemp6 = "steady near (minus [0-9]{1,2})\\."
    static let ca7dayTemp7 = "steady near plus ([0-9]{1,2})\\."
    static let ca7dayTemp8 = "rising to (minus [0-9]{1,2}) "
    static let ca7dayTemp9 = "falling to (minus [0-9]{1,2}) "
    static let ca7dayTemp10 = "Low (minus [0-9]{1,2}) "
    static let ca7dayTemp11 = "Low (zero)\\."
    static let ca7dayTemp12 = "rising to ([0-9]{1,2}) "
    static let ca7dayTemp13 = "High ([0-9]{1,2})[\\. ]"
    static let ca7dayTemp14 = "rising to plus ([0-9]{1,2}) "
    static let ca7dayTemp15 = "falling to plus ([0-9]{1,2}) "
    static let ca7dayTemp16 = "High (zero)\\."
    static let ca7dayTemp17 = "rising to (zero) by"
    static let ca7dayTemp18 = "Low ([0-9]{1,2})\\."
    static let ca7dayTemp19 = "High ([0-9]{1,2}) with temperature"
    static let ca7dayTemp20 = "Temperature falling to (zero) in"
    static let ca7dayTemp21 = "steady near ([0-9]{1,2})\\."
    static let ca7dayTemp22 = "steady near (zero)\\."
    static let ca7dayWindDirection1 = "Wind ([a-z]*?) [0-9]{2,3} "
    static let ca7dayWindDirection2 = "Wind becoming ([a-z]*?) [0-9]{2,3} "
    static let ca7dayWindSpeed1 = "([0-9]{2,3}) to ([0-9]{2,3}) km/h"
    static let ca7dayWindSpeed2 = "( [0-9]{2,3}) km/h"
    static let ca7dayWindSpeed3 = "gusting to ([0-9]{2,3})"
    static let sevenDayWind1 = "wind ([0-9]*) to ([0-9]*) mph"
    static let sevenDayWind2 = "wind around ([0-9]*) mph"
    static let sevenDayWind3 = "with gusts as high as ([0-9]*) mph"
    static let sevenDayWind4 = " ([0-9]*) to ([0-9]*) mph after"
    static let sevenDayWind5 = " around ([0-9]*) mph after "
    static let sevenDayWind6 = " ([0-9]*) to ([0-9]*) mph in "
    static let sevenDayWind7 = "around ([0-9]*) mph"
    static let sevenDayWind8 = "Winds could gust as high as ([0-9]*) mph\\."
    static let sevenDayWind9 = " ([0-9]*) to ([0-9]*) mph."
   
    static func extract7DayMetrics(_ chunk: String) -> String {
        let spacing = " "
        // wind 24 to 29 mph
        let wind = chunk.parseMultiple(sevenDayWind1)
        // wind around 9 mph
        let wind2 = chunk.parse(sevenDayWind2)
        // 5 to 10 mph after
        let wind3 = chunk.parseMultiple(sevenDayWind4)
        // around 5 mph after
        let wind4 = chunk.parse(sevenDayWind5)
        // 5 to 7 mph in
        let wind5 = chunk.parseMultiple(sevenDayWind6)
        // around 6 mph.
        let wind7 = chunk.parse(sevenDayWind7)
        // with gusts as high as 21 mph
        var gust = chunk.parse(sevenDayWind3)
        // 5 to 7 mph.
        let wind9 = chunk.parseMultiple(sevenDayWind9)
        // Winds could gusts as high as 21 mph.
        if gust == "" { gust = chunk.parse(sevenDayWind8) }
        if gust != "" {
            gust = " G " + gust + " mph"
        } else {
            gust = " mph"
        }
        if wind.count > 1 {
            return spacing + wind[0] + "-" + wind[1] + gust
        } else if wind2 != "" {
            return spacing + wind2 + gust
        } else if wind3.count > 1 {
            return spacing + wind3[0] + "-" + wind3[1] + gust
        } else if wind4 != "" {
            return spacing + wind4 + gust
        } else if wind5.count > 1 {
            return spacing + wind5[0] + "-" + wind5[1] + gust
        } else if wind7 != "" {
            return spacing + wind7 + gust
        } else if wind9.count > 1 {
            return spacing + wind9[0] + "-" + wind9[1] + gust
        } else {
            return ""
        }
    }

    static let windDir = [
        "north": "N",
        "north northeast": "NNE",
        "northeast": "NE",
        "east northeast": "ENE",
        "east": "E",
        "east southeast": "ESE",
        "south southeast": "SSE",
        "southeast": "SE",
        "south": "S",
        "south southwest": "SSW",
        "southwest": "SW",
        "west southwest": "WSW",
        "west": "W",
        "west northwest": "WNW",
        "northwest": "NW",
        "north northwest": "NNW"
    ]

    static func extractWindDirection(_ chunk: String) -> String {
        let patterns = [
            "Breezy, with a[n]? (.*?) wind",
            "wind becoming (\\w+\\s?\\w*) around",
            "wind becoming (.*?) [0-9]",
            "\\. (\\w+\\s?\\w*) wind ",
            "Windy, with a[n]? (.*?) wind",
            "Blustery, with a[n]? (.*?) wind",
            "Light (.*?) wind"
        ]
        var windResults = [String]()
        patterns.forEach { windResults.append(chunk.parseLastMatch($0)) }
        var retStr = ""
        for windToken in windResults where windToken != "" {
            retStr = windToken
            break
        }
        if retStr == "" {
            return ""
        } else {
            if let ret = windDir[retStr.lowercased()] {
                return " " + ret + ""
            } else {
                return ""
            }
        }
    }

    static func extractTemp(_ blob: String) -> String {
        let regexps = [
            nws7dayTemp1,
            nws7dayTemp2,
            nws7dayTemp3,
            nws7dayTemp4,
            nws7dayTemp5,
            nws7dayTemp6,
            nws7dayTemp7,
            nws7dayTemp8,
            nws7dayTemp9,
            nws7dayTemp10,
            nws7dayTemp11
        ]
        for regexp in regexps {
            let temp = blob.parse(regexp)
            if temp != "" {
                return temp
            }
        }
        return ""
    }

    static func extractCanadaTemp(_ blob: String) -> String {
        var temp = blob.parse(ca7dayTemp1)
        if temp != "" { return temp.replace("minus ", "-") }
        temp = blob.parse(ca7dayTemp2)
        if temp != "" { return temp.replace("minus ", "-") }
        temp = blob.parse(ca7dayTemp3)
        if temp != "" { return temp.replace("minus ", "-") }
        temp = blob.parse(ca7dayTemp4)
        if temp != "" { return temp }
        temp = blob.parse(ca7dayTemp5)
        if temp != "" { return temp }
        temp = blob.parse(ca7dayTemp6)
        if temp != "" { return temp.replace("minus ", "-") }
        temp = blob.parse(ca7dayTemp7)
        if temp != "" { return temp }
        temp = blob.parse(ca7dayTemp8)
        if temp != "" { return temp.replace("minus ", "-") }
        temp = blob.parse(ca7dayTemp9)
        if temp != "" { return temp.replace("minus ", "-") }
        temp = blob.parse(ca7dayTemp10)
        if temp != "" { return temp.replace("minus ", "-") }
        temp = blob.parse(ca7dayTemp11)
        if temp != "" { return "0" }
        temp = blob.parse(ca7dayTemp12)
        if temp != "" { return temp }
        temp = blob.parse(ca7dayTemp13)
        if temp != "" { return temp }
        temp = blob.parse(ca7dayTemp14)
        if temp != "" { return temp }
        temp = blob.parse(ca7dayTemp15)
        if temp != "" { return temp }
        temp = blob.parse(ca7dayTemp16)
        if temp != "" { return "0" }
        temp = blob.parse(ca7dayTemp17)
        if temp != "" { return "0" }
        temp = blob.parse(ca7dayTemp18)
        if temp != "" { return temp }
        temp = blob.parse(ca7dayTemp19)
        if temp != "" { return temp }
        temp = blob.parse(ca7dayTemp20)
        if temp != "" { return "0" }
        temp = blob.parse(ca7dayTemp21)
        if temp != "" { return temp }
        temp = blob.parse(ca7dayTemp22)
        if temp != "" { return "0" }
        return temp
    }

    static func extractCanadaWindDirection(_ chunk: String) -> String {
        var wdir = chunk.parse(ca7dayWindDirection1)
        if wdir == "" {
            wdir = chunk.parse(ca7dayWindDirection2)
        }
        if wdir != "" {
            wdir = " " + (windDir[wdir] ?? "")
        }
        return wdir
    }

    static func extractCanadaWindSpeed(_ chunk: String) -> String {
        let wspdRange = chunk.parseMultiple(ca7dayWindSpeed1)
        let wspd = chunk.parse(ca7dayWindSpeed2)
        var gust = ""
        if chunk.contains("gusting") {
            gust = " G " + chunk.parse(ca7dayWindSpeed3)
        }
        if wspdRange.count > 1 {
            return " " + wspdRange[0] + "-" + wspdRange[1] + gust + " km/h"
        }
        if wspd == "" {
            return ""
        } else {
            return wspd + gust + " km/h"
        }
    }
}
