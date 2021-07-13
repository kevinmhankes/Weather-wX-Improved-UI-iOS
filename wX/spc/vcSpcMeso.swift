/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSpcMeso: UIwXViewController {

    private var image = TouchImage()
    private var sectorButton = ToolbarIcon()
    private var sfcButton = ToolbarIcon()
    private var uaButton = ToolbarIcon()
    private var cpeButton = ToolbarIcon()
    private var cmpButton = ToolbarIcon()
    private var shrButton = ToolbarIcon()
    private var layerButton = ToolbarIcon()
    private var paramButton = ToolbarIcon()
    private var animateButton = ToolbarIcon()
    private var product = "500mb"
    private var sector = "19"
    private var prefModel = "SPCMESO"
    private let numPanesStr = "1"
    private var firstRun = true
    private let subMenu = MenuData(UtilitySpcMeso.titles, UtilitySpcMeso.params, UtilitySpcMeso.labels)
    var spcMesoFromHomeScreen = false
    var spcMesoToken = ""
    var parameters = [String]()
    private let prefTokenProduct = "SPCMESO1_PARAM_LAST_USED"
    private let prefTokenSector = "SPCMESO1_SECTOR_LAST_USED"

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbarTop = ObjectToolbar()
        layerButton = ToolbarIcon(title: "Layers", self, #selector(layerClicked))
        animateButton = ToolbarIcon(self, .play, #selector(animateClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(share))
        paramButton = ToolbarIcon(self, #selector(showProductMenu))
        toolbarTop.items = ToolbarItems([
            GlobalVariables.flexBarButton,
            paramButton,
            GlobalVariables.fixedSpace,
            layerButton,
            GlobalVariables.fixedSpace,
            animateButton,
            GlobalVariables.fixedSpace,
            shareButton
        ]).items
        sectorButton = ToolbarIcon(title: "Sector", self, #selector(sectorClicked))
        sfcButton = ToolbarIcon(title: "SFC", self, #selector(paramClicked))
        uaButton = ToolbarIcon(title: "UA", self, #selector(paramClicked))
        cpeButton = ToolbarIcon(title: "CPE", self, #selector(paramClicked))
        cmpButton = ToolbarIcon(title: "CMP", self, #selector(paramClicked))
        shrButton = ToolbarIcon(title: "SHR", self, #selector(paramClicked))
        toolbar.items = ToolbarItems([
            doneButton,
            GlobalVariables.flexBarButton,
            sfcButton,
            uaButton,
            cpeButton,
            cmpButton,
            shrButton,
            sectorButton
        ]).items
        view.addSubview(toolbarTop)
        image = TouchImage(self, toolbar, hasTopToolbar: true, topToolbar: toolbarTop)
        image.addGestureRecognizer(#selector(handleSwipes(sender:)))
        toolbarTop.setConfigWithUiv(uiv: self, toolbarType: .top)
        if spcMesoFromHomeScreen {
            product = spcMesoToken
            spcMesoFromHomeScreen = false
            sectorChanged(sector)
        } else {
            product = Utility.readPref(prefTokenProduct, product)
            sectorChanged(Utility.readPref(prefTokenSector, sector))
        }
    }

    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilitySpcMesoInputOutput.getImage(self.product, self.sector)
            DispatchQueue.main.async { self.display(bitmap) }
        }
    }

    private func display(_ bitmap: Bitmap) {
        if firstRun {
            image.setBitmap(bitmap)
            firstRun = false
        } else {
            image.updateBitmap(bitmap)
        }
        paramButton.title = product
        Utility.writePref(prefTokenProduct, product)
        Utility.writePref(prefTokenSector, sector)
    }

    @objc func sectorClicked() {
        _ = ObjectPopUp(self, title: "", sectorButton, UtilitySpcMeso.sectors, sectorChangedByIndex(_:))
    }

    func sectorChangedByIndex(_ index: Int) {
        sector = UtilitySpcMeso.sectorCodes[index]
        sectorButton.title = (UtilitySpcMeso.sectorMapForTitle[sector] ?? "")
        getContent()
    }

    func sectorChanged(_ sector: String) {
        self.sector = sector
        sectorButton.title = (UtilitySpcMeso.sectorMapForTitle[sector] ?? "")
        getContent()
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, image.bitmap)
    }

    @objc func paramClicked(sender: ToolbarIcon) {
        switch sender.title! {
        case "SFC":
            parameters = UtilitySpcMeso.paramSurface
        case "UA":
            parameters = UtilitySpcMeso.paramUpperAir
        case "CPE":
            parameters = UtilitySpcMeso.paramCape
        case "CMP":
            parameters = UtilitySpcMeso.paramComp
        case "SHR":
            parameters = UtilitySpcMeso.paramShear
        default:
            break
        }
        let labels = parameters.map { $0.split(":")[1] }
        _ = ObjectPopUp(self, title: "", sender, labels, productChangedBySubmenu(_:))
    }

    @objc func layerClicked() {
        let alert = ObjectPopUp(self, "Toggle Layers", layerButton)
        ["Radar", "SPC Outlooks", "Watches/Warnings", "Topography"].forEach { layer in
            var pre = ""
            if isLayerSelected(layer) {
                pre = "(on) "
            }
            alert.addAction(UIAlertAction(pre + layer, { _ in self.layerChanged(layer) }))
        }
        alert.finish()
    }

    func layerChanged(_ layer: String) {
        switch layer {
        case "Radar":
            toggleLayer("SPCMESO_SHOW_RADAR")
        case "SPC Outlooks":
            toggleLayer("SPCMESO_SHOW_OUTLOOK")
        case "Watches/Warnings":
            toggleLayer("SPCMESO_SHOW_WATWARN")
        case "Topography":
            toggleLayer("SPCMESO_SHOW_TOPO")
        default:
            break
        }
        getContent()
    }

    func isLayerSelected(_ layer: String) -> Bool {
        var isSelected = "false"
        switch layer {
        case "Radar":
            isSelected = Utility.readPref("SPCMESO_SHOW_RADAR", "false")
        case "SPC Outlooks":
            isSelected = Utility.readPref("SPCMESO_SHOW_OUTLOOK", "false")
        case "Watches/Warnings":
            isSelected = Utility.readPref("SPCMESO_SHOW_WATWARN", "false")
        case "Topography":
            isSelected = Utility.readPref("SPCMESO_SHOW_TOPO", "false")
        default:
            break
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
        _ = ObjectPopUp(self, title: "Select number of animation frames:", animateButton, [6, 12, 18], getAnimation(_:))
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
        _ = ObjectPopUp(self, "", paramButton, subMenu.objTitles, showSubMenu(_:))
    }

    func showSubMenu(_ index: Int) {
        _ = ObjectPopUp(self, paramButton, subMenu.objTitles, index, subMenu, productChanged(_:))
    }

    func productChangedBySubmenu(_ index: Int) {
        product = parameters[index].split(":")[0]
        getContent()
    }

    func productChangedByCode(_ product: String) {
        self.product = product
        getContent()
    }

    func productChanged(_ index: Int) {
        let product = subMenu.params[index]
        self.product = product
        getContent()
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        var index = 0
        if let product = UtilitySpcMeso.productShortList.firstIndex(of: product) {
            index = UtilityUI.sideSwipe(sender, product, UtilitySpcMeso.productShortList)
        }
        productChangedByCode(UtilitySpcMeso.productShortList[index])
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
