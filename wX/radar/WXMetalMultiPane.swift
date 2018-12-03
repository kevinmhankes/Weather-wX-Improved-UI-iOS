/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import Metal
import CoreLocation
import MapKit

class WXMetalMultipane: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var wxMetal = [WXMetalRender?]()
    var device: MTLDevice!
    var metalLayer = [CAMetalLayer?]()
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var timer: CADisplayLink!
    var projectionMatrix: Matrix4!
    var locationManager = CLLocationManager()
    var lastFrameTimestamp: CFTimeInterval = 0.0
    var mapIndex = 0
    var mapView = MKMapView()
    var mapShown = false
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let toolbar = ObjectToolbar()
    var doneButton = ObjectToolbarIcon()
    var timeButton = ObjectToolbarIcon()
    var radarSiteButton = ObjectToolbarIcon()
    var productButton = [ObjectToolbarIcon]()
    var animateButton = ObjectToolbarIcon()
    var inOglAnim = false
    var longPressCount = 0
    var width = 0.0
    var height = 0.0
    var numberOfPanes = 1
    var oneMinRadarFetch = Timer()
    let ortInt: Float = 250.0
    var textObj = WXMetalTextObject()
    var colorLegend = UIColorLegend()
    var screenScale = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        numberOfPanes = Int(ActVars.WXOGLPaneCnt) ?? 1
        let pangeRange = 0..<numberOfPanes

        UtilityFileManagement.deleteAllFiles()
        mapView.delegate = self
        UtilityMap.setupMap(mapView, GlobalArrays.radars + GlobalArrays.tdwrRadarsForMap, "RID_")
        toolbar.setConfig()
        if UIPreferences.radarToolbarTransparent {
            toolbar.setBackgroundImage(UIImage(),
                                       forToolbarPosition: .any,
                                       barMetrics: .default)
            toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        }

        if RadarPreferences.locdotFollowsGps {
            NotificationCenter.default.addObserver(self, selector: #selector(WXMetalMultipane.invalidateGPS), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        doneButton = ObjectToolbarIcon(self, .done, #selector(doneClicked))
        //productButton = ObjectToolbarIcon(title: "", self, #selector(productClicked(sender:)))
        pangeRange.forEach {productButton.append(ObjectToolbarIcon(title: "", self, #selector(productClicked(sender:)), tag: $0))}
        radarSiteButton = ObjectToolbarIcon(title: "", self, #selector(radarSiteClicked(sender:)))
        animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        
        var toolbarButtons = [UIBarButtonItem]()
        toolbarButtons.append(doneButton)
        if numberOfPanes == 1 {
            toolbarButtons.append(timeButton)
        }
        toolbarButtons.append(flexBarButton)
        toolbarButtons.append(animateButton)
        pangeRange.forEach {
            toolbarButtons.append(fixedSpace)
            toolbarButtons.append(productButton[$0])
        }
        if RadarPreferences.dualpaneshareposn || numberOfPanes==1 {toolbarButtons.append(radarSiteButton)}
        toolbar.items = ObjectToolbarItems(toolbarButtons).items
        
        //toolbar.items = ObjectToolbarItems([doneButton, timeButton, flexBarButton, animateButton, productButton, radarSiteButton]).items
        device = MTLCreateSystemDefaultDevice()

        let screenSize: CGSize = UIScreen.main.bounds.size
        // FIXME for dual/quad pane these numbers will need to be adjusted
        // for example, screenHeight needs to be divided by 2 for dual pane
        let screenWidth = Float(screenSize.width)
        var screenHeight = Float(screenSize.height) + Float(UIPreferences.toolbarHeight)
        if numberOfPanes == 2 {
            screenHeight /= 2
        }
        //print(screenWidth)
        //print(screenHeight)
        let surfaceRatio = Float(screenWidth)/Float(screenHeight)
        projectionMatrix = Matrix4.makeOrthoViewAngle(-1.0 * ortInt, right: ortInt,
                                                      bottom: -1.0 * ortInt * (1.0 / surfaceRatio),
                                                      top: ortInt * (1 / surfaceRatio), nearZ: -100.0, farZ: 100.0)
        //let projectionMatrix = GLKMatrix4MakeOrtho(-1.0 * ortInt, ortInt,
        //                                           -1.0 * ortInt * (1.0 / surfaceRatio),
        //                                           ortInt * (1 / surfaceRatio), 1.0, -1.0)
        //projectionMatrix = Matrix4.makeOrthoViewAngle(screenWidth/2.0 * -1.0, right: screenWidth/2.0, bottom: screenHeight/2 * -1.0, top: screenHeight/2, nearZ: -100.0, farZ: 100.0)

        let halfWidth = self.view.frame.width / 2
        var halfHeight = self.view.frame.height / 2
        halfHeight -= UIPreferences.toolbarHeight / 2.0

        pangeRange.enumerated().forEach { index, pane in
            metalLayer.append(CAMetalLayer())
            metalLayer[index]!.device = device
            metalLayer[index]!.pixelFormat = .bgra8Unorm
            metalLayer[index]!.framebufferOnly = true
            //metalLayer[index]!.frame = view.layer.frame
        }
        
        if numberOfPanes == 1 {
            metalLayer[0]!.frame = view.layer.frame
        } else if numberOfPanes == 2 {
            // top half for dual
            metalLayer[0]!.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: halfHeight)
            // bottom half for dual
            metalLayer[1]!.frame = CGRect(x: 0, y: halfHeight, width: self.view.frame.width, height: halfHeight)
        }
        
        // top left
        //metalLayer.frame =  CGRect(x: 0, y: 0, width: self.view.bounds.width/2, height: self.view.bounds.height/2)
        
        // top half for dual
        //metalLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: halfHeight)
        // bottom half for dual
        //metalLayer.frame = CGRect(x: 0, y: halfHeight, width: self.view.frame.width, height: halfHeight)
        
        metalLayer.forEach { view.layer.addSublayer($0!) }

        /*if numberOfPanes==2 {
            halfHeight -= UIPreferences.toolbarHeight / 2.0
            glviewArr.append(GLKView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: halfHeight), context: self.context!))
            glviewArr.append(GLKView(frame: CGRect(x: 0, y: halfHeight, width: self.view.frame.width, height: halfHeight), context: self.context!))
        } else if numberOfPanes==4 {
            halfHeight -= UIPreferences.toolbarHeight / 2.0
            glviewArr.append(GLKView(frame: CGRect(x: 0, y: 0, width: halfWidth, height: halfHeight), context: self.context!))
            glviewArr.append(GLKView(frame: CGRect(x: halfWidth, y: 0, width: halfWidth, height: halfHeight), context: self.context!))
            glviewArr.append(GLKView(frame: CGRect(x: 0, y: halfHeight, width: halfWidth, height: halfHeight), context: self.context!))
            glviewArr.append(GLKView(frame: CGRect(x: halfWidth, y: halfHeight, width: halfWidth, height: halfHeight), context: self.context!))
        } else {
            glviewArr.append(GLKView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), context: self.context!))
        }*/

        pangeRange.forEach { wxMetal.append(WXMetalRender(device, timeButton, productButton[$0])) }
        // FIXME
        radarSiteButton.title = wxMetal[0]!.rid

        let defaultLibrary = device.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        commandQueue = device.makeCommandQueue()
        timer = CADisplayLink(target: self, selector: #selector(WXMetalMultipane.newFrame(displayLink:)))
        timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        setupGestures()
        if RadarPreferences.locdotFollowsGps {
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                locationManager.distanceFilter = 10
            }
        }
        self.view.addSubview(toolbar)
        screenScale = Double(UIScreen.main.scale)
        // FIXME
        textObj = WXMetalTextObject(self, numberOfPanes,
                                 Double(view.frame.width),
                                 Double(view.frame.height),
                                 wxMetal[0]!,
                                 screenScale)
        textObj.initTV()
        textObj.addTV()
        self.wxMetal.forEach { $0!.getRadar("") }
        getPolygonWarnings()
        updateColorLegend()
        if RadarPreferences.wxoglRadarAutorefresh {
            oneMinRadarFetch = Timer.scheduledTimer(timeInterval: 60.0,
                                                    target: self,
                                                    selector: #selector(WXMetalMultipane.getRadarEveryMinute),
                                                    userInfo: nil,
                                                    repeats: true)
        }
    }

    // FIXME
    func modelMatrix() -> Matrix4 {
        let matrix = Matrix4()
        matrix.translate(wxMetal[0]!.xPos, y: wxMetal[0]!.yPos, z: wxMetal[0]!.zPos)
        matrix.rotateAroundX(0, y: 0, z: 0)
        matrix.scale(wxMetal[0]!.zoom, y: wxMetal[0]!.zoom, z: wxMetal[0]!.zoom)
        return matrix
    }

    func render() {
        
        wxMetal.enumerated().forEach { index, wxmetal in
            guard let drawable = metalLayer[index]!.nextDrawable() else { return }
            wxmetal!.render(commandQueue: commandQueue,
                       pipelineState: pipelineState,
                       drawable: drawable,
                       parentModelViewMatrix: modelMatrix(),
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

    func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(WXMetalMultipane.gesturePan))
        let gestureZoom = UIPinchGestureRecognizer(target: self, action: #selector(WXMetalMultipane.gestureZoom))
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(WXMetalMultipane.tapGesture(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        let gestureRecognizer2 = UITapGestureRecognizer(target: self,
                                                        action: #selector(WXMetalMultipane.tapGesture(_:double:)))
        gestureRecognizer2.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(pan)
        self.view.addGestureRecognizer(gestureZoom)
        self.view.addGestureRecognizer(gestureRecognizer)
        self.view.addGestureRecognizer(gestureRecognizer2)
        gestureRecognizer.require(toFail: gestureRecognizer2)
        gestureRecognizer.delaysTouchesBegan = true
        gestureRecognizer2.delaysTouchesBegan = true
        self.view.addGestureRecognizer(UILongPressGestureRecognizer(target: self,
                                                                    action: #selector(WXMetalMultipane.gestureLongPress(_:))))
    }

    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        WXMetalSurfaceView.singleTap(self, wxMetal, textObj, gestureRecognizer)
    }

    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer, double: Int) {
        WXMetalSurfaceView.doubleTap(self, wxMetal, textObj, gestureRecognizer)
    }

    @objc func gestureZoom(_ gestureRecognizer: UIPinchGestureRecognizer) {
        WXMetalSurfaceView.gestureZoom(self, wxMetal, textObj, gestureRecognizer)
    }

    @objc func gesturePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        WXMetalSurfaceView.gesturePan(self, wxMetal, textObj, gestureRecognizer)
    }

    @objc func gestureLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        longPressCount = WXMetalSurfaceView.gestureLongPress(self, wxMetal, textObj, longPressCount, longPressAction, gestureRecognizer)
    }

    // FIXME
    @objc func doneClicked() {
        if RadarPreferences.wxoglRadarAutorefresh {
            oneMinRadarFetch.invalidate()
            oneMinRadarFetch = Timer()
        }
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        stopAnimate()
        wxMetal[0]!.writePrefs(numberOfPanes)
        wxMetal[0]!.cleanup()
        device = nil
        wxMetal[0] = nil
        commandQueue = nil
        metalLayer[0] = nil
        pipelineState = nil
        timer = nil
        textObj = WXMetalTextObject()
        self.dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
    }

    @objc func productClicked(sender: ObjectToolbarIcon) {
        let alert = ObjectPopUp(self, "Select radar product:", productButton[0])
        // FIXME tdwr check
        WXGLNexrad.radarProductList.forEach {product in
            alert.addAction(UIAlertAction(title: product, style: .default, handler: {_ in
                self.productChanged(sender.tag, product.split(":")[0])}))
        }
        alert.finish()
    }

    func productChanged(_ index: Int, _ product: String) {
        stopAnimate()
        self.wxMetal[index]!.product = product
        self.wxMetal[index]!.getRadar("")
        productButton[index].title = product
        //self.wxMetal.forEach { $0!.radarProduct = product }
        //self.wxMetal.forEach { $0!.getRadar("") }
        updateColorLegend()
        getPolygonWarnings()
    }

    @objc func willEnterForeground() {
        if RadarPreferences.locdotFollowsGps {
            resumeGPS()
        }
        stopAnimate()
        if wxMetal[0] != nil {
            self.wxMetal.forEach { $0!.getRadar("") }
            getPolygonWarnings()
        }
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

    @objc func radarSiteClicked(sender: ObjectToolbarIcon) {
        mapIndex = sender.tag
        if mapShown {
            mapView.removeFromSuperview()
            mapShown = false
        } else {
            mapShown = true
            self.view.addSubview(mapView)
        }
    }

    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return UtilityMap.mapView(mapView, annotation)
    }

    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        mapShown = UtilityMap.mapViewExtra(mapView, annotationView, control, mapCall)
    }

    func mapCall(annotationView: MKAnnotationView) {self.ridChanged((annotationView.annotation!.title!)!, mapIndex)}

    // FIXME
    func ridChanged(_ rid: String, _ index: Int) {
        stopAnimate()
        UtilityFileManagement.deleteAllFiles()
        radarSiteButton.title = rid
        getPolygonWarnings()
        wxMetal.forEach {
            $0!.rid = rid
            $0!.loadGeometry()
            $0!.xPos = 0.0
            $0!.yPos = 0.0
            $0!.zoom = 1.0
            $0!.getRadar("")
        }
        self.view.subviews.forEach {if $0 is UITextView {$0.removeFromSuperview()}}
        textObj = WXMetalTextObject(self, numberOfPanes,
                                    Double(view.frame.width),
                                    Double(view.frame.height),
                                    wxMetal[0]!, screenScale)
        textObj.initTV()
        textObj.addTV()
    }

    @objc func animateClicked() {
        if !inOglAnim {
            let alert = ObjectPopUp(self, "Select number of animation frames:", animateButton)
            ["5", "10", "20", "30", "40", "50", "60"].forEach { cnt in
                alert.addAction(UIAlertAction(title: cnt, style: .default, handler: {_ in self.animateFrameCntClicked(cnt)}))
            }
            alert.finish()
        } else {
            stopAnimate()
        }
    }

    func stopAnimate() {
        inOglAnim = false
        animateButton.setImage(UIImage(named: "ic_play_arrow_24dp")!, for: .normal)
    }

    func animateFrameCntClicked(_ frameCnt: String) {
        if !inOglAnim {
            inOglAnim = true
            animateButton.setImage(UIImage(named: "ic_stop_24dp")!, for: .normal)
            getAnimate(frameCnt)
        } else {
            stopAnimate()
        }
    }

    func getAnimate(_ frameCntStr: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            var animArray = [[String]]()
            animArray.append(self.wxMetal[0]!.rdDownload.getRadarByFTPAnimation(frameCntStr))
            animArray[0].indices.forEach {
                UtilityFileManagement.deleteFile(String(0) + "nexrad_anim" + String($0))
                UtilityFileManagement.moveFile(animArray[0][$0], String(0)  + "nexrad_anim" + String($0))
            }
            let frameCnt = Int(frameCntStr) ?? 0
            var scaleFactor = 1
            while self.inOglAnim {
                for frame in (0..<frameCnt) {
                    if self.inOglAnim {
                        let buttonText = " (\(String(frame+1))/\(frameCnt))"
                        self.wxMetal[0]!.getRadar(String(0) + "nexrad_anim" + String(frame), buttonText)
                        scaleFactor = 1
                        usleep(UInt32(100000 * MyApplication.animInterval * scaleFactor))
                    } else {
                        break
                    }
                }
            }
            DispatchQueue.main.async {
            }
        }
    }

    func longPressAction(_ x: CGFloat, _ y: CGFloat, _ index: Int) {
        width = Double(self.view.bounds.size.width)
        height = Double(self.view.bounds.size.height)
        var yModified = Double(y)
        var xModified = Double(x)
        // see if y is in the bottom pane, if adjust
        if numberOfPanes != 1 {
            if y > self.view.frame.height / 2.0 {
                yModified -= Double(self.view.frame.height) / 2.0
                //glvIdx = 1
            }
        }
        if numberOfPanes==4 {if x > self.view.frame.width / 2.0 {xModified -= Double(self.view.frame.width) / 2.0}}
        //var density = Double(oglrArr[0].ortInt * 2) / width
        let density = 400/width
        //if numberOfPanes==4 {density = 2.0 * Double(oglrArr[0].ortInt * 2.0) / width}
        var yMiddle = 0.0
        var xMiddle = 0.0
        if numberOfPanes==1 {
            yMiddle = height / 2.0
        } else {
            yMiddle = height / 4.0
        }
        if numberOfPanes==4 {
            xMiddle = width / 4.0
        } else {
            xMiddle = width / 2.0
        }
        let glv = wxMetal[0]!
        // FIXME
        let diffX = density * (xMiddle - xModified) / Double(wxMetal[0]!.zoom)
        let diffY = density * (yMiddle - yModified) / Double(wxMetal[0]!.zoom)
        let radarLocation = LatLon(preferences.getString("RID_" + wxMetal[0]!.rid + "_X", "0.00"),
                                   preferences.getString("RID_" + wxMetal[0]!.rid + "_Y", "0.00"))
        let ppd = wxMetal[0]!.pn.oneDegreeScaleFactor
        let newX = radarLocation.lon + (Double(wxMetal[0]!.xPos) / Double(wxMetal[0]!.zoom) + diffX) / ppd
        let test2 = 180.0 / Double.pi * log(tan(Double.pi / 4 + radarLocation.lat * (Double.pi / 180) / 2.0))
        var newY = test2 + (Double(-wxMetal[0]!.yPos) / Double(wxMetal[0]!.zoom) + diffY) / ppd
        newY = (180.0 / Double.pi * (2 * atan(exp(newY * Double.pi / 180.0)) - Double.pi / 2.0))
        print(newX)
        print(newY)
        let ridNearbyList = UtilityLocation.getNearestRadarSites(LatLon.reversed(newX, newY), 5)
        let pointerLocation = LatLon.reversed(newX, newY)
        let dist = LatLon.distance(Location.latlon, pointerLocation, .M)
        let radarSiteLocation = UtilityLocation.getSiteLocation(site: glv.rid)
        let distRid = LatLon.distance(radarSiteLocation, LatLon.reversed(newX, newY), .M)
        var alertMessage = preferences.getString("WX_RADAR_CURRENT_INFO", "") + MyApplication.newline + String(dist.roundTo(places: 2)) + " miles from location" + ", " + String(distRid.roundTo(places: 2)) + " miles from " + wxMetal[0]!.rid
        if wxMetal[0]!.gpsLocation.latString != "0.0" && wxMetal[0]!.gpsLocation.lonString != "0.0" {
            alertMessage += MyApplication.newline + "GPS: "
                + wxMetal[0]!.gpsLocation.latString.truncate(10)
                + ", -"
                + wxMetal[0]!.gpsLocation.lonString.truncate(10)
        }
        let alert = UIAlertController(title: "Select closest radar site:",
                                      message: alertMessage, preferredStyle: UIAlertControllerStyle.actionSheet)
        ridNearbyList.forEach {
            let name = $0.name
            let b = UIAlertAction(title: name + ": " +  preferences.getString("RID_LOC_" + name, "") + " (" + String($0.distance) + " mi)", style: .default, handler: { _ in self.ridChanged(name, index)})
            alert.addAction(b)
        }
        alert.addAction(UIAlertAction(title: "Show warning text", style: .default, handler: {_ in
            self.showPolygonText(pointerLocation)}))
        alert.addAction(UIAlertAction(title: "Show nearest observation", style: .default, handler: {_ in
            self.getMetar(pointerLocation)}))
        alert.addAction(UIAlertAction(title: "Show nearest forecast", style: .default, handler: {_ in
            self.getForecast(pointerLocation)}))
        alert.addAction(UIAlertAction(title: "Show nearest meteogram", style: .default, handler: {_ in
            self.getMeteogram(pointerLocation)}))
        alert.addAction(UIAlertAction(title: "Show radar status message", style: .default, handler: {_ in
            self.getRadarStatus()}))
        let dismiss = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(dismiss)
        if let popoverController = alert.popoverPresentationController {popoverController.barButtonItem = radarSiteButton}
        self.present(alert, animated: true, completion: nil)
    }

    func showPolygonText(_ location: LatLon) {
        let warningText = UtilityWXOGL.showTextProducts(location)
        if warningText != "" {
            ActVars.usalertsDetailUrl = warningText
            self.goToVC("usalertsdetail")
        }
    }

    func getMetar(_ location: LatLon) {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityMetar.findClosestMetar(location)
            DispatchQueue.main.async {
                ActVars.TEXTVIEWText = html
                self.goToVC("textviewer")
            }
        }
    }

    func getForecast(_ location: LatLon) {
        ActVars.ADHOCLOCATION = location
        self.goToVC("adhoclocation")
    }

    func getMeteogram(_ location: LatLon) {
        let obsSite = UtilityMetar.findClosestObservation(location)
        ActVars.IMAGEVIEWERurl = "http://www.nws.noaa.gov/mdl/gfslamp/meteo.php?BackHour=0&TempBox=Y&DewBox=Y&SkyBox=Y&WindSpdBox=Y&WindDirBox=Y&WindGustBox=Y&CigBox=Y&VisBox=Y&ObvBox=Y&PtypeBox=N&PopoBox=Y&LightningBox=Y&ConvBox=Y&sta=" + obsSite.name
        self.goToVC("imageviewer")
    }

    func getRadarStatus() {
        DispatchQueue.global(qos: .userInitiated).async {
            let radarStatus = UtilityDownload.getRadarStatusMessage(self.wxMetal[0]!.rid)
            DispatchQueue.main.async {
                ActVars.TEXTVIEWText = radarStatus
                self.goToVC("textviewer")
            }
        }
    }

    @objc func invalidateGPS() {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }

    func resumeGPS() {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locValue = manager.location?.coordinate { // type CLLocationCoordinate2D
            if wxMetal[0] != nil {
                wxMetal[0]!.gpsLocation = LatLon(Double(locValue.latitude), Double(locValue.longitude) * -1.0)
                wxMetal[0]!.constructLocationDot()
            }
        }
    }

    @objc func getRadarEveryMinute() {
        wxMetal.forEach { $0!.getRadar("") }
        getPolygonWarnings()
    }

    func updateColorLegend() {
        if RadarPreferences.radarShowLegend && numberOfPanes==1 {
            colorLegend.removeFromSuperview()
            colorLegend = UIColorLegend(wxMetal[0]!.product, CGRect(x: 0, y: UIPreferences.statusBarHeight, width: 100, height: self.view.frame.size.height - UIPreferences.toolbarHeight - UIPreferences.statusBarHeight))
            colorLegend.backgroundColor = UIColor.clear
            colorLegend.isOpaque = false
            self.view.addSubview(colorLegend)
        }
    }

    public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }

    public enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }
}

// N0U anim not working ( seems worse on slower devices )
// minor mem leak
// multipane
// spotter labels
// cities
// after enabling GPS need to go in , out and back into radar
