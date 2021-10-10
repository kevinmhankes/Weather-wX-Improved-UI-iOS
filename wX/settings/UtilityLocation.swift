// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class UtilityLocation {

    static func getLatLonAsDouble() -> [Double] {
        var latLonList = [Double]()
        var tmpX = ""
        var tmpY = ""
        var tmpXArr = [String]()
        var tmpYArr = [String]()
        (0..<Location.numLocations).forEach { index in
            if !Location.getX(index).contains(":") {
                tmpX = Location.getX(index)
                tmpY = Location.getY(index).replace("-", "")
            } else {
                tmpXArr = Location.getX(index).split(":")
                if tmpXArr.count > 2 {
                    tmpX = tmpXArr[2]
                }
                tmpYArr = Location.getY(index).replace("-", "").split(":")
                if tmpYArr.count > 1 {
                    tmpY = tmpYArr[1]
                }
            }
            if tmpX != "" && tmpY != "" {
                latLonList.append(to.Double(tmpX))
                latLonList.append(to.Double(tmpY))
            }
        }
        return latLonList
    }

    static func getNearestOffice(_ officeType: String, _ location: LatLon) -> String {
        var officeArray = GlobalArrays.radars
        var prefToken = "RID"
        if officeType=="WFO" {
            officeArray = GlobalArrays.wfos
            prefToken = "NWS"
        }
        var sites = [RID]()
        officeArray.forEach {
            let labelArr = $0.split(":")
            sites.append(RID(labelArr[0], getSiteLocation(site: labelArr[0], officeType: prefToken)))
        }
        var shortestDistance = 30000.00
        var currentDistance = 0.0
        var bestIndex = -1
        sites.enumerated().forEach { index, site in
            currentDistance = LatLon.distance(location, site.location, .K)
            if currentDistance < shortestDistance {
                shortestDistance = currentDistance
                bestIndex = index
            }
        }
        return sites[bestIndex].name
    }

    static func getSiteLocation(site: String, officeType: String = "RID") -> LatLon {
        let x: String
        let y: String
        switch officeType {
        case "RID":
            let latLon = Utility.getRadarSiteLatLon(site.uppercased())
            x = latLon.latString
            y = latLon.lonString
        case "NWS":
            let latLon = Utility.getWfoSiteLatLon(site.uppercased())
            x = latLon.latString
            y = latLon.lonString
        case "SND":
            let latLon = Utility.getSoundingSiteLatLon(site.uppercased())
            x = latLon.latString
            y = latLon.lonString
        default:
            x = "0.0"
            y = "-0.0"
        }
        return LatLon(x, y)
    }

    static func getNearestRadarSites(_ location: LatLon, _ cnt: Int, includeTdwr: Bool = true) -> [RID] {
        var radarSites = [RID]()
        (0..<GlobalArrays.radars.count).forEach {
            let labels = GlobalArrays.radars[$0].split(":")
            radarSites.append(RID(labels[0], getSiteLocation(site: labels[0])))
        }
        if includeTdwr {
            GlobalArrays.tdwrRadars.forEach {
                let labels = $0.split(" ")
                radarSites.append(RID(labels[0], getSiteLocation(site: labels[0])))
            }
        }
        var currentDistance = 0.0
        radarSites.enumerated().forEach { index, radar in
            currentDistance = LatLon.distance(location, radar.location, .MILES)
            radarSites[index].distance = Int(currentDistance)
        }
        radarSites = radarSites.sorted { $0.distance < $1.distance }
        return Array(radarSites[0...cnt])
    }

    static func getNearestSoundingSite(_ location: LatLon) -> String {
        let sites = GlobalArrays.soundingSites.map { RID($0, getSiteLocation(site: $0, officeType: "SND")) }
        var shortestDistance = 1000.00
        var currentDistance = 0.0
        var bestIndex = -1
        GlobalArrays.soundingSites.indices.forEach {
            currentDistance = LatLon.distance(location, sites[$0].location, .K)
            if currentDistance < shortestDistance {
                shortestDistance = currentDistance
                bestIndex = $0
            }
        }
        if bestIndex == -1 {
            return "BLAH"
        }
        if sites[bestIndex].name == "MFX" {
            return "MFL"
        }
        return sites[bestIndex].name
    }
}
