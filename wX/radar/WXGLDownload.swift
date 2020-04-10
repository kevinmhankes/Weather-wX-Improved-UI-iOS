/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class WXGLDownload {
    
    private static let utilnxanimPattern1 = ">(sn.[0-9]{4})</a>"
    private static let utilnxanimPattern2 = ".*?([0-9]{2}-[A-Za-z]{3}-[0-9]{4} [0-9]{2}:[0-9]{2}).*?"
    static var nwsRadarPub = "https://tgftp.nws.noaa.gov/"
    private static var nwsRadarLevel2Pub = "https://nomads.ncep.noaa.gov/pub/data/nccf/radar/nexrad_level2/"
    private var radarSite = ""
    private var prod = ""
    
    static func getNidsTab(_ product: String, _ radarSite: String, _ fileName: String) {
        /*let ridPrefix = WXGLDownload().getRidPrefix(radarSite, false)
        let url = WXGLDownload.nwsRadarPub + "SL.us008001/DF.of/DC.radar/"
            + GlobalDictionaries.nexradProductString[product]! + "/SI."
            + ridPrefix + radarSite.lowercased() + "/sn.last"*/
        let url = WXGLDownload().getRadarFileUrl(radarSite, product, false)
        let inputstream = url.getDataFromUrl()
        UtilityIO.saveInputStream(inputstream, fileName)
    }
    
    func getRidPrefix(_ radarSite: String, _ tdwr: Bool) -> String {
        if tdwr {
            return ""
        } else {
            switch radarSite {
            case "JUA":
                return "t"
            case "HKI", "HMO", "HKM", "HWA", "APD", "ACG", "AIH", "AHG", "AKC", "ABC", "AEC", "GUA":
                return "p"
            default:
                return "k"
            }
        }
    }
    
    func getRidPrefix(_ radarSite: String, _ product: String) -> String {
        //var ridPrefix = "k"
        if product=="TV0" || product=="TZL" || product=="TR0" || product=="TZ0" {
            return ""
        } else {
            switch radarSite {
            case "JUA":
                return "t"
            case "HKI", "HMO", "HKM", "HWA", "APD", "ACG", "AIH", "AHG", "AKC", "ABC", "AEC", "GUA":
                return "p"
            default:
                return "k"
            }
        }
    }
    
    func getRadarFileUrl(_ radarSite: String, _ product: String, _ tdwr: Bool) -> String {
        let ridPrefix = getRidPrefix(radarSite, tdwr)
        let productString = GlobalDictionaries.nexradProductString[product] ?? ""
        return WXGLDownload.nwsRadarPub + "SL.us008001/DF.of/DC.radar/" + productString + "/SI." + ridPrefix + radarSite.lowercased() + "/sn.last"
    }
    
    func getRadarFile(_ urlStr: String, _ rid: String, _ prod: String, _ idxStr: String, _ tdwr: Bool) -> String {
        let l2BaseFn = "l2"
        let l3BaseFn = "nids"
        let ridPrefix = getRidPrefix(rid, tdwr)
        self.radarSite = rid
        self.prod = prod
        //let ridPrefixGlobal = ridPrefix
        //let productId = GlobalDictionaries.nexradProductString[prod] ?? ""
        if !prod.contains("L2") {
            //let data = (WXGLDownload.nwsRadarPub
            //    + "SL.us008001/DF.of/DC.radar/" + productId + "/SI."
            //    + ridPrefix + rid.lowercased() + "/sn.last").getDataFromUrl()
            let data = getRadarFileUrl(radarSite, prod, tdwr).getDataFromUrl()
            UtilityIO.saveInputStream(data, l3BaseFn + idxStr)
        } else {
            if urlStr == "" {
                let data = getInputStreamFromURLL2(getLevel2Url())
                UtilityIO.saveInputStream(data, l2BaseFn + "_d" + idxStr)
            }
            UtilityFileManagement.deleteFile(l2BaseFn + idxStr)
            UtilityFileManagement.moveFile(l2BaseFn + "_d" + idxStr, l2BaseFn + idxStr)
        }
        return ridPrefix
    }
    
    // Download a list of files and return the list as a list of Strings
    // Determines of Level 2 or Level 3 and calls appropriate method
    func getRadarFilesForAnimation(_ frameCount: Int) -> [String] {
        var listOfFiles = [String]()
        let ridPrefix = getRidPrefix(radarSite, prod)
        if !prod.contains("L2") {
            listOfFiles = getLevel3FilesForAnimation(frameCount, prod, ridPrefix, radarSite.lowercased())
        } else {
            listOfFiles = getLevel2FilesForAnimation(WXGLDownload.nwsRadarLevel2Pub
                + ridPrefix.uppercased() + radarSite.uppercased() + "/", frameCount)
        }
        return listOfFiles
    }
    
    func getRadarDirectoryUrl(_ radarSite: String, _ product: String, _ ridPrefix: String) -> String {
        let productString = GlobalDictionaries.nexradProductString[product] ?? ""
        return WXGLDownload.nwsRadarPub + "SL.us008001/DF.of/DC.radar/" + productString + "/SI." + ridPrefix + radarSite.lowercased() + "/"
    }
    
    // Level 3: Download a list of files and return the list as a list of Strings
    private func getLevel3FilesForAnimation(_ frameCount: Int, _ product: String, _ ridPrefix: String, _ rid: String) -> [String] {
        var listOfFiles = [String]()
        //let productId = GlobalDictionaries.nexradProductString[prod] ?? ""
        //let html = (WXGLDownload.nwsRadarPub + "SL.us008001/DF.of/DC.radar/" + productId + "/SI." + ridPrefix + rid.lowercased() + "/").getHtml()
        let html = getRadarDirectoryUrl(radarSite, product, ridPrefix).getHtml()
        var snFiles = html.parseColumn(WXGLDownload.utilnxanimPattern1)
        var snDates = html.parseColumn(WXGLDownload.utilnxanimPattern2)
        if snDates.count == 0 {
            //let html = (WXGLDownload.nwsRadarPub + "SL.us008001/DF.of/DC.radar/" + productId + "/SI." + ridPrefix + rid.lowercased() + "/").getHtml()
            let html = getRadarDirectoryUrl(radarSite, product, ridPrefix).getHtml()
            snFiles = html.parseColumn(WXGLDownload.utilnxanimPattern1)
            snDates = html.parseColumn(WXGLDownload.utilnxanimPattern2)
        }
        if snDates.count == 0 {
            //let html = (WXGLDownload.nwsRadarPub + "SL.us008001/DF.of/DC.radar/" + productId + "/SI." + ridPrefix + rid.lowercased() + "/").getHtml()
            let html = getRadarDirectoryUrl(radarSite, product, ridPrefix).getHtml()
            snFiles = html.parseColumn(WXGLDownload.utilnxanimPattern1)
            snDates = html.parseColumn(WXGLDownload.utilnxanimPattern2)
        }
        var mostRecentSn = ""
        let mostRecentTime = snDates.last
        (0..<snDates.count - 1).forEach { index in
            if snDates[index] == mostRecentTime {
                mostRecentSn = snFiles[index]
            }
        }
        let seq = Int(mostRecentSn.replace("sn.", "")) ?? 0
        var index = seq - frameCount + 1
        (0..<frameCount).forEach { _ in
            var tmpK = index
            if tmpK < 0 {
                tmpK += 251
            }
            listOfFiles.append("sn." + String(format: "%04d", tmpK))
            index += 1
        }
        (0..<frameCount).forEach { index in
            /*let data = (WXGLDownload.nwsRadarPub
                + "SL.us008001/DF.of/DC.radar/"
                + GlobalDictionaries.nexradProductString[prod]!
                + "/SI." + ridPrefix + rid.lowercased()
                + "/" + listOfFiles[index]).getDataFromUrl()*/
            let data = (getRadarDirectoryUrl(radarSite, product, ridPrefix) + listOfFiles[index]).getDataFromUrl()
            UtilityIO.saveInputStream(data, listOfFiles[index])
        }
        return listOfFiles
    }
    
    // Level 2: Download a list of files and return the list as a list of Strings
    private func getLevel2FilesForAnimation(_ baseUrl: String, _ frameCnt: Int) -> [String] {
        var listOfFiles = [String]()
        let list = (baseUrl + "dir.list").getHtmlSep().replace("\n", " ").split(" ")
        var additionalAdd = 0
        let fnSize = Int(list[list.count - 3]) ?? 0
        let fnPrevSize = Int(list[list.count - 5]) ?? 0
        let ratio = Double(fnSize) / Double(fnPrevSize)
        if ratio < 0.75 {
            additionalAdd = 1
        }
        (0..<frameCnt).forEach { index in
            listOfFiles.append(list[list.count - (frameCnt - index + additionalAdd) * 2])
            let data = getInputStreamFromURLL2(baseUrl + listOfFiles[index])
            UtilityIO.saveInputStream(data, listOfFiles[index])
        }
        return listOfFiles
    }
    
    private func getLevel2Url() -> String {
        let ridPrefix = getRidPrefix(radarSite, false).uppercased()
        let baseUrl = WXGLDownload.nwsRadarLevel2Pub + ridPrefix + radarSite + "/"
        let html = (baseUrl + "dir.list").getHtmlSep()
        var sizes = [String]()
        html.split("\n").forEach { line in
            sizes.append(line.split(" ")[0])
        }
        sizes.removeLast()
        let tmpArr = html.replace("<br>", " ").split(" ")
        if tmpArr.count < 4 {
            return ""
        }
        var fileName = tmpArr[tmpArr.count - 1].split("\n")[0]
        let fnPrev = tmpArr[tmpArr.count - 2].split("\n")[0]
        let fnSize = Int(sizes[sizes.count - 1]) ?? 1
        let fnPrevSize = Int(sizes[sizes.count - 2]) ?? 1
        let ratio = Double(fnSize) / Double(fnPrevSize)
        if ratio < 0.75 {
            fileName = fnPrev
        }
        return baseUrl + fileName
    }
    
    private func getInputStreamFromURLL2(_ url: String) -> Data {
        let byteEnd = "3000000"
        let myJustDefaults = JustSessionDefaults(headers: ["Range": "bytes=0-" + byteEnd])
        let just = JustOf<HTTP>(defaults: myJustDefaults)
        let result = just.get(url)
        return result.content ?? Data()
    }
}
