/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpcMeso: UIwXViewController {

    var image = ObjectTouchImageView()
    var sectorButton = ObjectToolbarIcon()
    var sfcButton = ObjectToolbarIcon()
    var uaButton = ObjectToolbarIcon()
    var cpeButton = ObjectToolbarIcon()
    var cmpButton = ObjectToolbarIcon()
    var shrButton = ObjectToolbarIcon()
    var layerButton = ObjectToolbarIcon()
    var paramButton = ObjectToolbarIcon()
    var animateButton = ObjectToolbarIcon()
    var product = "500mb"
    var sector = "19"
    var prefModel = "SPCMESO"
    let numPanesStr = "1"
    var firstRun = true
    let subMenu = ObjectMenuData(UtilitySpcMeso.titles, UtilitySpcMeso.params, UtilitySpcMeso.labels)

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let toolbarTop = ObjectToolbar(.top)
        layerButton = ObjectToolbarIcon(title: "Layers", self, #selector(layerClicked))
        animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        paramButton = ObjectToolbarIcon(self, #selector(showProductMenu))
        toolbarTop.items = ObjectToolbarItems(
            [
                GlobalVariables.flexBarButton,
                paramButton,
                GlobalVariables.fixedSpace,
                layerButton,
                GlobalVariables.fixedSpace,
                animateButton,
                GlobalVariables.fixedSpace,
                shareButton
            ]
        ).items
        sectorButton = ObjectToolbarIcon(title: "Sector", self, #selector(sectorClicked))
        sfcButton = ObjectToolbarIcon(title: "SFC", self, #selector(paramClicked))
        uaButton = ObjectToolbarIcon(title: "UA", self, #selector(paramClicked))
        cpeButton = ObjectToolbarIcon(title: "CPE", self, #selector(paramClicked))
        cmpButton = ObjectToolbarIcon(title: "CMP", self, #selector(paramClicked))
        shrButton = ObjectToolbarIcon(title: "SHR", self, #selector(paramClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                sfcButton,
                uaButton,
                cpeButton,
                cmpButton,
                shrButton,
                sectorButton
            ]
        ).items
        image = ObjectTouchImageView(self, toolbar, hasTopToolbar: true)
        image.addGestureRecognizer(#selector(handleSwipes(sender:)))
        self.view.addSubview(toolbarTop)
        self.view.addSubview(toolbar)
        toolbarTop.setConfigWithUiv(uiv: self, toolbarType: .top)
        if ActVars.spcMesoFromHomeScreen {
            product = ActVars.spcMesoToken
            ActVars.spcMesoFromHomeScreen = false
            sectorChanged(sector)
        } else {
            product = Utility.readPref(prefModel + numPanesStr + "_PARAM_LAST_USED", product)
            sectorChanged(Utility.readPref(prefModel + numPanesStr + "_SECTOR_LAST_USED", sector))
        }
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilitySpcMesoInputOutput.getImage(self.product, self.sector)
            DispatchQueue.main.async {
                if self.firstRun {
                    self.image.setBitmap(bitmap)
                    self.firstRun = false
                } else {
                    self.image.updateBitmap(bitmap)
                }
                self.paramButton.title = self.product
                Utility.writePref(self.prefModel + self.numPanesStr + "_PARAM_LAST_USED", self.product)
                Utility.writePref(self.prefModel + self.numPanesStr + "_SECTOR_LAST_USED", self.sector)
            }
        }
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    @objc func sectorClicked() {
        _ = ObjectPopUp(self, "Sector Selection", sectorButton, UtilitySpcMeso.sectors, self.sectorChangedByIndex(_:))
    }

    func sectorChangedByIndex(_ index: Int) {
        self.sector = UtilitySpcMeso.sectorCodes[index]
        self.sectorButton.title = (UtilitySpcMeso.sectorMap[sector] ?? "").truncate(3)
        self.getContent()
    }

    func sectorChanged(_ sector: String) {
        self.sector = sector
        self.sectorButton.title = (UtilitySpcMeso.sectorMap[sector] ?? "").truncate(3)
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }

    @objc func paramClicked(sender: ObjectToolbarIcon) {
        var paramArray = [String]()
        switch sender.title! {
        case "SFC": paramArray = UtilitySpcMeso.paramSurface
        case "UA":  paramArray = UtilitySpcMeso.paramUpperAir
        case "CPE": paramArray = UtilitySpcMeso.paramCape
        case "CMP": paramArray = UtilitySpcMeso.paramComp
        case "SHR": paramArray = UtilitySpcMeso.paramShear
        default: break
        }
        _ = ObjectPopUp(self, "Product Selection", sender, paramArray, self.productChangedByCode(_:))
    }

    @objc func layerClicked(sender: ObjectToolbarIcon) {
        let alert = ObjectPopUp(self, "Toggle Layers", layerButton)
        ["Radar", "SPC Outlooks", "Watches/Warnings", "Topography"].forEach { layer in
            var pre = ""
            if isLayerSelected(layer) {
                pre = "(on) "
            }
            alert.addAction(UIAlertAction(pre + layer, { _ in self.layerChanged(layer)}))
        }
        alert.finish()
    }

    func layerChanged(_ layer: String) {
        switch layer {
        case "Radar":            toggleLayer("SPCMESO_SHOW_RADAR")
        case "SPC Outlooks":     toggleLayer("SPCMESO_SHOW_OUTLOOK")
        case "Watches/Warnings": toggleLayer("SPCMESO_SHOW_WATWARN")
        case "Topography":       toggleLayer("SPCMESO_SHOW_TOPO")
        default: break
        }
        getContent()
    }

    func isLayerSelected(_ layer: String) -> Bool {
        var isSelected = "false"
        switch layer {
        case "Radar":            isSelected = Utility.readPref("SPCMESO_SHOW_RADAR", "false")
        case "SPC Outlooks":     isSelected = Utility.readPref("SPCMESO_SHOW_OUTLOOK", "false")
        case "Watches/Warnings": isSelected = Utility.readPref("SPCMESO_SHOW_WATWARN", "false")
        case "Topography":       isSelected = Utility.readPref("SPCMESO_SHOW_TOPO", "false")
        default: break
        }
        return isSelected == "true"
    }

    func toggleLayer(_ prefVar: String) {
        let currentValue = Utility.readPref(prefVar, "false").hasPrefix("true")
        if currentValue {
            Utility.writePref(prefVar, "false")
        } else {
            Utility.writePref(prefVar, "true")
        }
    }

    @objc func animateClicked() {
        _ = ObjectPopUp(self, "Select number of animation frames:", animateButton, [6, 12, 18], self.getAnimation(_:))
    }

    func getAnimation(_ frameCount: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilitySpcMesoInputOutput.getAnimation(self.sector, self.product, frameCount)
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }

    @objc func showProductMenu() {
        _ = ObjectPopUp(self, "Product Selection", paramButton, subMenu.objTitles, self.showSubMenu(_:))
    }

    func showSubMenu(_ index: Int) {
        _ = ObjectPopUp(self, paramButton, subMenu.objTitles, index, subMenu, self.productChanged(_:))
    }

    func productChangedByCode(_ product: String) {
        self.product = product
        self.getContent()
    }

    func productChanged(_ index: Int) {
        let product = subMenu.params[index]
        self.product = product
        self.getContent()
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        var index = 0
        if let product = UtilitySpcMeso.productShortList.firstIndex(of: self.product) {
            index = UtilityUI.sideSwipe(sender, product, UtilitySpcMeso.productShortList)
        }
        productChangedByCode(UtilitySpcMeso.productShortList[index])
    }
}