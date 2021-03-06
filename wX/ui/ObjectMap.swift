// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import MapKit

final class ObjectMap {
    
    let mapView = MKMapView()
    var mapShown = false
    private let officeType: OfficeTypeEnum
    private let mapRegionRadius = 1000000.0
    
    init(_ officeType: OfficeTypeEnum) {
        self.officeType = officeType
    }
    
    func setupMap( _ itemList: [String]) {
        let locations = createLocationsList(itemList)
        var annotations = [MKPointAnnotation]()
        locations.forEach { dictionary in
            let latitude = CLLocationDegrees(Double(dictionary["latitude"]!)!)
            let longitude = CLLocationDegrees(Double(dictionary["longitude"]!)!)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let name = dictionary["name"]!
            let mediaURL = dictionary["mediaURL"]
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(name)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        let usCenter = CLLocationCoordinate2D(latitude: Location.latLon.lat, longitude: Location.latLon.lon)
        centerMapOnLocation(location: usCenter, regionRadius: mapRegionRadius)
    }
    
    private func createLocationsList(_ offices: [String]) -> [[String: String]] {
        var locations = [[String: String]]()
        offices.forEach { item in
            let items = item.split(":")
            let latLon: LatLon
            switch officeType {
            case .WFO:
                latLon = Utility.getWfoSiteLatLon(items[0])
            case .RADAR:
                latLon = Utility.getRadarSiteLatLon(items[0])
            case .SOUNDING:
                latLon = Utility.getSoundingSiteLatLon(items[0])
            }
            if items.count > 1 {
                let officeDict = [
                    "name": items[0],
                    "latitude": latLon.latString,
                    "longitude": latLon.lonString,
                    "mediaURL": items[1]
                ]
                locations.append(officeDict)
            } else {
                let officeDict = [
                    "name": items[0],
                    "latitude": latLon.latString,
                    "longitude": latLon.lonString,
                    "mediaURL": ""
                ]
                locations.append(officeDict)
            }
        }
        return locations
    }
    
    private func centerMapOnLocation(location: CLLocationCoordinate2D, regionRadius: Double) {
        let coordinateRegion = MKCoordinateRegion(
            center: location,
            latitudinalMeters: regionRadius * 2.0,
            longitudinalMeters: regionRadius * 2.0
        )
        let (width, height) = UtilityUI.getScreenBoundsCGFloat()
        mapView.frame = CGRect(
            x: 0,
            y: UtilityUI.getTopPadding(),
            width: width,
            height: height
                - UIPreferences.toolbarHeight
                - UtilityUI.getBottomPadding()
                - UtilityUI.getTopPadding()
        )
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func toggleMap(_ uiv: UIViewController) {
        if mapShown {
            mapView.removeFromSuperview()
            mapShown = false
        } else {
            mapShown = true
            uiv.view.addSubview(mapView)
        }
    }
    
    func mapView(_ annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pin!.pinTintColor = .red
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        return pin
    }
    
    func mapViewExtra(_ annotationView: MKAnnotationView, _ control: UIControl, _ localChanges: (MKAnnotationView) -> Void) -> Bool {
        var mapShown = true
        if control == annotationView.rightCalloutAccessoryView {
            mapView.removeFromSuperview()
            mapShown = false
            localChanges(annotationView)
        }
        return mapShown
    }
    
    static func centerMapOnLocationEdit(_ mapView: MKMapView, location: CLLocationCoordinate2D, regionRadius: Double) {
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        mapView.frame = CGRect(x: 0, y: UtilityUI.getTopPadding(), width: width, height: width)
        mapView.setRegion(coordinateRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    static func centerMapForMapKit(_ mapView: MKMapView, location: CLLocationCoordinate2D, regionRadius: Double) {
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        let (width, height) = UtilityUI.getScreenBoundsCGFloat()
        mapView.frame = CGRect(
            x: 0,
            y: UtilityUI.getTopPadding(),
            width: width,
            height: height
                - UIPreferences.toolbarHeight
                - UtilityUI.getBottomPadding()
                - UtilityUI.getTopPadding()
        )
        mapView.setRegion(coordinateRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
}
