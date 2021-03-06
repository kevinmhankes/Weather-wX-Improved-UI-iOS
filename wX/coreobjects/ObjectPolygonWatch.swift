// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class ObjectPolygonWatch {
    
    static var defaultColors = [PolygonEnum: Int]()
    static var polygonList = [
        PolygonEnum.SPCWAT,
        PolygonEnum.SPCWAT_TORNADO,
        PolygonEnum.SPCMCD,
        PolygonEnum.WPCMPD
    ]
    static var polygonDataByType = [PolygonEnum: ObjectPolygonWatch]()
    static var watchLatlonCombined = DataStorage("WATCH_LATLON_COMBINED")

    var storage = DataStorage("")
    var latLonList  = DataStorage("")
    var numberList  = DataStorage("")
    let type: PolygonEnum
    var timer = DownloadTimer("")

    init(_ type: PolygonEnum) {
        self.type = type
        // isEnabled = Utility.readPref(prefTokenEnabled(), "false").hasPrefix("t")
        storage = DataStorage(prefTokenStorage())
        storage.update()
        latLonList = DataStorage(prefTokenLatLon())
        latLonList.update()
        numberList = DataStorage(prefTokenNumberList())
        numberList.update()
        timer = DownloadTimer("WATCH_" + getTypeName())
    }
    
    func download() {
        if timer.isRefreshNeeded() {
            let html = getUrl().getHtml()
            if html == "" {
                timer.resetTimer()
                return
            }
            storage.value = html
            if type == PolygonEnum.WPCMPD {
                var numberListString = ""
                var latLonString = ""
                let numbers = html.parseColumn(">MPD #(.*?)</a></strong>")
                numbers.forEach { number in
                    let text = UtilityDownload.getTextProduct("WPCMPD" + number)
                    numberListString += number + ":"
                    latLonString += LatLon.storeWatchMcdLatLon(text)
                }
                latLonList.setValue(latLonString)
                numberList.setValue(numberListString)
            } else if type == PolygonEnum.SPCMCD {
                var numberListString = ""
                var latLonString = ""
                let numbers = html.parseColumn("<strong><a href=./products/md/md.....html.>Mesoscale Discussion #(.*?)</a></strong>").map { String(format: "%04d", to.Int($0.replace(" ", ""))) }
                numbers.forEach { number in
                    let text = UtilityDownload.getTextProduct("SPCMCD" + number)
                    numberListString += number + ":"
                    latLonString += LatLon.storeWatchMcdLatLon(text)
                }
                latLonList.setValue(latLonString)
                numberList.setValue(numberListString)
            } else if type == PolygonEnum.SPCWAT {
                var numberListString = ""
                var latLonString = ""
                var latLonTorString = ""
                var latLonCombinedString = ""
                let numbers = html.parseColumn("[om] Watch #([0-9]*?)</a>").map { String(format: "%04d", to.Int($0)).replace(" ", "0") }
                numbers.forEach { number in
                    numberListString += number + ":"
                    let text = (GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/wou" + number + ".html").getHtml()
                    let preText = UtilityString.parseLastMatch(text, GlobalVariables.pre2Pattern)
                    if preText.contains("SEVERE TSTM") {
                        latLonString += LatLon.storeWatchMcdLatLon(preText)
                    } else {
                        latLonTorString += LatLon.storeWatchMcdLatLon(preText)
                    }
                    latLonCombinedString += LatLon.storeWatchMcdLatLon(preText)
                }
                latLonList.setValue(latLonString)
                numberList.setValue(numberListString)
                ObjectPolygonWatch.polygonDataByType[PolygonEnum.SPCWAT_TORNADO]!.latLonList.setValue(latLonTorString)
                ObjectPolygonWatch.watchLatlonCombined.setValue(latLonCombinedString)
            }
        }
    }
    
    func prefTokenLatLon() -> String {
        getTypeName() + "LATLON"
    }

    func prefTokenNumberList() -> String {
        getTypeName() + "NOLIST"
    }

    func prefTokenStorage() -> String {
        "SEVEREDASHBOARD" + getTypeName()
    }

    func getTypeName() -> String {
        String(describing: type).replace("PolygonType.", "")
    }

    func getUrl() -> String {
        var downloadUrl = ""
        if type == PolygonEnum.SPCMCD {
            downloadUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/md/"
        } else if type == PolygonEnum.SPCWAT {
            downloadUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/"
        } else if type == PolygonEnum.SPCWAT_TORNADO {
            downloadUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/"
        } else if type == PolygonEnum.WPCMPD {
            downloadUrl = GlobalVariables.nwsWPCwebsitePrefix + "/metwatch/metwatch_mpd.php"
        }
        return downloadUrl
    }

    static func load( ) {
        initAll()
        for data in ObjectPolygonWatch.polygonList {
            ObjectPolygonWatch.polygonDataByType[data] = ObjectPolygonWatch(data)
        }
    }

    static func initAll() {
        polygonDataByType.removeAll()
        watchLatlonCombined = DataStorage("WATCH_LATLON_COMBINED")
        polygonList.removeAll()
        polygonList.append(PolygonEnum.SPCWAT)
        polygonList.append(PolygonEnum.SPCWAT_TORNADO)
        polygonList.append(PolygonEnum.SPCMCD)
        polygonList.append(PolygonEnum.WPCMPD)
        defaultColors.removeAll()
        defaultColors[PolygonEnum.SPCWAT] = Color.rgb(255, 187, 0)
        defaultColors[PolygonEnum.SPCWAT_TORNADO] = Color.rgb(255, 0, 0)
        defaultColors[PolygonEnum.SPCMCD] = Color.rgb(153, 51, 255)
        defaultColors[PolygonEnum.WPCMPD] = Color.rgb(0, 255, 0)
    }
}
