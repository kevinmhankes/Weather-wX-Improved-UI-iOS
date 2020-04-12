/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class WXGLPolygonWarnings {
    
    // Used in SevereWarnings as well
    static let vtecPattern = "([A-Z0]{1}\\.[A-Z]{3}\\.[A-Z]{4}\\.[A-Z]{2}\\.[A-Z]\\.[0-9]"
        + "{4}\\.[0-9]{6}T[0-9]{4}Z\\-[0-9]{6}T[0-9]{4}Z)"
    
    // FIXME have TOR/FFW/TST use this
    static func addGeneric(_ projectionNumbers: ProjectionNumbers, _ type: ObjectPolygonWarning) -> [Double] {
        var warningList = [Double]()
        let prefToken = type.storage.value
        let html = prefToken.replace("\n", "").replace(" ", "")
        let polygons = html.parseColumn("\"coordinates\":\\[\\[(.*?)\\]\\]\\}")
        let vtecs = html.parseColumn(vtecPattern)
        polygons.enumerated().forEach { polyCount, polygon in
            if type.type == PolygonTypeGeneric.SPS || vtecs.count > polyCount && !vtecs[polyCount].hasPrefix("0.EXP") && !vtecs[polyCount].hasPrefix("0.CAN") {
                let polygonTmp = polygon.replace("[", "").replace("]", "").replace(",", " ").replace("-", "")
                let latLons = LatLon.parseStringToLatLons(polygonTmp)
                warningList += LatLon.latLonListToListOfDoubles(latLons, projectionNumbers)
            }
        }
        return warningList
    }
    
    static func add(_ projectionNumbers: ProjectionNumbers, _ type: PolygonType) -> [Double] {
        var warningList = [Double]()
        var prefToken = MyApplication.severeDashboardFfw.value
        if type.string == "TOR" {
            prefToken = MyApplication.severeDashboardTor.value
        } else if type.string == "TST" {
            prefToken = MyApplication.severeDashboardTst.value
        }
        let html = prefToken.replace("\n", "").replace(" ", "")
        let polygons = html.parseColumn("\"coordinates\":\\[\\[(.*?)\\]\\]\\}")
        let vtecs = html.parseColumn(vtecPattern)
        polygons.enumerated().forEach { polygonCount, polygon in
            if vtecs.count > polygonCount && !vtecs[polygonCount].hasPrefix("0.EXP") && !vtecs[polygonCount].hasPrefix("0.CAN") {
                let polygonTmp = polygon.replace("[", "").replace("]", "").replace(",", " ").replace("-", "")
                let latLons = LatLon.parseStringToLatLons(polygonTmp)
                warningList += LatLon.latLonListToListOfDoubles(latLons, projectionNumbers)
            }
        }
        return warningList
    }
}
