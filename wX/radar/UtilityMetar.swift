// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class UtilityMetar {

    private static var initializedObsMap = false
    private static var obsLatlon = [String: LatLon]()
    private static var metarDataRaw = [String]()
    private static var metarSites = [RID]()

    static func getStateMetarArrayForWXOGL(_ radarSite: String, _ fileStorage: FileStorage) {
        if fileStorage.obsDownloadTimer.isRefreshNeeded() || radarSite != fileStorage.obsOldRadarSite {
            var obsAl = [String]()
            var obsAlExt = [String]()
            var obsAlWb = [String]()
            var obsAlWbGust = [String]()
            var obsAlX = [Double]()
            var obsAlY = [Double]()
            var obsAlAviationColor = [Int]()
            fileStorage.obsOldRadarSite = radarSite
            let obsList = getObservationSites(radarSite)
            let html = (GlobalVariables.nwsAWCwebsitePrefix + "/adds/metars/index?submit=1&station_ids=" + obsList + "&chk_metars=on").getHtml()
            let metarArr = condenseObs(html.parseColumn("<FONT FACE=\"Monospace,Courier\">(.*?)</FONT><BR>"))
            if !initializedObsMap {
                var lines = UtilityIO.rawFileToStringArray(R.Raw.us_metar3)
                _ = lines.popLast()
                lines.forEach { line in
                    let items = line.split(" ")
                    obsLatlon[items[0]] = LatLon(items[1], items[2])
                }
                initializedObsMap = true
            }
            metarArr.forEach { metar in
                var validWind = false
                var validWindGust = false
                if (metar.hasPrefix("K") || metar.hasPrefix("P")) && !metar.contains("NIL") {
                    let metarItems = metar.split(" ")
                    let TDArr = metar.parse(".*? (M?../M?..) .*?").split("/")
                    let timeBlob = metarItems.count > 1 ? metarItems[1] : ""
                    var pressureBlob = metar.parse(".*? A([0-9]{4})")
                    var windBlob = metar.parse("AUTO ([0-9].*?KT) .*?")
                    if windBlob == "" {
                        windBlob = metar.parse("Z ([0-9].*?KT) .*?")
                    }
                    let conditionsBlob = metar.parse("SM (.*?) M?[0-9]{2}/")
                    var visBlob = metar.parse(" ([0-9].*?SM) ")
                    let visBlobArr = visBlob.split(" ")
                    let visBlobDisplay = visBlobArr[visBlobArr.count - 1]
                    visBlob = visBlobArr[visBlobArr.count - 1].replace("SM", "")
                    var visInt = 0
                    if visBlob.contains("/") {
                        visInt = 0
                    } else if visBlob != "" {
                        visInt = to.Int(visBlob)
                    } else {
                        visInt = 20000
                    }
                    var ovcStr = conditionsBlob.parse("OVC([0-9]{3})")
                    var bknStr = conditionsBlob.parse("BKN([0-9]{3})")
                    var ovcInt = 100000
                    var bknInt = 100000
                    if ovcStr != "" {
                        ovcStr += "00"
                        ovcInt = to.Int(ovcStr)
                    }
                    if bknStr != "" {
                        bknStr += "00"
                        bknInt = to.Int(bknStr)
                    }
                    let lowestCig = bknInt < ovcInt ? bknInt : ovcInt
                    var aviationColor = Color.GREEN
                    if visInt > 5 && lowestCig > 3000 {
                        aviationColor = Color.GREEN
                    }
                    if (visInt >= 3 && visInt <= 5) || ( lowestCig >= 1000 && lowestCig <= 3000) {
                        aviationColor = Color.rgb(0, 100, 255)
                    }
                    if (visInt >= 1 && visInt < 3) || ( lowestCig >= 500 && lowestCig < 1000) {
                        aviationColor = Color.RED
                    }
                    if visInt < 1 || lowestCig < 500 {
                        aviationColor = Color.MAGENTA
                    }
                    if pressureBlob.count == 4 {
                        pressureBlob = pressureBlob.insert(pressureBlob.count - 2, ".")
                        pressureBlob = UtilityMath.unitsPressure(pressureBlob)
                    }
                    var windDir = ""
                    var windInKt = ""
                    var windGustInKt = ""
                    var windDirD = 0.0
                    if windBlob.contains("KT") && windBlob.count == 7 {
                        validWind = true
                        windDir = windBlob.substring(0, 3)
                        windInKt = windBlob.substring(3, 5)
                        windDirD = to.Double(windDir)
                        windBlob = windDir + " (" + UtilityMath.convertWindDir(windDirD) + ") " + windInKt + " kt"
                    } else if windBlob.contains("KT") && windBlob.count == 10 {
                        validWind = true
                        validWindGust = true
                        windDir = windBlob.substring(0, 3)
                        windInKt = windBlob.substring(3, 5)
                        windGustInKt = windBlob.substring(6, 8)
                        windDirD = to.Double(windDir)
                        windBlob = windDir + " (" + UtilityMath.convertWindDir(windDirD) + ") " + windInKt + " G " + windGustInKt + " kt"
                    }
                    if TDArr.count > 1 {
                        var temperature = TDArr[0]
                        var dewPoint = TDArr[1]
                        temperature = UtilityMath.celsiusToFahrenheit(temperature.replace("M", "-")).replace(".0", "")
                        dewPoint = UtilityMath.celsiusToFahrenheit(dewPoint.replace("M", "-")).replace(".0", "")
                        let obsSite = metarItems[0]
                        var latlon = obsLatlon[obsSite] ?? LatLon()
                        latlon.lonString = latlon.lonString.replace("-0", "-")
                        obsAl.append(latlon.latString + ":" + latlon.lonString + ":" + temperature + "/" + dewPoint)
                        obsAlExt.append(latlon.latString + ":" + latlon.lonString + ":" + temperature
                            + "/" + dewPoint + " (" + obsSite + ")" + GlobalVariables.newline + pressureBlob
                            + " - " + visBlobDisplay + GlobalVariables.newline + windBlob + GlobalVariables.newline
                            + conditionsBlob + GlobalVariables.newline + timeBlob)
                        if validWind {
                            obsAlWb.append(latlon.latString + ":" + latlon.lonString + ":" + windDir + ":" + windInKt)
                            obsAlX.append(latlon.lat)
                            obsAlY.append(latlon.lon * -1.0)
                            obsAlAviationColor.append(aviationColor)
                        }
                        if validWindGust {
                            obsAlWbGust.append(latlon.latString
                                + ":"
                                + latlon.lonString
                                + ":"
                                + windDir
                                + ":"
                                + windGustInKt)
                        }
                    }
                }
            }
            fileStorage.obsArr = obsAl
            fileStorage.obsArrExt = obsAlExt
            fileStorage.obsArrWb = obsAlWb
            fileStorage.obsArrWbGust = obsAlWbGust
            fileStorage.obsArrX = obsAlX
            fileStorage.obsArrY = obsAlY
            fileStorage.obsArrAviationColor = obsAlAviationColor
        }
    }

    static func readMetarData() {
        if metarDataRaw.isEmpty {
            metarDataRaw = UtilityIO.rawFileToStringArray(R.Raw.us_metar3)
            _ = metarDataRaw.popLast()
            metarSites = [RID]()
            metarDataRaw.forEach { metar in
                let items = metar.split(" ")
                metarSites.append(RID(items[0], LatLon(items[1], items[2])))
            }
        }
    }

    static func findClosestMetar(_ location: LatLon) -> String {
        readMetarData()
        var localMetarSites = metarSites
        localMetarSites.indices.forEach { index in
            localMetarSites[index].distance = Int(LatLon.distance(location, localMetarSites[index].location, .MILES))
        }
        localMetarSites.sort { $0.distance < $1.distance }
        let url = (GlobalVariables.tgftpSitePrefix + "/data/observations/metar/decoded/" + localMetarSites[0].name + ".TXT")
        let html = url.getHtmlSep()
        return html.replace("<br>", GlobalVariables.newline)
    }

    static func findClosestObservation(_ location: LatLon, _ index: Int = 0) -> RID {
        readMetarData()
        var localMetarSites = metarSites
        localMetarSites.indices.forEach { index in
            localMetarSites[index].distance = Int(LatLon.distance(location, localMetarSites[index].location, .MILES))
        }
        localMetarSites.sort { $0.distance < $1.distance }
        return localMetarSites[index]
    }

    static func getObservationSites(_ radarSite: String) -> String {
        var obsListSb = ""
        let radarLocation = LatLon(radarSite: radarSite)
        readMetarData()
        let obsSiteRange = 200.0
        var currentDistance = 0.0
        metarSites.indices.forEach { index in
            currentDistance = LatLon.distance(radarLocation, metarSites[index].location, .MILES)
            if currentDistance < obsSiteRange {
                obsListSb += metarSites[index].name + ","
            }
        }
        return obsListSb.replaceAll(",$", "")
    }

    // used to condense a list of metar that contains multiple entries for one site,
    // newest is first so simply grab first/append
    private static func condenseObs(_ list: [String]) -> [String] {
        var siteMap = [String: Bool]()
        var goodObsList = [String]()
        list.forEach {
            let items = $0.split(" ")
            if items.count > 3 {
                if siteMap[items[0]] != true {
                    siteMap[items[0]] = true
                    goodObsList.append($0)
                }
            }
        }
        return goodObsList
    }
}
