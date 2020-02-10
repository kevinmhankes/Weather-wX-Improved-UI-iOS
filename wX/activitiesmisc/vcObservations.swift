/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcObservations: UIwXViewController {

    var image = ObjectTouchImageView()
    var productButton = ObjectToolbarIcon()
    var index = 0
    let prefTokenIndex = "SFC_OBS_IMG_IDX"

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                productButton,
                shareButton
            ]
        ).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)))
        image.setMaxScaleFromMinScale(10.0)
        image.setKZoomInFactorFromMinWhenDoubleTap(8.0)
        self.index = Utility.readPref(prefTokenIndex, 0)
        self.getContent(index)
    }

    @objc func willEnterForeground() {
        self.getContent(index)
    }

    func getContent(_ index: Int) {
        self.index = index
        self.productButton.title = UtilityObservations.labels[self.index]
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(UtilityObservations.urls[self.index])
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                Utility.writePref(self.prefTokenIndex, self.index)
            }
        }
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, "Product Selection", productButton, UtilityObservations.labels, self.getContent(_:))
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityObservations.urls))
    }
}