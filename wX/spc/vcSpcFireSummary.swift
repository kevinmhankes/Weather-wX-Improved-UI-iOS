/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpcFireSummary: UIwXViewController {

    var bitmaps = [Bitmap]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        getContent()
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    func getContent() {
        refreshViews()
        DispatchQueue.global(qos: .userInitiated).async {
            self.bitmaps = UtilitySpcFireOutlook.urls.map {Bitmap($0)}
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        ActVars.wpcTextProduct = UtilitySpcFireOutlook.products[sender.data]
        self.goToVC("WPCText")
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps)
    }

    private func displayContent() {
        var views = [UIView]()
        var dayNumber = 0
        self.bitmaps.enumerated().forEach {
            let objectImage = ObjectImage(
                self.stackView,
                $1,
                UITapGestureRecognizerWithData($0, self, #selector(self.imageClicked(sender:)))
            )
            objectImage.img.isAccessibilityElement = true
            views += [objectImage.img]
            dayNumber += 1
            objectImage.img.accessibilityLabel = "day " + String(dayNumber)
        }
        self.accessibilityElements = views
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