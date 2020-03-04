/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpcSwo: UIwXViewControllerWithAudio {
    
    private var bitmaps = [Bitmap]()
    private var html = ""
    var spcSwoDay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        let statusButton = ObjectToolbarIcon(title: "Day " + spcSwoDay, self, nil)
        let stateButton = ObjectToolbarIcon(title: "STATE", self, #selector(stateClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                statusButton,
                GlobalVariables.flexBarButton,
                stateButton,
                playButton,
                playListButton,
                shareButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self)
        if spcSwoDay == "48" {
            stateButton.title = ""
        }
        self.getContent()
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.spcSwoDay == "48" {
                self.product = "SWOD" + self.spcSwoDay
                self.html = UtilityDownload.getTextProduct(self.product)
            } else {
                self.product = "SWODY" + self.spcSwoDay
                self.html = UtilityDownload.getTextProduct(self.product)
            }
            self.bitmaps = UtilitySpcSwo.getImageUrls(self.spcSwoDay)
            DispatchQueue.main.async {
                self.refreshViews()
                self.displayContent()
            }
        }
    }
    
    @objc func imageClickedWithIndex(sender: UITapGestureRecognizerWithData) {
        let vc = vcImageViewer()
        vc.imageViewerUrl = bitmaps[sender.data].url
        self.goToVC(vc)
    }
    
    @objc override func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps, self.html)
    }
    
    @objc func stateClicked() {
        let vc = vcSpcSwoState()
        vc.day = spcSwoDay
        self.goToVC(vc)
    }
    
    private func displayContent() {
        _ = ObjectImageAndText(self, bitmaps, &objectTextView, html)
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
