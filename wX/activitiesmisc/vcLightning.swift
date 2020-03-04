/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcLightning: UIwXViewController {
    
    private var image = ObjectTouchImageView()
    private var productButton = ObjectToolbarIcon()
    private var timeButton = ObjectToolbarIcon()
    private var sector = "usa_big"
    private var sectorPretty = "USA"
    private var period = "0.25"
    private var periodPretty = "15 MIN"
    private var firstRun = true
    private var bitmap = Bitmap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(prodClicked))
        timeButton = ObjectToolbarIcon(self, #selector(timeClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                productButton,
                timeButton,
                shareButton
            ]
        ).items
        image = ObjectTouchImageView(self, toolbar)
        initializePreferences()
        self.getContent()
    }
    
    func initializePreferences() {
        sector = Utility.readPref("LIGHTNING_SECTOR", sector)
        period = Utility.readPref("LIGHTNING_PERIOD", period)
        sectorPretty = UtilityLightning.getSectorPretty(sector)
        periodPretty = UtilityLightning.getTimePretty(period)
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.bitmap = UtilityLightning.getImage(self.sector, self.period)
            self.sectorPretty = UtilityLightning.getSectorPretty(self.sector)
            self.periodPretty = UtilityLightning.getTimePretty(self.period)
            DispatchQueue.main.async {
                if self.firstRun {
                    self.image.setBitmap(self.bitmap)
                    self.firstRun = false
                } else {
                    self.image.updateBitmap(self.bitmap)
                }
                self.productButton.title = self.sectorPretty
                self.timeButton.title = self.periodPretty
                Utility.writePref("LIGHTNING_SECTOR", self.sector)
                Utility.writePref("LIGHTNING_PERIOD", self.period)
            }
        }
    }
    
    @objc func prodClicked() {
        _ = ObjectPopUp(self, "Region Selection", productButton, UtilityLightning.sectors, self.sectorChanged(_:))
    }
    
    @objc func timeClicked() {
        _ = ObjectPopUp(self, "Time Selection", timeButton, UtilityLightning.times, self.timeChanged(_:))
    }
    
    func sectorChanged(_ idx: Int) {
        firstRun = true
        self.sectorPretty = UtilityLightning.sectors[idx]
        self.sector = UtilityLightning.getSector(self.sectorPretty)
        self.getContent()
    }
    
    func timeChanged(_ index: Int) {
        self.periodPretty = UtilityLightning.times[index]
        self.period = UtilityLightning.getTime(self.periodPretty)
        self.getContent()
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.image.refresh()
        }
        )
    }
}
