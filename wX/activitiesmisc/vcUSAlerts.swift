/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcUSAlerts: UIwXViewController {

    var capAlerts = [CapAlert]()
    var filter = ""
    var filterButton = ObjectToolbarIcon()
    var objAlertSummary = ObjectAlertSummary()
    var bitmap = Bitmap()
    var filterGesture: UITapGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        filterButton = ObjectToolbarIcon(self, #selector(filterClicked))
        filterGesture = UITapGestureRecognizer(target: self, action: #selector(filterClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, filterButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    func getContent() {
        refreshViews()
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownloadNws.getCap("us")
            let alerts = html.parseColumn("<entry>(.*?)</entry>")
            alerts.forEach {self.capAlerts.append(CapAlert(eventText: $0))}
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc func warningSelected(sender: UITapGestureRecognizerWithData) {
        ActVars.usalertsDetailUrl = objAlertSummary.getUrl(sender.data)
        self.goToVC("usalertsdetail")
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, self.objAlertSummary.image)
    }

    @objc func filterClicked() {
        var eventArr = [String]()
        var counts = [String: Int]()
        var eventArrWithCount = [String]()
        self.capAlerts.forEach {
            eventArr.append($0.event)
        }
        eventArr.forEach {
            counts[$0] = (counts[$0] ?? 0) + 1
        }
        Array(counts.keys).sorted().forEach {
            eventArrWithCount.append("\($0): \(counts[$0]!)")
        }
        _ = ObjectPopUp(self, "Filter Selection", filterButton, eventArrWithCount, self.filterChanged(_:))
    }

    func filterChanged(_ filter: String) {
        self.filterButton.title = filter
        self.objAlertSummary = ObjectAlertSummary(
            self,
            self.stackView,
            filter,
            self.capAlerts,
            self.filterGesture,
            showImage: false
        )
        self.objAlertSummary.image = bitmap
    }

    @objc func imageClicked() {
        self.objAlertSummary.changeImage()
        self.bitmap = self.objAlertSummary.image
    }

    private func displayContent() {
        self.filterButton.title = "Tornado/FFW/ThunderStorm"
        self.objAlertSummary = ObjectAlertSummary(self, self.stackView, "", self.capAlerts, self.filterGesture)
        self.objAlertSummary.changeImage()
        self.bitmap = self.objAlertSummary.image
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
            }
        )
    }
}