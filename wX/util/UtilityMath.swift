// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class UtilityMath {

    static func distanceOfLine(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Double {
        sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2))
    }

    static func computeTipPoint(_ x0: Double, _ y0: Double, _ x1: Double, _ y1: Double, _ right: Bool) -> [Double] {
        let dx = x1 - x0
        let dy = y1 - y0
        let length = sqrt(dx * dx + dy * dy)
        let dirX = dx / length
        let dirY = dy / length
        let height = sqrt(3) / 2 * length
        let cx = x0 + dx * 0.5
        let cy = y0 + dy * 0.5
        let pDirX = -dirY
        let pDirY = dirX
        if right {
            return [cx + height * pDirX, cy + height * pDirY]
        } else {
            return [cx - height * pDirX, cy - height * pDirY]
        }
    }

    static func computeMiddlePoint(_ x0: Double, _ y0: Double, _ x1: Double, _ y1: Double, _ fraction: Double) -> [Double] {
        [x0 + fraction * (x1 - x0), y0 + fraction * (y1 - y0)]
    }

    static func latLonFix(_ location: LatLon) -> LatLon {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        let x = formatter.string(from: NSNumber(value: location.lat)) ?? "0.0"
        let y = formatter.string(from: NSNumber(value: location.lon)) ?? "0.0"
        return LatLon(x, y)
    }

    static func unitsPressure(_ value: String) -> String {
        var number = to.Double(value)
        if UIPreferences.unitsM {
            number *= 33.8637526
            return String(format: "%.2f", number) + " mb"
        } else {
            return String(format: "%.2f", number) + " in"
        }
    }

    static func celsiusToFahrenheit(_ value: String) -> String {
        String(round((to.Double(value)) * 9 / 5 + 32))
    }

    // only used in the "table" method below
    static func celsiusToFahrenheit(_ value: Int) -> String {
        String(Int(round(Double(value) * 9.0 / 5.0 + 32.0)))
    }

    static func celsiusToFahrenheitTable() -> String {
        var table = "C      F" + GlobalVariables.newline
        (-40...39).forEach { degree in
            table += String(degree).fixedLengthString(4) + "  " + celsiusToFahrenheit(degree) + GlobalVariables.newline
        }
        return table
    }

    static func degreesToRadians(_ deg: Double) -> Double {
        deg * Double.pi / 180
    }

    static func pixPerDegreeLon(_ centerX: Double, _ factor: Double) -> Double {
        let radius = (180 / Double.pi) * (1 / cos(degreesToRadians(30.51))) * factor
        return radius * (Double.pi / 180) * cos(degreesToRadians(centerX))
    }

    static func deg2rad(_ deg: Double) -> Double {
        deg * Double.pi / 180.0
    }

    static func rad2deg(_ rad: Double) -> Double {
        rad * 180.0 / Double.pi
    }

    static func convertWindDir(_ direction: Double) -> String {
        let windDirections = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"]
        let normalizedDirection = Int(direction) % 360
        let listIndex = Int(round((Double(normalizedDirection) / 22.5)))
        let windDirectionAsString = windDirections[listIndex]
        return windDirectionAsString
    }

    static func roundDToString(_ valueD: Double) -> String {
        String(Int(round(valueD)))
    }

    static func pressureMBtoIn(_ value: String) -> String {
        String(format: "%.2f", (to.Double(value)) / 33.8637526) + " in"
    }

    static func getRadarBeamHeight(_ degree: Double, _ distance: Double) -> Double {
        3.281 * (sin(deg2rad(degree)) * distance + distance * distance / 15417.82) * 1000.0
    }

    static func heatIndex(_ temp: String, _ RH: String) -> String {
        // temp >= 80 and RH >= 40
        let T = to.Double(temp)
        let R = to.Double(RH)
        if T > 80.0 && R > 4.0 {
            let s1 = -42.379
            let s2 = 2.04901523 * T
            let s3 = 10.14333127 * R
            let s4 = 0.22475541 * T * R
            let s5 = 6.83783 * pow(10.0, -3.0) * pow(T, 2.0)
            let s6 = 5.481717 * pow(10.0, -2.0) * pow(R, 2.0)
            let s7 = 1.22874 * pow(10.0, -3.0) * pow(T, 2.0) * R
            let s8 = 8.5282 * pow(10.0, -4.0) * T * pow(R, 2.0)
            let s9 = 1.99 * pow(10.0, -6.0) * pow(T, 2.0) * pow(R, 2.0)
            let heatIndexInt = round(s1 + s2 + s3 - s4 - s5 - s6 + s7 + s8 - s9)
            if Int(heatIndexInt) <= Int(round(T)) {
                return ""
            }
            return String(heatIndexInt)
        } else {
            return ""
        }
    }
}
