/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation
import MapKit

class vcCanadaText: UIwXViewController {

    private var product = "focn45"
    private var textView = ObjectTextView()
    private var productButton = ObjectToolbarIcon()
    private var siteButton = ObjectToolbarIcon()
    private var html = ""
    private var playButton = ObjectToolbarIcon()
    private var playlistButton = ObjectToolbarIcon()
    private let synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playlistButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                productButton,
                playButton,
                shareButton,
                playlistButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        product = Utility.readPref("CA_TEXT_LASTUSED", product)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.html = UtilityDownload.getTextProduct(self.product)
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc func playClicked() {
        UtilityActions.playClicked(textView.view, synth, playButton)
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, "Product Selection", productButton, UtilityCanada.products, self.productChanged(_:))
    }

    func productChanged(_ product: String) {
        self.product = product
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, html)
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(self.product, self.html, self, playlistButton)
    }

    private func displayContent() {
        self.refreshViews()
        textView = ObjectTextView(stackView)
        _ = ObjectCALegal(stackView)
        if self.html == "" {
            self.html = "None issused by this office recently."
        }
        self.textView.text = self.html
        self.productButton.title = self.product
        Utility.writePref("CA_TEXT_LASTUSED", self.product)
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
