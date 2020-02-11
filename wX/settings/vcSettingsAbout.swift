/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSettingsAbout: UIwXViewController {

    let faqUrl = "https://docs.google.com/document/d/e/2PACX-1vQVkTWlnpRZCSn-ZI7tNLMDHUq-oWp9i1bf8e1yFf1ebEA2CFMapVUsALGJASj2aNhEMYAwBMs4GstL/pub"
    let releaseNotesUrl = "https://docs.google.com/document/d/e/2PACX-1vRZeQDVwKgzgzO2byDxjxcsTbj9JbwZIU_zhS-r7vUwlIDx1QjcltHThLOmG5P_FKs0Td8bYiQdRMgO/pub"
    static let copyright = "©"
    let aboutText = "\(GlobalVariables.appName) is an efficient and configurable method to access weather content from the "
        + "National Weather Service, Environment Canada, NSSL WRF, and Blitzortung.org."
        + " Software is provided \"as is\". Use at your own risk. Use for educational purposes "
        + "and non-commercial purposes only. Do not use for operational purposes.  "
        + copyright
        + "2016-2020 joshua.tee@gmail.com . Please report bugs or suggestions "
        + "via email to me as opposed to app store reviews."
        + " \(GlobalVariables.appName) is bi-licensed under the Mozilla Public License Version 2 as well "
        + "as the GNU General Public License Version 3 or later. "
        + "For more information on the licenses please go here: https://www.mozilla.org/en-US/MPL/2.0/"
        + " and http://www.gnu.org/licenses/gpl-3.0.en.html" + MyApplication.newline
        + "Keyboard shortcuts: " + MyApplication.newline + MyApplication.newline
        + "r: Nexrad radar" + MyApplication.newline
        + "d: Severe Dashboard" + MyApplication.newline
        + "c: GOES viewer" + MyApplication.newline
        + "a: Location text product viewer" + MyApplication.newline
        + "m: open menu" + MyApplication.newline
        + "2: Dual pane nexrad radar" + MyApplication.newline
        + "4: Quad pane nexrad radar" + MyApplication.newline
        + "w: US Alerts" + MyApplication.newline
    + "s: Settings" + MyApplication.newline
    + "e: SPC Mesoanalysis" + MyApplication.newline
    + "n: NCEP Models" + MyApplication.newline
    + "h: Hourly forecast" + MyApplication.newline
    + "t: NHC" + MyApplication.newline
    + "l: Lightning" + MyApplication.newline
    + "i: National images" + MyApplication.newline
    + "z: National text discussions" + MyApplication.newline

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ObjectToolbarIcon(title: "version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        displayContent()
    }

    @objc override func doneClicked() {
        MyApplication.initPreferences()
        super.doneClicked()
    }

    @objc func actionClick(sender: UITapGestureRecognizerWithData) {
        switch sender.strData {
        case "faq":
            let vc = vcWebView()
            vc.webViewShowProduct = false
            vc.webViewUseUrl = true
            vc.webViewUrl = faqUrl
            self.goToVC(vc)
        case "notes":
            let vc = vcWebView()
            vc.webViewShowProduct = false
            vc.webViewUseUrl = true
            vc.webViewUrl = releaseNotesUrl
            self.goToVC(vc)
        default:
            break
        }
    }

    private func displayContent() {
        let objectTextView1 = ObjectTextView(
            self.stackView,
            "View FAQ (Outage notifications listed at top if any are current)",
            FontSize.extraLarge.size,
            UITapGestureRecognizerWithData("faq", self, #selector(actionClick(sender:)))
        )
        objectTextView1.color = ColorCompatibility.highlightText
        objectTextView1.tv.isSelectable = false
        let objectTextView2 = ObjectTextView(
            self.stackView,
            "View release notes",
            FontSize.extraLarge.size,
            UITapGestureRecognizerWithData("notes", self, #selector(actionClick(sender:)))
        )
        objectTextView2.color = ColorCompatibility.highlightText
        objectTextView2.tv.isSelectable = false
        _ = ObjectTextView(
            self.stackView,
            aboutText + Utility.showDiagnostics(),
            FontSize.medium.size,
            UITapGestureRecognizerWithData("", self, #selector(actionClick(sender:)))
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshViews()
        self.displayContent()
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
