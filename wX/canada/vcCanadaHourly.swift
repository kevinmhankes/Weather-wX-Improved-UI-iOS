/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcCanadaHourly: UIwXViewControllerWithAudio {

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        objectTextView = Text(stackView, "", FontSize.hourly.size)
        objectTextView.constrain(scrollView)
        _ = ObjectCanadaLegal(stackView)
        getContent()
    }

    override func getContent() {
//        DispatchQueue.global(qos: .userInitiated).async {
//            let html = UtilityCanadaHourly.getString(Location.getLocationIndex)
//            DispatchQueue.main.async { self.display(html) }
//        }
        _ = FutureText2({ UtilityCanadaHourly.getString(Location.getLocationIndex) }, objectTextView.setText)
    }

    private func display(_ html: String) {
//        objectTextView.text = html
        objectTextView.setText(html)
    }
}
