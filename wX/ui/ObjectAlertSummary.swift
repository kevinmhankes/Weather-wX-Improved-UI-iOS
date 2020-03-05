/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectAlertSummary: NSObject {

    private var scrollView = UIScrollView()
    private var urls = [String]()
    private var objImage = ObjectImage()
    private var imageIndex = 0
    static let imageUrls = [
        "https://forecast.weather.gov/wwamap/png/US.png",
        "https://forecast.weather.gov/wwamap/png/ak.png",
        "https://forecast.weather.gov/wwamap/png/hi.png"
    ]

    @objc func warningSelected(sender: UITapGestureRecognizerWithData) {}

    convenience init(
        _ uiv: UIViewController,
        _ scrollView: UIScrollView,
        _ stackView: UIStackView,
        _ filter: String,
        _ capAlerts: [CapAlert],
        _ gesture: UITapGestureRecognizer?,
        showImage: Bool = true
    ) {
        self.init()
        self.scrollView = scrollView
        stackView.subviews.forEach {$0.removeFromSuperview()}
        let objTextSummary = ObjectTextView(stackView)
        objTextSummary.addGestureRecognizer(gesture!)
        objTextSummary.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        if showImage {
            objImage = ObjectImage(stackView)
            objImage.addGestureRecognizer(UITapGestureRecognizerWithData(0, uiv, #selector(imageClicked)))
        }
        var index = 0
        var filterBool = true
        var filterLabel = ""
        var state = ""
        var stateCntMap = [String: Int]()
        for alert in capAlerts {
            if filter == "" {
                filterBool = (alert.title.contains("Tornado Warning")
                    || alert.title.contains("Severe Thunderstorm Warning")
                    || alert.title.contains("Flash Flood Warning"))
                filterLabel = "Tornado/ThunderStorm/FFW"
            } else {
                filterBool = (alert.title.hasPrefix(filter))
                filterLabel = filter
            }
            if filterBool {
                var nwsOffice = ""
                var nwsLoc = ""
                if alert.vtec.count > 15 {
                    nwsOffice = alert.vtec.substring(8, 11)
                    nwsLoc = Utility.getWfoSiteName(nwsOffice)
                    state = nwsLoc.substring(0, 2)
                    if stateCntMap.keys.contains(state) {
                        stateCntMap[state] = (stateCntMap[state]! + 1)
                    } else {
                        stateCntMap[state] = 1
                    }
                } else {
                    nwsOffice = ""
                    nwsLoc = ""
                }
                _ = ObjectCardAlertSummaryItem(
                    scrollView,
                    stackView,
                    nwsOffice,
                    nwsLoc,
                    alert,
                    UITapGestureRecognizerWithData(index, uiv, #selector(warningSelected(sender:)))
                )
                self.urls.append(alert.url)
                index += 1
            }
        }
        var stateCnt = ""
        stateCntMap.forEach {stateCnt += "\($0):\($1) "}
        objTextSummary.text = "Filter: " + filterLabel
            + "(" + String(index) + " total)"
            + MyApplication.newline + stateCnt
    }

    func getUrl(_ index: Int) -> String {
        return urls[index]
    }

    @objc func imageClicked() {}

    func changeImage(_ uiv: UIViewController) {
        let vc = vcImageViewer()
        vc.url = ObjectAlertSummary.imageUrls[0]
        uiv.goToVC(vc)
        /*DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(ObjectAlertSummary.imageUrls[self.imageIndex])
            self.imageIndex = (self.imageIndex + 1) % ObjectAlertSummary.imageUrls.count
            DispatchQueue.main.async {
                self.objImage.setBitmap(bitmap)
            }
        }*/
    }
    
    func getImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.imageIndex = 0
            let bitmap = Bitmap(ObjectAlertSummary.imageUrls[self.imageIndex])
            self.imageIndex = (self.imageIndex + 1) % ObjectAlertSummary.imageUrls.count
            DispatchQueue.main.async {
                self.objImage.setBitmap(bitmap)
            }
        }
    }

    var image: Bitmap {
        get {
            return self.objImage.bitmap
        }
        set {
            self.objImage.setBitmap(newValue)
        }
    }
}
