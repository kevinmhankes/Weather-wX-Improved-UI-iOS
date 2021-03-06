// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcWpcRainfallDiscussion: UIwXViewControllerWithAudio {

    private var bitmap = Bitmap()
    private var html = ""
    var day = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        let statusButton = ToolbarIcon("Day " + to.String(day + 1), self, nil)
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([
            doneButton,
            statusButton,
            GlobalVariables.flexBarButton,
            playButton,
            playListButton,
            shareButton
        ]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        super.doneClicked()
    }

    override func getContent() {
        getImage()
        getText()
    }

    func getImage() {
        let url = UtilityWpcRainfallOutlook.urls[day]
        _ = FutureVoid({ self.bitmap = Bitmap(url) }, display)
    }

    func getText() {
        product = UtilityWpcRainfallOutlook.codes[day]
        _ = FutureVoid({ self.html = UtilityDownload.getTextProduct(self.product) }, display)
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
        coordinator.animate(alongsideTransition: nil) { _ in self.display() }
    }
}
