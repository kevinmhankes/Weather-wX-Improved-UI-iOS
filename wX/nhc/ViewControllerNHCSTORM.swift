/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerNHCSTORM: UIwXViewController {

    var productButton = ObjectToolbarIcon()
    var buttonActionArray = [String]()
    var url = ""
    var titleS = ""
    var baseUrl = ""
    var stormId = ""
    var goesIdImg = ""
    var goesSector = ""
    var goesId = ""
    var imgUrl1 = ""
    var product = ""
    var bitmaps = [Bitmap]()
    var tv = ObjectTextView()
    let textProducts = [
        "MIATCP: Public Advisory",
        "MIATCM: Forecast Advisory",
        "MIATCD: Forecast Discussion",
        "MIAPWS: Wind Speed Probababilities"
    ]
    let stormUrls = [
        "_5day_cone_with_line_and_wind_sm2.png",
        "_W5_NL_sm2.png",
        "_W_NL_sm2.png",
        "_wind_probs_34_F120_sm2.png",
        "_wind_probs_50_F120_sm2.png",
        "_wind_probs_64_F120_sm2.png",
        "_R_sm2.png",
        "_S_sm2.png"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        url = ActVars.nhcStormUrl
        titleS = ActVars.nhcStormTitle
        imgUrl1 = ActVars.nhcStormImgUrl1
        let yearInString = String(UtilityTime.getYear()).substring(2, 4)
        baseUrl = imgUrl1.replace(yearInString+"_5day_cone_with_line_and_wind_sm2.png", "")
        baseUrl += yearInString
        stormId = baseUrl.substring(baseUrl.count - 4)
        goesIdImg = stormId.substring(stormId.count - 4, stormId.count - 2)
        stormId = ActVars.nhcStormWallet
        stormId = stormId.replace("EP0", "EP").replace("AL0", "AL")
        goesSector = stormId.truncate(1)
        goesSector = goesSector.replace("A", "L")  // value is either E or L
        stormId = stormId.replace("AL", "AT")
        goesId = stormId.replace("EP", "").replace("AT", "")
        if goesId.count < 2 {
            goesId = "0" + goesId
        }
        product = "MIATCP" + stormId
        productButton = ObjectToolbarIcon(title: " Text Prod", self, #selector(productClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, productButton, shareButton]).items
        self.view.addSubview(toolbar)
        _ = ObjectScrollStackView(self, scrollView, stackView)
        tv = ObjectTextView(self.stackView, "")
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownload.getTextProduct(self.product)
            self.bitmaps.append(UtilityNHC.getImage(self.goesIdImg + self.goesSector, "vis"))
            self.stormUrls.forEach {self.bitmaps.append(Bitmap(self.baseUrl + $0))}
            self.bitmaps.append(Bitmap(MyApplication.nwsNhcWebsitePrefix + "/tafb_latest/danger_pac_latestBW_sm3.gif"))
            DispatchQueue.main.async {
                self.tv.text = html
                self.bitmaps.filter {($0.isValid)}.forEach {_ = ObjectImage(self.stackView, $0)}
                self.view.bringSubviewToFront(self.toolbar)
            }
        }
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, self.bitmaps)
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, "Product Selection", productButton, textProducts, self.productChanged(_:))
    }

    func productChanged(_ product: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownload.getTextProduct(product + self.stormId)
            DispatchQueue.main.async {
                ActVars.textViewText = html
                self.goToVC("textviewer")
            }
        }
    }
}
