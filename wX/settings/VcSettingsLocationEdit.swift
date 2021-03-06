// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import AVFoundation
import CoreLocation
import MapKit
import UserNotifications

final class VcSettingsLocationEdit: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private var labelTextView = Text()
    private var latTextView = Text()
    private var lonTextView = Text()
    private var statusTextView = Text()
    private var status = ""
    private var numLocsLocalStr = ""
    private let locationManager = CLLocationManager()
    private let mapView = MKMapView()
    private var toolbar = ObjectToolbar()
    private var toolbarBottom = ObjectToolbar()
    private let helpStatement = "There are four ways to enter and save a location. The easiest method is to tap the GPS icon (which looks like an arrow pointing up and to the right). You will need to give permission for the program to access your GPS location if you have not done so before. It might take 5-10 seconds but eventually latitude and longitude numbers will appear and the location will be automatically saved. The second way is to press and hold (also known as long press) on the map until a red pin appears. Once the red pin appears the latitude and longitude will use reverse geocoding to determine an appropriate label for the location. The third method is to tap the search icon and then enter a location such as a city. Once resolved it will save automatically. The final method is the most manual and that is manually specifying a label, latitude, and longitude. After you have done this you need to tape the checkmark icon to save it. Please note that only land based locations in the USA are supported."
    var settingsLocationEditNum = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        mapView.addGestureRecognizer(longTapGesture)
        Utility.writePref("LOCATION_CANADA_PROV", "")
        Utility.writePref("LOCATION_CANADA_CITY", "")
        Utility.writePref("LOCATION_CANADA_ID", "")
        locationManager.delegate = self
        toolbar = ObjectToolbar()
        toolbarBottom = ObjectToolbar()
        let helpButton = ToolbarIcon("Help", self, #selector(helpClicked))
        let canadaButton = ToolbarIcon("Canada", self, #selector(caClicked))
        let doneButton = ToolbarIcon(self, .done, #selector(doneClicked))
        let doneButton2 = ToolbarIcon(self, .done, #selector(doneClicked))
        let saveButton = ToolbarIcon(self, .save, #selector(saveClicked))
        let searchButton = ToolbarIcon(self, .search, #selector(searchClicked))
        let deleteButton = ToolbarIcon(self, .delete, #selector(deleteClicked))
        let gpsButton = ToolbarIcon(self, .gps, #selector(gpsClicked))
        let items = [doneButton, GlobalVariables.flexBarButton, searchButton, gpsButton, saveButton]
        var itemsBottom = [doneButton2, GlobalVariables.flexBarButton, helpButton, canadaButton]
        if Location.numLocations > 1 {
            itemsBottom.append(deleteButton)
        }
        toolbar.items = ToolbarItems(items).items
        toolbarBottom.items = ToolbarItems(itemsBottom).items
        view.addSubview(toolbar)
        view.addSubview(toolbarBottom)
        toolbar.setConfigWithUiv(uiv: self, toolbarType: .top)
        toolbarBottom.setConfigWithUiv(uiv: self)
        labelTextView = Text("Label")
        latTextView = Text("Lat")
        lonTextView = Text("Lon")
        statusTextView = Text("")
        let textViews = [labelTextView.view, latTextView.view, lonTextView.view, statusTextView.view]
        textViews.forEach { label in
            label.font = FontSize.extraLarge.size
            label.isEditable = true
        }
        textViews[3].font = FontSize.extraSmall.size
        textViews[3].isEditable = false
        let stackView = ObjectStackView(.fill, .vertical, spacing: 0, arrangedSubviews: textViews + [mapView])
        stackView.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView.view)
        let topSpace = UIPreferences.toolbarHeight + UtilityUI.getTopPadding()
        let bottomSpace = UIPreferences.toolbarHeight + UtilityUI.getBottomPadding()
        stackView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.view.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpace).isActive = true
        stackView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomSpace).isActive = true
        if settingsLocationEditNum == "0" {
            numLocsLocalStr = String(Location.numLocations + 1)
        } else {
            numLocsLocalStr = settingsLocationEditNum
            let locIdx = Int(numLocsLocalStr)! - 1
            labelTextView.text = Location.getName(locIdx)
            latTextView.text = Location.getX(locIdx)
            lonTextView.text = Location.getY(locIdx)
            var latString = Location.getX(locIdx)
            var lonString = Location.getY(locIdx)
            if !Location.isUS(locIdx) {
                latString = Location.getX(locIdx).split(":")[2]
                lonString = "-" + Location.getY(locIdx).split(":")[1]
            }
            let locationC = CLLocationCoordinate2D(
                latitude: to.Double(latString),
                longitude: to.Double(lonString)
            )
            ObjectMap.centerMapOnLocationEdit(mapView, location: locationC, regionRadius: 50000.0)
        }
    }

    @objc func doneClicked() {
        Location.refreshLocationData()
        dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
    }

    @objc func helpClicked() {
        Route.textViewer(self, helpStatement)
    }

    @objc func saveClicked() {
        status = Location.save(
            numLocsLocalStr,
            LatLon(latTextView.view.text!, lonTextView.view.text!),
            labelTextView.view.text!
        )
        statusTextView.text = status
        view.endEditing(true)
        var latString = latTextView.view.text!
        var lonString = lonTextView.view.text!
        if latTextView.text.contains("CANADA:") && lonTextView.text != "" {
            // The location save process looks up the true Lat/Lon which is then ingested by the map
            let locationNumber = to.Int(numLocsLocalStr) - 1
            latTextView.text = Location.getX(locationNumber)
            lonTextView.text = Location.getY(locationNumber)
            if latTextView.view.text!.split(":").count > 2 {
                latString = latTextView.view.text!.split(":")[2]
            }
            if lonTextView.text.contains(":") {
                lonString = "-" + lonTextView.view.text!.split(":")[1]
            }
        }
        centerMap(latString, lonString)
    }

    func centerMap(_ lat: String, _ lon: String) {
        let locationC = CLLocationCoordinate2D(latitude: to.Double(lat), longitude: to.Double(lon))
        ObjectMap.centerMapOnLocationEdit(mapView, location: locationC, regionRadius: 50000.0)
    }

    @objc func deleteClicked() {
        Location.delete(numLocsLocalStr)
        doneClicked()
    }

    @objc func searchClicked() {
        let alert = UIAlertController(
            title: "Search for location",
            message: "Enter a city/state combination or a zip code. After the search completes, "
                + "valid latitude and longitude values should appear. Hit save after they appear.",
            preferredStyle: .alert
        )
        alert.addTextField { textField in textField.text = "" }
        alert.addAction(
            UIAlertAction(title: "OK", style: .default) { _ in
                let textField = alert.textFields![0]
                self.searchAddress(textField.text!)
            }
        )
        present(alert, animated: UIPreferences.backButtonAnimation, completion: nil)
    }

    func searchAddress(_ address: String) {
        CLGeocoder().geocodeAddressString(
            address,
            completionHandler: { placeMarks, error in
                if error != nil {
                    return
                }
                if (placeMarks?.count)! > 0 {
                    let placemark = placeMarks?[0]
                    let location = placemark?.location
                    let coordinate = location?.coordinate
                    let locationName: String
                    if placemark?.locality != nil && placemark?.administrativeArea != nil {
                        locationName = (placemark?.administrativeArea! ?? "") + ", " + (placemark?.locality! ?? "")
                    } else {
                        locationName = "Location"
                    }
                    self.labelTextView.text = locationName
                    self.latTextView.text = String(coordinate!.latitude)
                    self.lonTextView.text = String(coordinate!.longitude)
                    if self.latTextView.text != "" && self.lonTextView.text != "" {
                        self.saveClicked()
                    }
                }
            }
        )
    }

    @objc func gpsClicked() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        latTextView.text = String(locValue.latitude)
        lonTextView.text = String(locValue.longitude)
        if latTextView.text != "" && lonTextView.text != "" {
            getAddressAndSaveLocation(latTextView.text, lonTextView.text)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }

    @objc func caClicked() {
        Route.settingsLocationCanada(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let caProv = Utility.readPref("LOCATION_CANADA_PROV", "")
        let caCity = Utility.readPref("LOCATION_CANADA_CITY", "")
        let caId = Utility.readPref("LOCATION_CANADA_ID", "")
        if caProv != "" || caCity != "" || caId != "" {
            latTextView.text = "CANADA:" + caProv
            lonTextView.text = caId
            labelTextView.text = caCity + ", " + caProv
        }
        if latTextView.text.contains("CANADA:") && lonTextView.text != "" {
            saveClicked()
        }
    }

    @objc func longPress(sender: UIGestureRecognizer) {
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
            getAddressAndSaveLocation(String(locationOnMap.latitude), String(locationOnMap.longitude))
        }
    }

    func addAnnotation(location: CLLocationCoordinate2D) {
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
        let latLonTruncateLength = 9
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = String(location.latitude).truncate(latLonTruncateLength)
            + ","
            + String(location.longitude).truncate(latLonTruncateLength)
        annotation.subtitle = ""
        mapView.addAnnotation(annotation)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .contactAdd) // was infoDark
            pinView!.pinTintColor = UIColor.red
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped on pin ")
    }

    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        if control == view.rightCalloutAccessoryView {
            if let locationString = view.annotation?.title! {
                let locationList = locationString.split(",")
                getAddressAndSaveLocation(locationList[0], locationList[1])
            }
        }
    }

    func saveFromMap(_ locationName: String, _ lat: String, _ lon: String) {
        labelTextView.text = locationName
        status = Location.save(numLocsLocalStr, LatLon(lat, lon), labelTextView.view.text!)
        latTextView.text = lat
        lonTextView.text = lon
        statusTextView.text = status
        view.endEditing(true)
        centerMap(lat, lon)
    }

    func getAddressAndSaveLocation(_ latStr: String, _ lonStr: String) {
        var center = CLLocationCoordinate2D()
        let lat = to.Double(latStr)
        let lon = to.Double(lonStr)
        let ceo = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc = CLLocation(latitude: center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc) { placeMarks, error in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placeMarks! as [CLPlacemark]
            if pm.count > 0 {
                let pm = placeMarks![0]
                let locationName: String
                if pm.locality != nil && pm.administrativeArea != nil {
                    locationName = pm.administrativeArea! + ", " + pm.locality!
                } else {
                    locationName = "Location"
                }
                self.saveFromMap(locationName, latStr, lonStr)
            }
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle && UIApplication.shared.applicationState == .inactive {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    AppColors.update()
                    // print("Dark mode")
                } else {
                    AppColors.update()
                    // print("Light mode")
                }
                view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
                toolbar.setColorToTheme()
                toolbarBottom.setColorToTheme()
            }
        } else {
            // Fallback on earlier versions
        }
    }

    override var keyCommands: [UIKeyCommand]? {
        [UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(doneClicked))]
    }
}
