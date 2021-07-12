/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcWpcRainfallDiscussion: UIwXViewControllerWithAudio {
    
    private var bitmap = Bitmap()
    private var html = ""
    var day = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ObjectToolbarIcon(title: "Day " + to.String(day + 1), self, nil)
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([
            doneButton,
            statusButton,
            GlobalVariables.flexBarButton,
            playButton,
            playListButton,
            shareButton
        ]).items
        objScrollStackView = ObjectScrollStackView(self)
        getContent()
    }
    
    override func getContent() {
        getContentImage()
        getContentText()
    }
    
    func getContentImage() {
        let imgUrl = UtilityWpcRainfallOutlook.urls[day]
        DispatchQueue.global(qos: .userInitiated).async {
            self.bitmap = Bitmap(imgUrl)
            DispatchQueue.main.async { self.display() }
        }
    }
    
    func getContentText() {
        product = UtilityWpcRainfallOutlook.codes[day]
        DispatchQueue.global(qos: .userInitiated).async {
            self.html = UtilityDownload.getTextProduct(self.product)
            DispatchQueue.main.async { self.display() }
        }
    }
    
    private func display() {
        refreshViews()
        _ = ObjectImageAndText(self, bitmap, html)
    }
    
    @objc func imageClicked() {
        Route.imageViewer(self, UtilityWpcRainfallOutlook.urls[day])
    }
    
    override func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, bitmap, html)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.display() })
    }
}
