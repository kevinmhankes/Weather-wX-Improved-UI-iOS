/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcCanadaWarnings: UIwXViewController {
    
    private var objectCanadaWarnings: ObjectCanadaWarnings!
    private var provButton = ObjectToolbarIcon()
    private var province = "Canada"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provButton = ObjectToolbarIcon(title: province, self, #selector(provinceClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                provButton,
                shareButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self)
        self.objectCanadaWarnings = ObjectCanadaWarnings(self)
        self.getContent()
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objectCanadaWarnings.getData()
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, self.objectCanadaWarnings.bitmap)
    }
    
    // this is called in objectCanadaWarnings
    @objc func goToWarning(sender: UITapGestureRecognizerWithData) {
        getWarningDetail(objectCanadaWarnings.getWarningUrl(sender.data))
    }
    
    @objc func provinceClicked() {
        _ = ObjectPopUp(self, "Province Selection", provButton, self.objectCanadaWarnings.provList, self.provinceChanged(_:))
    }
    
    func provinceChanged(_ province: String) {
        self.province = province
        self.objectCanadaWarnings.setProvince(province)
        getContent()
    }
    
    func getWarningDetail(_ url: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let data = UtilityCanada.getHazardsFromUrl(url)
            DispatchQueue.main.async {
                let vc = vcTextViewer()
                vc.textViewText = data.replaceAllRegexp("<.*?>", "")
                self.goToVC(vc)
            }
        }
    }
    
    private func displayContent() {
        self.objectCanadaWarnings.showData()
        self.provButton.title = self.province + "(" + (self.objectCanadaWarnings.count) + ")"
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
