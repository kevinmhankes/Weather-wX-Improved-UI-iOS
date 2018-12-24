/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import Metal

class ViewControllerTABLOCATIONGL: ViewControllerTABPARENT {

    var locationButton = UITextView()
    var forecastText = [String]()
    var forecastImage = [UIImage]()
    var menuButton = ObjectToolbarIcon()
    var lastRefresh: Int64 = 0
    var currentTime: Int64 = 0
    var currentTimeSec: Int64 = 0
    var refreshIntervalSec: Int64 = 0
    var objFcst = ObjectForecastPackage()
    var objHazards = ObjectForecastPackageHazards()
    var objSevenDay = ObjectForecastPackage7Day()
    var textArr = [String: String]()
    var timeButton = ObjectToolbarIcon()
    var oldLocation = LatLon()
    var isUS = true
    var isUSDisplayed = true
    var objLabel = ObjectTextView()
    var stackViewCurrentConditions: ObjectStackView!
    var stackViewForecast: ObjectStackView!
    var stackViewHazards: ObjectStackView!
    var stackViewRadar = ObjectStackViewHS()
    var ccCard: ObjectCardCC?
    var objCard7DayCollection: ObjectCard7DayCollection?
    var extraDataCards = [ObjectStackViewHS]()
    
    var wxMetal = [WXMetalRender?]()
    var metalLayer = [CAMetalLayer?]()
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var timer: CADisplayLink!
    var projectionMatrix: Matrix4!
    var lastFrameTimestamp: CFTimeInterval = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        ActVars.vc = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        let toolbar = ObjectToolbar(.top)
        let radarButton = ObjectToolbarIcon(self, "ic_flash_on_24dp", #selector(radarClicked))
        let cloudButton = ObjectToolbarIcon(self, "ic_cloud_24dp", #selector(cloudClicked))
        let wfoTextButton = ObjectToolbarIcon(self, "ic_info_outline_24dp", #selector(wfotextClicked))
        menuButton = ObjectToolbarIcon(self, "ic_more_vert_white_24dp", #selector(menuClicked))
        let dashButton = ObjectToolbarIcon(self, "ic_report_24dp", #selector(dashClicked))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace,
                                         target: nil,
                                         action: nil)
        fixedSpace.width = UIPreferences.toolbarIconSpacing
        /*toolbar.items = ObjectToolbarItems([flexBarButton,
                                            dashButton,
                                            wfoTextButton,
                                            cloudButton,
                                            radarButton,
                                            menuButton]).items*/
        
        if UIPreferences.mainScreenRadarFab {
            toolbar.items = ObjectToolbarItems([flexBarButton,
                                                dashButton,
                                                wfoTextButton,
                                                cloudButton,
                                                menuButton]).items
        } else {
            toolbar.items = ObjectToolbarItems([flexBarButton,
                                                dashButton,
                                                wfoTextButton,
                                                cloudButton,
                                                radarButton,
                                                menuButton]).items
        }
        
        stackView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 10.0).isActive = true
        _ = ObjectScrollStackView(self, scrollView, stackView, .TAB)
        self.view.addSubview(toolbar)
        self.stackViewCurrentConditions = ObjectStackView(.fill, .vertical)
        self.stackViewForecast = ObjectStackView(.fill, .vertical)
        self.stackViewHazards = ObjectStackView(.fill, .vertical)
        addLocationSelectionCard()
        self.getContentMaster()
    }

    func getContentMaster() {
        self.oldLocation = Location.latlon
        if Location.isUS {
            self.isUS = true
        } else {
            self.isUS = false
        }
        clearViews()
        getForecastData()
        getContent()
    }

    func getForecastData() {
        getLocationForecast()
        getLocationForecastSevenDay()
        getLocationHazards()
        if fab != nil {
            self.view.bringSubviewToFront(fab!.view)
        }
    }

    func getLocationForecast() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objFcst = Utility.getCurrentConditionsV2(Location.getCurrentLocation())
            DispatchQueue.main.async {
                self.getCurrentConditionCards(self.stackViewCurrentConditions.view)
            }
        }
    }

    func getLocationForecastSevenDay() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objSevenDay = Utility.getCurrentSevenDay(Location.getCurrentLocation())
            self.objSevenDay.locationIndex = Location.getCurrentLocation()
            DispatchQueue.main.async {
                if self.objCard7DayCollection == nil
                    || !self.isUS
                    || self.objSevenDay.locationIndex != self.objCard7DayCollection?.locationIndex {
                    self.stackViewForecast.view.subviews.forEach {$0.removeFromSuperview()}
                    self.objCard7DayCollection = ObjectCard7DayCollection(
                        self.stackViewForecast.view,
                        self.scrollView,
                        self.objSevenDay,
                        self.isUS
                    )
                    self.objCard7DayCollection?.locationIndex = Location.getCurrentLocation()
                } else {
                    self.objCard7DayCollection?.update(
                        self.objSevenDay,
                        self.isUS
                    )
                }
            }
        }
    }

    func getLocationHazards() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objHazards = Utility.getCurrentHazards(Location.getCurrentLocation())
            DispatchQueue.main.async {
                if ObjectForecastPackageHazards.getHazardCount(self.objHazards) > 0 {
                    ObjectForecastPackageHazards.getHazardCards(self.stackViewHazards.view, self.objHazards, self.isUS)
                    self.stackViewHazards.view.isHidden = false
                } else {
                    self.stackViewHazards.view.isHidden = true
                }
            }
        }
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            if Location.isUS {
                self.isUS = true
            } else {
                self.isUS = false
                self.objHazards.hazards = self.objHazards.hazards.replaceAllRegexp("<.*?>", "")
            }
            DispatchQueue.main.async {
                let homescreenFav = TextUtils.split(preferences.getString("HOMESCREEN_FAV",
                                                                          MyApplication.homescreenFavDefault), ":")
                self.textArr = [:]
                homescreenFav.forEach {
                    switch $0 {
                    case "TXT-CC2":
                        self.stackView.addArrangedSubview(self.stackViewCurrentConditions.view)
                    case "TXT-HAZ":
                        self.stackView.addArrangedSubview(self.stackViewHazards.view)
                    case "TXT-7DAY2":
                        self.stackView.addArrangedSubview(self.stackViewForecast.view)
                    case "METAL-RADAR":
                        self.stackView.addArrangedSubview(self.stackViewRadar)
                        self.getNexradRadar($0.split("-")[1], self.stackViewRadar)
                    default:
                        let stackViewLocal = ObjectStackViewHS()
                        stackViewLocal.setup()
                        self.extraDataCards.append(stackViewLocal)
                        self.stackView.addArrangedSubview(stackViewLocal)
                        if $0.hasPrefix("TXT-") {
                            self.getContentText($0.split("-")[1], stackViewLocal)
                        } else if $0.hasPrefix("IMG-") {
                            self.getContentImage($0.split("-")[1], stackViewLocal)
                        }
                        //} else if $0.hasPrefix("METAL-") {
                        //    self.getNexradRadar($0.split("-")[1], stackViewLocal)
                        //}
                        // "METAL-RADAR": "Local NEXRAD Radar"
                    }
                }
                self.lastRefresh = UtilityTime.currentTimeMillis64() / Int64(1000)
            }
        }
    }

    @objc override func cloudClicked() {
        UtilityActions.cloudClicked(self)
    }

    @objc override func radarClicked() {
        UtilityActions.radarClicked(self)
    }

    @objc override func wfotextClicked() {
        UtilityActions.wfotextClicked(self)
    }

    @objc override func menuClicked() {
        UtilityActions.menuClicked(self, menuButton)
    }

    @objc override func dashClicked() {
        UtilityActions.dashClicked(self)
    }

    @objc func willEnterForeground() {
        scrollView.scrollToTop()
        currentTime = UtilityTime.currentTimeMillis64()
        currentTimeSec = currentTime / 1000
        refreshIntervalSec = Int64(UIPreferences.refreshLocMin) * Int64(60)
        if currentTimeSec > (lastRefresh + refreshIntervalSec) {
            self.getContentMaster()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ActVars.vc = self
        Location.checkCurrentLocationValidity()
        if Location.latlon != oldLocation {
            self.getContentMaster()
        }
    }

    func locationChanged(_ locationNumber: Int) {
        if locationNumber < Location.numLocations {
            Location.setCurrentLocationStr(String(locationNumber + 1))
            editor.putString("CURRENT_LOC_FRAGMENT", String(locationNumber + 1))
            self.objLabel.text = Location.name
            self.getContentMaster()
        } else {
            ActVars.settingsLocationEditNum = "0"
            self.goToVC("settingslocationedit")
        }
    }

    func editLocation() {
        ActVars.settingsLocationEditNum = Location.getCurrentLocationStr()
        self.goToVC("settingslocationedit")
    }

    func sunMoonData() {
        self.goToVC("sunmoondata")
    }

    @objc func locationAction() {
        let alert = UIAlertController(title: "Select location:",
                                      message: "",
                                      preferredStyle: UIAlertController.Style.actionSheet)
        MyApplication.locations.indices.forEach { location in
            let action = UIAlertAction(title: Location.getName(location),
                                       style: .default,
                                       handler: {_ in self.locationChanged(location)})
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Add location..",
                                      style: .default,
                                      handler: {_ in self.locationChanged(Location.numLocations)}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = self.menuButton
        }
        self.present(alert, animated: true, completion: nil)
    }

    @objc func ccAction() {
        let alert2 = UIAlertController(title: "Select from:",
                                       message: "",
                                       preferredStyle: UIAlertController.Style.actionSheet)
        alert2.addAction(UIAlertAction(title: "Edit location..", style: .default, handler: {_ in self.editLocation()}))
        alert2.addAction(UIAlertAction(title: "Sun/Moon data..", style: .default, handler: {_ in self.sunMoonData()}))
        alert2.addAction(UIAlertAction(title: "Refresh data", style: .default, handler: {_ in self.getContentMaster()}))
        alert2.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert2.popoverPresentationController {
            popoverController.barButtonItem = self.menuButton
        }
        self.present(alert2, animated: true, completion: nil)
    }

    func getCurrentConditionCards(_ stackView: UIStackView) {
        let tapOnCC1 = UITapGestureRecognizer(target: self, action: #selector(self.ccAction))
        let tapOnCC2 = UITapGestureRecognizer(target: self, action: #selector(self.ccAction))
        let tapOnCC3 = UITapGestureRecognizer(target: self, action: #selector(self.ccAction))
        if ccCard == nil {
            ccCard = ObjectCardCC(stackView, objFcst, isUS)
            ccCard?.addGestureRecognizer(tapOnCC1, tapOnCC2, tapOnCC3)
        } else {
            ccCard?.updateCard(objFcst, isUS)
        }
    }

    func getContentText(_ product: String, _ stackView: UIStackView) {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownload.getTextProduct(product)
            DispatchQueue.main.async {
                self.textArr[product] = html
                let objTv = ObjectTextView(stackView, html.truncate(UIPreferences.homescreenTextLength))
                objTv.addGestureRecognizer(
                    UITapGestureRecognizerWithData(product, self, #selector(self.textTap(sender:)))
                )
            }
        }
    }

    @objc func textTap(sender: UITapGestureRecognizerWithData) {
        if let v = sender.view as? UITextView {
            let currentLength = v.text!.count
            if currentLength < (UIPreferences.homescreenTextLength + 1) {
                v.text = textArr[sender.strData]
            } else {
                v.text = textArr[sender.strData]?.truncate(UIPreferences.homescreenTextLength)
            }
        }
    }

    func getContentImage(_ product: String, _ stackView: UIStackView) {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityDownload.getImageProduct(product)
            DispatchQueue.main.async {
                let imgObj = ObjectImage(stackView, bitmap, hs: true)
                imgObj.addGestureRecognizer(
                    UITapGestureRecognizerWithData(product, self, #selector(self.imageTap(sender:)))
                )
            }
        }
    }

    func getNexradRadar(_ product: String, _ stackView: UIStackView) {
        let ortInt: Float = 350.0
        let numberOfPanes = 1
        let paneRange = [0]
        let device = MTLCreateSystemDefaultDevice()
        let screenSize: CGSize = UIScreen.main.bounds.size
        let screenWidth = Float(screenSize.width)
        let screenHeight = screenWidth
        let carect = CGRect(
            x: 0,
            y: 0,
            width: CGFloat(screenWidth),
            height: CGFloat(screenWidth)
        )
        let caview = UIView(frame: carect)
        caview.widthAnchor.constraint(equalToConstant: CGFloat(screenWidth)).isActive = true
        caview.heightAnchor.constraint(equalToConstant: CGFloat(screenWidth)).isActive = true
        let surfaceRatio = Float(screenWidth)/Float(screenHeight)
        projectionMatrix = Matrix4.makeOrthoViewAngle(-1.0 * ortInt, right: ortInt,
                                                      bottom: -1.0 * ortInt * (1.0 / surfaceRatio),
                                                      top: ortInt * (1 / surfaceRatio), nearZ: -100.0, farZ: 100.0)
        paneRange.enumerated().forEach { index, _ in
            metalLayer.append(CAMetalLayer())
            metalLayer[index]!.device = device
            metalLayer[index]!.pixelFormat = .bgra8Unorm
            metalLayer[index]!.framebufferOnly = true
        }
        metalLayer[0]!.frame = CGRect(
            x: 0,
            y: 0,
            width: CGFloat(screenWidth),
            height: CGFloat(screenWidth)
        )
        metalLayer.forEach { caview.layer.addSublayer($0!) }
        stackView.addArrangedSubview(caview)
        paneRange.forEach {
            wxMetal.append(WXMetalRender(device!, ObjectToolbarIcon(), ObjectToolbarIcon(), paneNumber: $0, numberOfPanes))
        }
        let defaultLibrary = device?.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary?.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary?.makeFunction(name: "basic_vertex")
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
            pipelineState = try device?.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch {
            print("error init pipelineState")
        }
        commandQueue = device?.makeCommandQueue()
        //let timer = CADisplayLink(target: self, selector: #selector(ViewControllerTABLOCATIONGL.newFrame(displayLink:)))
        //timer.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        wxMetal[0]!.setRenderFunction(render)
        wxMetal[0]!.resetRidAndGet(Location.rid)
        self.render()
        getPolygonWarnings()
    }
    
    func getPolygonWarnings() {
        DispatchQueue.global(qos: .userInitiated).async {
            UtilityPolygons.getData()
            DispatchQueue.main.async {
                if self.wxMetal[0] != nil {
                    self.wxMetal.forEach { $0!.constructAlertPolygons() }
                }
            }
        }
    }
    
    func modelMatrix(_ index: Int) -> Matrix4 {
        let matrix = Matrix4()
        matrix.translate(wxMetal[index]!.xPos, y: wxMetal[index]!.yPos, z: wxMetal[index]!.zPos)
        matrix.rotateAroundX(0, y: 0, z: 0)
        matrix.scale(wxMetal[index]!.zoom, y: wxMetal[index]!.zoom, z: wxMetal[index]!.zoom)
        return matrix
    }
    
    func render() {
        wxMetal.enumerated().forEach { index, wxmetal in
            guard let drawable = metalLayer[index]!.nextDrawable() else { return }
            wxmetal!.render(commandQueue: commandQueue,
                            pipelineState: pipelineState,
                            drawable: drawable,
                            parentModelViewMatrix: modelMatrix(index),
                            projectionMatrix: projectionMatrix,
                            clearColor: nil) // was MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
        }
    }
    
    @objc func newFrame(displayLink: CADisplayLink) {
        if lastFrameTimestamp == 0.0 {
            lastFrameTimestamp = displayLink.timestamp
        }
        let elapsed: CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
        lastFrameTimestamp = displayLink.timestamp
        radarLoop(timeSinceLastUpdate: elapsed)
    }
    
    func radarLoop(timeSinceLastUpdate: CFTimeInterval) {
        autoreleasepool {
            if wxMetal[0] != nil {
                self.render()
            }
        }
    }

    @objc func imageTap(sender: UITapGestureRecognizerWithData) {
        var token = ""
        switch sender.strData {
        case "VIS_1KM":
            token = "wpcimg"
        case "FMAP":
            token = "wpcimg"
        case "VIS_CONUS":
            ActVars.goesSector = "CONUS"
            ActVars.goesProduct = "02"
            token = "goes16"
        case "CONUSWV":
            ActVars.goesSector = "CONUS"
            ActVars.goesProduct = "09"
            token = "goes16"
        case "SWOD1":
            ActVars.spcswoDay = "1"
            token = "spcswo"
        case "SWOD2":
            ActVars.spcswoDay = "2"
            token = "spcswo"
        case "SWOD3":
            ActVars.spcswoDay = "3"
            token = "spcswo"
        case "STRPT":
            ActVars.spcStormReportsDay = "today"
            token = "spcstormreports"
        case "SND":
            token = "sounding"
        case "SPCMESO_500":
            token = "spcmeso"
        case "SPCMESO_MSLP":
            token = "spcmeso"
        case "SPCMESO_TTD":
            token = "spcmeso"
        case "GOES16":
            ActVars.goesSector = ""
            ActVars.goesProduct = ""
            token = "goes16"
        default:
            token = "wpcimg"
        }
        self.goToVC(token)
    }

    func addLocationSelectionCard() {
        //
        // location card loaded regardless of settings
        //
        let stackViewLocationButton = ObjectStackViewHS()
        stackViewLocationButton.setup()
        self.stackView.addArrangedSubview(stackViewLocationButton)
        self.objLabel = ObjectTextView(
            stackViewLocationButton,
            Location.name,
            UIFont.systemFont(ofSize: 20),
            UIColor.blue
        )
        self.objLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.locationAction)))
    }

    func clearViews() {
        self.stackViewHazards.view.subviews.forEach {$0.removeFromSuperview()}
        self.extraDataCards.forEach {$0.removeFromSuperview()}
        self.forecastImage = []
        self.forecastText = []
        self.extraDataCards = []
        self.stackViewHazards.view.isHidden = true
    }
}
