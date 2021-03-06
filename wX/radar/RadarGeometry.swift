// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class RadarGeometry {

    static var stateRelativeBuffer = MemoryBuffer()
    static var hwRelativeBuffer = MemoryBuffer()
    static var hwExtRelativeBuffer = MemoryBuffer()
    static var lakesRelativeBuffer = MemoryBuffer()
    static var countyRelativeBuffer = MemoryBuffer()
    static var countState = 200000
    static var countHw = 862208
    static var countHwExt = 770048
    static var countLakes = 14336 + 489476
    static var countCounty = 212992
    static var hwExtFileResid = R.Raw.hwv4ext
    static var hwFileResid = R.Raw.hwv4
    static var lakesFileResid = R.Raw.lakesv3
    static var countyFileResid = R.Raw.county
    static var radarColorHw = 0
    static var radarColorHwExt = 0
    static var radarColorState = 0
    static var radarColorTstorm = 0
    static var radarColorTstormWatch = 0
    static var radarColorTor = 0
    static var radarColorTorWatch = 0
    static var radarColorFfw = 0
    static var radarColorMcd = 0
    static var radarColorMpd = 0
    static var radarColorLocdot = 0
    static var radarColorSpotter = 0
    static var radarColorCity = 0
    static var radarColorLakes = 0
    static var radarColorCounty = 0
    static var radarColorSti = 0
    static var radarColorHi = 0
    static var radarColorObs = 0
    static var radarColorObsWindbarbs = 0
    static var radarColorCountyLabels = 0

    static func setColors() {
        radarColorHw = Utility.readPref("RADAR_COLOR_HW", Color.rgb(135, 135, 135))
        radarColorHwExt = Utility.readPref("RADAR_COLOR_HW_EXT", Color.rgb(91, 91, 91))
        radarColorState = Utility.readPref("RADAR_COLOR_STATE", Color.rgb(142, 142, 142))
        radarColorTstorm = Utility.readPref("RADAR_COLOR_TSTORM", Color.rgb(255, 255, 0))
        radarColorTstormWatch = Utility.readPref("RADAR_COLOR_TSTORM_WATCH", Color.rgb(255, 187, 0))
        radarColorTor = Utility.readPref("RADAR_COLOR_TOR", Color.rgb(243, 85, 243))
        radarColorTorWatch = Utility.readPref("RADAR_COLOR_TOR_WATCH", Color.rgb(255, 0, 0))
        radarColorFfw = Utility.readPref("RADAR_COLOR_FFW", Color.rgb(0, 255, 0))
        radarColorMcd = Utility.readPref("RADAR_COLOR_MCD", Color.rgb(153, 51, 255))
        radarColorMpd = Utility.readPref("RADAR_COLOR_MPD", Color.rgb(0, 255, 0))
        radarColorLocdot = Utility.readPref("RADAR_COLOR_LOCDOT", Color.rgb(255, 255, 255))
        radarColorSpotter = Utility.readPref("RADAR_COLOR_SPOTTER", Color.rgb(255, 0, 245))
        radarColorCity = Utility.readPref("RADAR_COLOR_CITY", Color.rgb(255, 255, 255))
        radarColorLakes = Utility.readPref("RADAR_COLOR_LAKES", Color.rgb(0, 0, 255))
        radarColorCounty = Utility.readPref("RADAR_COLOR_COUNTY", Color.rgb(75, 75, 75))
        radarColorSti = Utility.readPref("RADAR_COLOR_STI", Color.rgb(255, 255, 255))
        radarColorHi = Utility.readPref("RADAR_COLOR_HI", Color.rgb(0, 255, 0))
        radarColorObs = Utility.readPref("RADAR_COLOR_OBS", Color.rgb(255, 255, 255))
        radarColorObsWindbarbs = Utility.readPref("RADAR_COLOR_OBS_WINDBARBS", Color.rgb(255, 255, 255))
        radarColorCountyLabels = Utility.readPref("RADAR_COLOR_COUNTY_LABELS", Color.rgb(234, 214, 123))
    }

    static func initialize() {
        if !RadarPreferences.hwEnh {
            hwFileResid = R.Raw.hw
            countHw = 112640
        }
        var stateLinesFileResid = R.Raw.statev2
        countState = 205748
        var countStateUs = 205748
        let caResid = R.Raw.ca
        let mxResid = R.Raw.mx
        let countCanada = 161792
        let countMexico = 151552
        if RadarPreferences.stateHires {
            stateLinesFileResid = R.Raw.statev3
            countState = 1166552
            countStateUs = 1166552
        }
        if RadarPreferences.camxBorders {
            countState += countCanada + countMexico
        }
        if RadarPreferences.countyHires {
            countyFileResid = R.Raw.countyv2
            countCounty = 820852
        }
        stateRelativeBuffer = MemoryBuffer(countState * 4)
        hwRelativeBuffer = MemoryBuffer(countHw * 4)
        if RadarPreferences.hwEnhExt {
            hwExtRelativeBuffer = MemoryBuffer(countHwExt * 4)
        }
        lakesRelativeBuffer = MemoryBuffer(countLakes * 4)
        countyRelativeBuffer = MemoryBuffer(countCounty * 4)
        let dataFiles = [
            RadarGeometryFile(lakesFileResid, countLakes, lakesRelativeBuffer, GeographyType.lakes.display, false),
            RadarGeometryFile(hwFileResid, countHw, hwRelativeBuffer, true, false),
            RadarGeometryFile(countyFileResid, countCounty, countyRelativeBuffer, true, false),
            RadarGeometryFile(stateLinesFileResid, countStateUs, stateRelativeBuffer, true, false),
            RadarGeometryFile(caResid, countCanada, stateRelativeBuffer, RadarPreferences.camxBorders, true),
            RadarGeometryFile(mxResid, countMexico, stateRelativeBuffer, RadarPreferences.camxBorders, true),
            RadarGeometryFile(hwExtFileResid, countHwExt, hwExtRelativeBuffer, RadarPreferences.hwEnhExt, false)
        ]
        dataFiles.forEach { dataFile in
            loadBuffer(dataFile)
        }
    }
    
    static func loadBuffer(_ dataFile: RadarGeometryFile) {
        if dataFile.pref {
            let floatSize: Float = 0.0
            var newArray = [UInt8](repeating: 0, count: dataFile.count * 4)
            let path = Bundle.main.path(forResource: dataFile.fileID, ofType: "bin")
            let data = NSData(contentsOfFile: path!)
            data!.getBytes(&newArray, length: MemoryLayout.size(ofValue: floatSize) * dataFile.count)
            if dataFile.addData {
                dataFile.bb.appendArray(newArray)
            } else {
                dataFile.bb.copy(newArray)
            }
        }
    }

    // this is only called after leaving settings -> radar
    static func resetTimerOnRadarPolygons() {
        ObjectPolygonWarning.resetTimers()
    }
}
