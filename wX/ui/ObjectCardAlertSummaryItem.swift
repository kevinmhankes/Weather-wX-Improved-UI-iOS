/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardAlertSummaryItem {

    init(
        _ scrollView: UIScrollView,
        _ stackView: UIStackView,
        _ office: String,
        _ location: String,
        _ alert: CapAlert,
        _ gesture: UITapGestureRecognizerWithData
    ) {
        let (title, startTime, endTime) = ObjectAlertDetail.condenseTime(alert)
        let tvName = ObjectTextViewLarge(0.0, text: office + " (" + location + ")", color: ColorCompatibility.highlightText)
        let tvTitle = ObjectTextView(title, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvStart = ObjectTextView("Start: " + startTime, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvEnd = ObjectTextView("End: " + endTime, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvArea = ObjectTextViewSmallGray(0.0, text: alert.area, isUserInteractionEnabled: false)
        tvName.tv.isAccessibilityElement = false
        tvTitle.tv.isAccessibilityElement = false
        tvStart.tv.isAccessibilityElement = false
        tvEnd.tv.isAccessibilityElement = false
        tvArea.tv.isAccessibilityElement = false
        let verticalTextConainer = ObjectStackView(
            .fill,
            .vertical,
            spacing: 0,
            arrangedSubviews: [tvName.view, tvTitle.view, tvStart.view, tvEnd.view, tvArea.view]
        )
        if location == "" {
            tvName.view.isHidden = true
        }
        if endTime == "" {
            tvEnd.view.isHidden = true
        }
        verticalTextConainer.view.isAccessibilityElement = true
        verticalTextConainer.view.accessibilityLabel = title + "Start: " + startTime + "End: " + endTime + alert.area
        let cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextConainer.view])
        stackView.addArrangedSubview(cardStackView.view)
        cardStackView.view.addGestureRecognizer(gesture)
        verticalTextConainer.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
}
