/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSpcStormReports: UIwXViewController {
    
    private var image = ObjectImage()
    private var objDatePicker: ObjectDatePicker!
    private var stormReports = [StormReport]()
    private var html = ""
    private var date = ""
    private var imageUrl = ""
    private var textUrl = ""
    private var bitmap = Bitmap()
    private var stateCount = [String: Int]()
    private var filterList = [String]()
    private var filter = "All"
    private var filterButton = ObjectToolbarIcon()
    var spcStormReportsDay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        let lsrButton = ObjectToolbarIcon(title: "LSR by WFO", self, #selector(lsrClicked))
        filterButton = ObjectToolbarIcon(title: "Filter: " + filter, self, #selector(filterClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                filterButton,
                lsrButton,
                shareButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self)
        self.displayPreContent()
        imageUrl = MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + spcStormReportsDay + ".gif"
        textUrl = MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + spcStormReportsDay  + ".csv"
        self.getContent()
    }
    
    // do not do anything
    override func willEnterForeground() {
        //self.getContent()
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.bitmap = Bitmap(self.imageUrl)
            self.bitmap.url = self.imageUrl
            self.html = self.textUrl.getHtml()
            self.stormReports = UtilitySpcStormReports.process(self.html.split(MyApplication.newline))
            DispatchQueue.main.async { self.displayContent() }
        }
    }
    
    @objc func imgClicked() {
        Route.imageViewer(self, self.imageUrl)
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, [self.image.bitmap], self.html)
    }
    
    @objc func gotoMap(sender: UITapGestureRecognizerWithData) {
        Route.map(self, self.stormReports[sender.data].lat, self.stormReports[sender.data].lon)
    }
    
    @objc func onDateChanged(sender: UIDatePicker) {
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM/dd/yyyy"
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let components = objDatePicker.datePicker.calendar.dateComponents(
            [.day, .month, .year],
            from: objDatePicker.datePicker.date as Date
        )
        let day = String(format: "%02d", components.day!)
        let month = String(format: "%02d", components.month!)
        let year = String(components.year!).substring(2)
        date = year + month + day
        imageUrl = MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + date + "_rpts.gif"
        textUrl = MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + date  + "_rpts.csv"
        self.stackView.removeViews()
        stackView.addArrangedSubview(objDatePicker.datePicker)
        stackView.addArrangedSubview(image.img)
        self.getContent()
    }
    
    @objc func lsrClicked() {
        let vc = vcLsrByWfo()
        self.goToVC(vc)
    }
    
    @objc func filterClicked() {
        _ = ObjectPopUp(
            self,
            title: "Filter Selection",
            filterButton,
            filterList,
            self.changeFilter(_:)
        )
    }
    
    private func changeFilter(_ index: Int) {
        filter = filterList[index].split(":")[0]
        filterButton.title = "Filter: " + filter
        self.stackView.removeViews()
        stackView.addArrangedSubview(objDatePicker.datePicker)
        stackView.addArrangedSubview(image.img)
        displayContent()
    }
    
    private func displayPreContent() {
        objDatePicker = ObjectDatePicker(stackView)
        objDatePicker.datePicker.addTarget(self, action: #selector(onDateChanged(sender:)), for: .valueChanged)
        image = ObjectImage(self.stackView)
    }
    
    private func displayContent() {
        var stateList = [String]()
        filterList = ["All"]
        var tornadoReports = 0
        var windReports = 0
        var hailReports = 0
        var tornadoHeader: ObjectCardBlackHeaderText?
        var windHeader: ObjectCardBlackHeaderText?
        var hailHeader: ObjectCardBlackHeaderText?
        self.image.setBitmap(bitmap)
        self.image.addGestureRecognizer(UITapGestureRecognizerWithData(target: self, action: #selector(imgClicked)))
        self.stormReports.enumerated().forEach { index, stormReport in
            if stormReport.damageHeader != "" {
                switch stormReport.damageHeader {
                case "Tornado Reports":
                    tornadoHeader = ObjectCardBlackHeaderText(self, stormReport.damageHeader)
                case "Wind Reports":
                    windHeader = ObjectCardBlackHeaderText(self, stormReport.damageHeader)
                case "Hail Reports":
                    hailHeader = ObjectCardBlackHeaderText(self, stormReport.damageHeader)
                default:
                    break
                }
            }
            if stormReport.damageHeader == "" && (filter == "All" || filter == stormReport.state) {
                if windHeader == nil {
                    tornadoReports += 1
                } else if hailHeader == nil {
                    windReports += 1
                } else {
                    hailReports += 1
                }
                _ = ObjectCardStormReportItem(
                    self.stackView,
                    stormReport,
                    UITapGestureRecognizerWithData(index, self, #selector(gotoMap(sender:)))
                )
            }
            if stormReport.state != "" { stateList += [stormReport.state] }
        }
        if tornadoReports == 0 {
            if tornadoHeader != nil {
                //self.stackView.removeArrangedSubview(tornadoHeader!.view)
            }
        }
        if windReports == 0 {
            if windHeader != nil {
                //self.stackView.removeArrangedSubview(windHeader!.view)
            }
        }
        if hailReports == 0 {
            if hailHeader != nil {
                //self.stackView.removeArrangedSubview(hailHeader!.view)
            }
        }
        let mappedItems = stateList.map { ($0, 1) }
        stateCount = Dictionary(mappedItems, uniquingKeysWith: +)
        let sortedKeys = stateCount.keys.sorted()
        for key in sortedKeys {
            let val = stateCount[key] ?? 0
            filterList += [key + ": " + String(val)]
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayPreContent()
                self.displayContent()
        }
        )
    }
}
