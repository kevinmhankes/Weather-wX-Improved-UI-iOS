/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectAlertSummary: NSObject {

    private var urls = [String]()
    var wfos = [String]()
    private var objectImage = ObjectImage()
    private var imageIndex = 0
    static let imageUrls = [
        "https://forecast.weather.gov/wwamap/png/US.png",
        "https://forecast.weather.gov/wwamap/png/ak.png",
        "https://forecast.weather.gov/wwamap/png/hi.png"
    ]

    @objc func warningSelected(sender: GestureData) {}

    @objc func goToRadar(sender: GestureData) {}

    convenience init(
        _ uiv: UIwXViewController,
        _ filter: String,
        _ capAlerts: [CapAlert],
        _ gesture: UITapGestureRecognizer?,
        showImage: Bool = true
    ) {
        self.init()
        uiv.stackView.removeViews()
        let objTextSummary = Text(uiv.stackView)
        objTextSummary.addGestureRecognizer(gesture!)
        objTextSummary.view.widthAnchor.constraint(equalTo: uiv.scrollView.widthAnchor).isActive = true
        if showImage {
            objectImage = ObjectImage(uiv.stackView)
            objectImage.addGestureRecognizer(GestureData(0, uiv, #selector(imageClicked)))
        }
        var index = 0
        var filterBool = true
        var filterLabel = ""
        var stateCntMap = [String: Int]()
        capAlerts.forEach { alert in
            if filter == "" {
                filterBool = (alert.title.contains("Tornado Warning") || alert.title.contains("Severe Thunderstorm Warning") || alert.title.contains("Flash Flood Warning"))
                filterLabel = "Tornado/ThunderStorm/FFW"
            } else {
                filterBool = alert.title.hasPrefix(filter)
                filterLabel = filter
            }
            if filterBool {
                let nwsOffice: String
                let nwsLocation: String
                if alert.vtec.count > 15 {
                    nwsOffice = alert.vtec.substring(8, 11)
                    nwsLocation = Utility.getWfoSiteName(nwsOffice)
                    let state = nwsLocation.substring(0, 2)
                    if stateCntMap.keys.contains(state) {
                        stateCntMap[state] = (stateCntMap[state]! + 1)
                    } else {
                        stateCntMap[state] = 1
                    }
                } else {
                    nwsOffice = ""
                    nwsLocation = ""
                }
                _ = ObjectCardAlertSummaryItem(
                    uiv,
                    nwsOffice,
                    nwsLocation,
                    alert,
                    GestureData(index, uiv, #selector(warningSelected(sender:))),
                    GestureData(index, uiv, #selector(goToRadar(sender:))),
                    GestureData(index, uiv, #selector(goToRadar(sender:)))
                )
                urls.append(alert.url)
                wfos.append(nwsOffice)
                index += 1
            }
        }
        var stateCnt = ""
        stateCntMap.forEach { state, count in stateCnt += state + ":" + String(count) + " " }
        objTextSummary.text = "Total alerts: " + String(capAlerts.count) + GlobalVariables.newline + "Filter: " + filterLabel + "(" + String(index) + " total)" + GlobalVariables.newline + "State counts: " + stateCnt
    }

    func getUrl(_ index: Int) -> String {
        urls[index]
    }

    @objc func imageClicked() {}

    func changeImage(_ uiv: UIViewController) {
        Route.imageViewer(uiv, ObjectAlertSummary.imageUrls[0])
    }

    func getImage() {
        imageIndex = 0
        _ = FutureBytes2({ Bitmap(ObjectAlertSummary.imageUrls[self.imageIndex]) }, objectImage.setBitmap)
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.imageIndex = 0
//            let bitmap = Bitmap(ObjectAlertSummary.imageUrls[self.imageIndex])
//            self.imageIndex = (self.imageIndex + 1) % ObjectAlertSummary.imageUrls.count
//            DispatchQueue.main.async { self.objectImage.setBitmap(bitmap) }
//        }
    }

    var image: Bitmap {
        get { objectImage.bitmap }
        set { objectImage.setBitmap(newValue) }
    }
}
