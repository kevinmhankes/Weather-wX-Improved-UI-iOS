/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityActions {
    
    static func cloudClicked(_ uiv: UIViewController) {
        if Location.isUS {
            let vc = vcGoes()
            vc.productCode = ""
            vc.sectorCode = ""
            uiv.goToVC(vc)
        } else {
            let vc = vcCanadaRadar()
            vc.caRadarImageType = "vis"
            uiv.goToVC(vc)
        }
    }
    
    static func radarClicked(_ uiv: UIViewController) {
        if !Location.isUS {
            let vc = vcCanadaRadar()
            vc.caRadarImageType = "radar"
            vc.caRadarProvince = ""
            uiv.goToVC(vc)
        } else {
            let vc = vcNexradRadar()
            if UIPreferences.dualpaneRadarIcon {
                vc.wxoglPaneCount = "2"
            } else {
                vc.wxoglPaneCount = "1"
            }
            uiv.goToVC(vc)
        }
    }
    
    static func wfotextClicked(_ uiv: UIViewController) {
        if Location.isUS {
            let vc = vcWfoText()
            uiv.goToVC(vc)
        } else {
            let vc = vcCanadaText()
            uiv.goToVC(vc)
        }
    }
    
    static func dashClicked(_ uiv: UIViewController) {
        if Location.isUS {
            let vc = vcSevereDashboard()
            uiv.goToVC(vc)
        } else {
            let vc = vcCanadaWarnings()
            uiv.goToVC(vc)
        }
    }
    
    static func multiPaneRadarClicked(_ uiv: UIViewController, _ paneCount: String) {
        let vc = vcNexradRadar()
        switch paneCount {
        case "2":
            vc.wxoglPaneCount = "2"
        case "4":
            vc.wxoglPaneCount = "4"
        default: break
        }
        uiv.goToVC(vc)
    }
    
    static func menuItemClicked(_ uiv: UIViewController, _ menuItem: String, _ button: ObjectToolbarIcon) {
        switch menuItem {
        case "Soundings":
            let vc = vcSoundings()
            uiv.goToVC(vc)
        case "Hourly Forecast":
            if Location.isUS {
                let vc = vcHourly()
                uiv.goToVC(vc)
            } else {
                let vc = vcCanadaHourly()
                uiv.goToVC(vc)
            }
        case "Settings":
            let vc = vcSettingsMain()
            uiv.goToVC(vc)
        case "Observations":
            let vc = vcObservations()
            uiv.goToVC(vc)
        case "PlayList":
            let vc = vcPlayList()
            uiv.goToVC(vc)
        case "Radar Mosaic":
            if Location.isUS {
                if !UIPreferences.useAwcRadarMosaic {
                    let vc = vcRadarMosaic()
                    vc.nwsMosaicType = "local"
                    uiv.goToVC(vc)
                } else {
                    let vc = vcRadarMosaicAwc()
                    vc.nwsMosaicType = "local"
                    uiv.goToVC(vc)
                }
            } else {
                let prov = MyApplication.locations[Location.getLocationIndex].prov
                let vc = vcCanadaRadar()
                vc.caRadarProvince = UtilityCanada.getECSectorFromProvidence(prov)
                vc.caRadarImageType = "radar"
                uiv.goToVC(vc)
            }
        case "Canadian Alerts":
            let vc = vcCanadaWarnings()
            uiv.goToVC(vc)
        case "US Alerts":
            let vc = vcUSAlerts()
            uiv.goToVC(vc)
        case "Spotters":
            let vc = vcSpotters()
            uiv.goToVC(vc)
        default:
            let vc = vcHourly()
            uiv.goToVC(vc)
        }
    }
    
    static func goToVc(_ uiv: UIViewController, _ target: UIViewController) {
        target.modalPresentationStyle = .fullScreen
        uiv.present(target, animated: UIPreferences.backButtonAnimation, completion: nil)
    }
    
    static func showHelp(_ token: String, _ uiv: UIViewController, _ menuButton: ObjectToolbarIcon) {
        let alert = UIAlertController(
            title: UtilityHelp.helpStrings[token],
            message: "",
            preferredStyle: UIAlertController.Style.actionSheet
        )
        alert.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = menuButton
        }
        uiv.present(alert, animated: true, completion: nil)
    }
    
    static func menuClicked(_ uiv: UIViewController, _ button: ObjectToolbarIcon) {
        // items in the list below need to match items in menuItemClicked's switch
        var menuList = [
            "Hourly Forecast",
            "Radar Mosaic",
            "US Alerts",
            "Observations",
            "Soundings",
            "PlayList",
            "Settings"
        ]
        if !Location.isUS {
            menuList = [
                "Hourly Forecast",
                "Radar Mosaic",
                "Canadian Alerts",
                "Observations",
                "Soundings",
                "PlayList",
                "Settings"
            ]
        }
        let alert = UIAlertController(
            title: "Select from:",
            message: "",
            preferredStyle: UIAlertController.Style.actionSheet
        )
        alert.view.tintColor = ColorCompatibility.label
        menuList.forEach { item in
            let action = UIAlertAction(title: item, style: .default, handler: {_ in menuItemClicked(uiv, item, button)})
            if let popoverController = alert.popoverPresentationController {
                popoverController.barButtonItem = button
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        uiv.present(alert, animated: true, completion: nil)
    }
    
    static func doneClicked(_ uiv: UIViewController) {
        uiv.dismiss(animated: true, completion: {})
    }
}
