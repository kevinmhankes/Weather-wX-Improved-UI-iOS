// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSpotterReports: UIwXViewController {

    private var spotterReportsData = [SpotterReports]()
    private var spotterReportsDataSorted = [SpotterReports]()
    private var spotterReportCountButton = ToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        spotterReportCountButton = ToolbarIcon(self, nil)
        spotterReportCountButton.title = ""
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, spotterReportCountButton]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func getContent() {
        spotterReportsData.removeAll()
        _ = FutureVoid({ self.spotterReportsData = UtilitySpotter.reportsList }, display)
    }

    func display() {
        refreshViews()
        spotterReportCountButton.title = "Count: " + String(spotterReportsData.count)
        spotterReportsDataSorted = spotterReportsData.sorted { $1.time > $0.time }
        spotterReportsDataSorted.enumerated().forEach { index, item in
            _ = ObjectSpotterReportCard(self, item, GestureData(index, self, #selector(buttonPressed)))
        }
        if spotterReportsData.count == 0 {
            let objectTextView = Text(stackView, "No active spotter reports.")
            objectTextView.constrain(scrollView)
        }
    }

    @objc func buttonPressed(sender: GestureData) {
        let index = sender.data
        let objectPopUp = ObjectPopUp(self, "", spotterReportCountButton)
        let uiAlertAction = UIAlertAction(title: "Show on map", style: .default) { _ -> Void in self.showMap(index) }
        objectPopUp.addAction(uiAlertAction)
        objectPopUp.finish()
    }

    func showMap(_ selection: Int) {
        Route.map(self, spotterReportsDataSorted[selection].location.latString, spotterReportsDataSorted[selection].location.lonString)
    }
}
