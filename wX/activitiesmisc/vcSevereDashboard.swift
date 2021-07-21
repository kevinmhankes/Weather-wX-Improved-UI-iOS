/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

final class vcSevereDashboard: UIwXViewController {

    private var buttonActions = [String]()
    private var severeNotices = [PolygonEnum: SevereNotice]()
    private var severeWarnings = [PolygonEnum: SevereWarning]()
    private var bitmap = Bitmap()
    private var usAlertsBitmap = Bitmap()
    private var statusButton = ToolbarIcon()
    private let synthesizer = AVSpeechSynthesizer()
    private var statusWarnings = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(share))
        statusButton = ToolbarIcon(self, nil)
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        for notice in [PolygonEnum.SPCWAT, PolygonEnum.SPCMCD, PolygonEnum.WPCMPD] {
            severeNotices[notice] = SevereNotice(notice)
        }
        for notice in [PolygonEnum.TOR, PolygonEnum.TST, PolygonEnum.FFW] {
            severeWarnings[notice] = SevereWarning(notice)
        }
        getContent()
    }

    override func getContent() {
        for notice in [PolygonEnum.SPCWAT, PolygonEnum.SPCMCD, PolygonEnum.WPCMPD] {
            _ = FutureVoid(severeNotices[notice]!.download, display)
        }
        for warning in [PolygonEnum.TOR, PolygonEnum.TST, PolygonEnum.FFW] {
            _ = FutureVoid(severeWarnings[warning]!.download, display)
        }
        getContentUsAlerts()
        getContentSpcStormReports()
    }

    func getContentUsAlerts() {
        _ = FutureVoid({ self.usAlertsBitmap = Bitmap("https://forecast.weather.gov/wwamap/png/US.png") }, display)
    }

    func getContentSpcStormReports() {
        _ = FutureVoid({ self.bitmap = Bitmap(GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + "today" + ".gif") }, display)
    }

    @objc func imageClicked(sender: GestureData) {
        if buttonActions[sender.data].hasPrefix("WPCMPD") {
            Route.spcMcdWatchItem(self, .WPCMPD, buttonActions[sender.data].replace("WPCMPD", ""))
        } else if buttonActions[sender.data].hasPrefix("SPCMCD") {
            Route.spcMcdWatchItem(self, .SPCMCD, buttonActions[sender.data].replace("SPCMCD", ""))
        } else if buttonActions[sender.data].hasPrefix("SPCWAT") {
            Route.spcMcdWatchItem(self, .SPCWAT, buttonActions[sender.data].replace("SPCWAT", ""))
        }
    }

    func showTextWarnings() {
        let wTor = severeWarnings[.TOR]!
        let wTst = severeWarnings[.TST]!
        let wFfw = severeWarnings[.FFW]!
        [wTor, wTst, wFfw].forEach { severeWarning in
            // if severeWarning.getCount() > 0 {
                _ = ObjectCardBlackHeaderText(self, "(" + String(severeWarning.getCount()) + ") " + severeWarning.getName())
                for w in severeWarning.warningList {
                    if w.isCurrent {
                        let radarSite = w.getClosestRadar()
                        stackView.addArrangedSubview(ObjectCardDashAlertItem(
                            w,
                            GestureData(w.url, self, #selector(goToAlert(sender:))),
                            GestureData(radarSite, self, #selector(goToRadar(sender:))),
                            GestureData(radarSite, self, #selector(goToRadar(sender:)))
                        ).get())
                    }
                }
            // }
        }
        if wTor.getCount() > 0 || wTst.getCount() > 0 || wFfw.getCount() > 0 {
            statusWarnings = "(" + wTor.getCount() + "," + wTst.getCount() + "," + wFfw.getCount() + ")"
        } else {
            statusWarnings = ""
        }
    }

    @objc func goToAlerts() {
        goToVC(vcUSAlerts())
    }

    @objc func goToAlert(sender: GestureData) {
        Route.alertDetail(self, sender.strData)
    }

    @objc func goToRadar(sender: GestureData) {
        Route.radarNoSave(self, sender.strData)
    }

    @objc func spcStormReportsClicked() {
        Route.spcStormReports(self, "today")
    }

    @objc func share(sender: UIButton) {
        // TODO
        // UtilityShare.image(self, sender, [bitmap] + snMcd.bitmaps + snWat.bitmaps + snMpd.bitmaps)
    }

    private func display() {
        refreshViews()
        var views = [UIView]()
        buttonActions = [String]()
        var imageCount = 0
        var imagesPerRow = 2
        var imageStackViewList = [ObjectStackView]()
        let noticeCount = getNoticeCount()
        if UtilityUI.isTablet() && UtilityUI.isLandscape() {
            imagesPerRow = 3
        }
        if noticeCount == 0 && UtilityUI.isLandscape() {
            imagesPerRow = 2
        }
        #if targetEnvironment(macCatalyst)
        imagesPerRow = 3
        #endif
//        else if noticeCount == 0 && !UtilityUI.isLandscape() {
//            imagesPerRow = 1
//        }
        let objectImage: ObjectImage
        if imageCount % imagesPerRow == 0 {
            let stackView = ObjectStackView(UIStackView.Distribution.fillEqually, NSLayoutConstraint.Axis.horizontal)
            imageStackViewList.append(stackView)
            self.stackView.addArrangedSubview(stackView.view)
            stackView.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            objectImage = ObjectImage(
                stackView.view,
                usAlertsBitmap,
                UITapGestureRecognizer(target: self, action: #selector(goToAlerts)),
                widthDivider: imagesPerRow
            )
        } else {
            objectImage = ObjectImage(
                imageStackViewList.last!.view,
                usAlertsBitmap,
                UITapGestureRecognizer(target: self, action: #selector(goToAlerts)),
                widthDivider: imagesPerRow
            )
        }
        imageCount += 1
        objectImage.img.accessibilityLabel = "US Alerts"
        objectImage.img.isAccessibilityElement = true
        views.append(objectImage.img)
        let objectImage2: ObjectImage
        if imageCount % imagesPerRow == 0 {
            let stackView = ObjectStackView(UIStackView.Distribution.fillEqually, NSLayoutConstraint.Axis.horizontal)
            imageStackViewList.append(stackView)
            self.stackView.addArrangedSubview(stackView.view)
            objectImage2 = ObjectImage(
                stackView.view,
                bitmap,
                UITapGestureRecognizer(target: self, action: #selector(spcStormReportsClicked)),
                widthDivider: imagesPerRow
            )
        } else {
            objectImage2 = ObjectImage(
                imageStackViewList.last!.view,
                bitmap,
                UITapGestureRecognizer(target: self, action: #selector(spcStormReportsClicked)),
                widthDivider: imagesPerRow
            )
        }
        imageCount += 1
        objectImage2.img.accessibilityLabel = "spc storm reports"
        objectImage2.img.isAccessibilityElement = true
        views.append(objectImage2.img)
        var index = 0
        [PolygonEnum.SPCWAT, PolygonEnum.SPCMCD, PolygonEnum.WPCMPD].forEach { type1 in
            severeNotices[type1]?.bitmaps.enumerated().forEach { imageIndex, image in
                let stackView: UIStackView
                if imageCount % imagesPerRow == 0 {
                    let objectStackView = ObjectStackView(UIStackView.Distribution.fillEqually, NSLayoutConstraint.Axis.horizontal)
                    imageStackViewList.append(objectStackView)
                    stackView = objectStackView.view
                    self.stackView.addArrangedSubview(stackView)
                } else {
                    stackView = imageStackViewList.last!.view
                }
                let objectImage = ObjectImage(
                    stackView,
                    image,
                    GestureData(index, self, #selector(imageClicked)),
                    widthDivider: imagesPerRow
                )
                buttonActions.append(String(describing: type1) + (severeNotices[type1]?.numberList[imageIndex])!)
                objectImage.img.accessibilityLabel = String(describing: type1) + (severeNotices[type1]?.numberList[imageIndex])!
                objectImage.img.isAccessibilityElement = true
                views.append(objectImage.img)
                index += 1
                imageCount += 1
            }
        }
        showTextWarnings()
        view.bringSubviewToFront(toolbar)
        scrollView.accessibilityElements = views
        var status = ""
        let warningLabel = ["W", "M", "P"]
        [PolygonEnum.SPCWAT, PolygonEnum.SPCMCD, PolygonEnum.WPCMPD].enumerated().forEach { index, type1 in
            if (severeNotices[type1]?.bitmaps.count)! > 0 {
                status += warningLabel[index] + "(" + to.String(severeNotices[type1]!.getCount()) + ") "
            }
        }
        statusButton.title = status + " " + statusWarnings
    }

    func getNoticeCount() -> Int {
        var count = 0
        [PolygonEnum.SPCWAT, PolygonEnum.SPCMCD, PolygonEnum.WPCMPD].forEach { type1 in
            count += (severeNotices[type1]?.getCount())!
        }
        return count
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.display() })
    }
}
