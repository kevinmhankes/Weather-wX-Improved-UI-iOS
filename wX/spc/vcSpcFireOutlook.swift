/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpcFireOutlook: UIwXViewControllerWithAudio {
    
    private var bitmap = Bitmap()
    private var text = ""
    var dayIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                playButton,
                playListButton,
                shareButton
        ]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }
    
    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let imgUrl = UtilitySpcFireOutlook.urls[self.dayIndex]
            self.product = UtilitySpcFireOutlook.products[self.dayIndex]
            self.text = UtilityDownload.getTextProduct(self.product)
            self.bitmap = Bitmap(imgUrl)
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        let vc = vcImageViewer()
        vc.imageViewerUrl = UtilitySpcFireOutlook.urls[dayIndex]
        self.goToVC(vc)
    }
    
    @objc override func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmap, text)
    }
    
    private func displayContent() {
        var tabletInLandscape = UtilityUI.isTablet() && UtilityUI.isLandscape()
        #if targetEnvironment(macCatalyst)
        tabletInLandscape = true
        #endif
        if tabletInLandscape {
            stackView.axis = .horizontal
            stackView.alignment = .firstBaseline
        }
        var views = [UIView]()
        let objectImage: ObjectImage
        if tabletInLandscape {
            objectImage = ObjectImage(
                self.stackView,
                bitmap,
                UITapGestureRecognizerWithData(0, self, #selector(imageClicked(sender:))),
                widthDivider: 2
            )
        } else {
            objectImage = ObjectImage(
                self.stackView,
                bitmap,
                UITapGestureRecognizerWithData(0, self, #selector(imageClicked(sender:)))
            )
        }
        objectImage.img.accessibilityLabel = text
        objectImage.img.isAccessibilityElement = true
        views.append(objectImage.img)
        if tabletInLandscape {
            objectTextView = ObjectTextView(self.stackView, self.text, widthDivider: 2)
        } else {
            objectTextView = ObjectTextView(self.stackView, self.text)
        }
        objectTextView.tv.isAccessibilityElement = true
        views.append(objectTextView.tv)
        self.view.bringSubviewToFront(self.toolbar)
        scrollView.accessibilityElements = views
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
