/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpcFireOutlook: UIwXViewControllerWithAudio {
    
    private var bitmap = Bitmap()
    private var html = ""
    var dayIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var dayString = String(dayIndex + 1)
        if dayIndex == 2 {
            dayString = "3-8"
        }
        let statusButton = ObjectToolbarIcon(title: "Day " + dayString, self, nil)
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                statusButton,
                GlobalVariables.flexBarButton,
                playButton,
                playListButton,
                shareButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self)
        self.getContent()
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let imgUrl = UtilitySpcFireOutlook.urls[self.dayIndex]
            self.product = UtilitySpcFireOutlook.products[self.dayIndex]
            self.html = UtilityDownload.getTextProduct(self.product)
            self.bitmap = Bitmap(imgUrl)
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }
    
    @objc func imageClicked() {
        let vc = vcImageViewer()
        vc.url = UtilitySpcFireOutlook.urls[dayIndex]
        self.goToVC(vc)
    }
    
    @objc override func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmap, html)
    }
    
    private func displayContent() {
        self.refreshViews()
        _ = ObjectImageAndText(self, bitmap, &objectTextView, html)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.displayContent()
        }
        )
    }
}
