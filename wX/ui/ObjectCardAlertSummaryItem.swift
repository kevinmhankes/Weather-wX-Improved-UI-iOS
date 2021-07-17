/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardAlertSummaryItem {

    init(
        _ uiv: UIwXViewController,
        _ office: String,
        _ location: String,
        _ alert: CapAlert,
        _ gesture: GestureData,
        _ gestureRadar: GestureData,
        _ gestureRadarText: GestureData
    ) {
        // start icons
        let radarIcon = ToolbarIcon(iconType: .radar, gesture: gestureRadar)
        let radarText = Text("Radar")
        radarText.addGestureRecognizer(gestureRadarText)
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let horizontalContainer = ObjectStackView(
            .fillProportionally,
            .horizontal,
            spacing: 10,
            arrangedSubviews: [radarIcon.button, radarText.tv, spacerView]
        )
        // horizontalContainer.uiStackView.distribution = .equalSpacing
        // end icons
        let (title, startTime, endTime) = ObjectAlertDetail.condenseTime(alert)
        let tvName = TextLarge(0.0, text: office + " (" + location + ")", color: ColorCompatibility.highlightText)
        let tvTitle = Text(title, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvStart = Text("Start: " + startTime, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvEnd = Text("End: " + endTime, isUserInteractionEnabled: false, isZeroSpacing: true)
        let tvArea = TextSmallGray(text: alert.area, isUserInteractionEnabled: false)
        tvName.tv.isAccessibilityElement = false
        tvTitle.tv.isAccessibilityElement = false
        tvStart.tv.isAccessibilityElement = false
        tvEnd.tv.isAccessibilityElement = false
        tvArea.tv.isAccessibilityElement = false
        let verticalTextContainer = ObjectStackView(
            .fill,
            .vertical,
            spacing: 0,
            arrangedSubviews: [tvName.view, tvTitle.view, tvStart.view, tvEnd.view, tvArea.view, horizontalContainer.view]
        )
        if location == "" {
            tvName.view.isHidden = true
        }
        if endTime == "" {
            tvEnd.view.isHidden = true
        }
        if office == "" {
            radarIcon.button.isHidden = true
            radarText.tv.isHidden = true
        }
        verticalTextContainer.view.isAccessibilityElement = true
        verticalTextContainer.view.accessibilityLabel = title + "Start: " + startTime + "End: " + endTime + alert.area
        let cardStackView = ObjectCardStackView(arrangedSubviews: [verticalTextContainer.view])
        uiv.stackView.addArrangedSubview(cardStackView.view)
        cardStackView.view.addGestureRecognizer(gesture)
        verticalTextContainer.view.widthAnchor.constraint(equalTo: uiv.scrollView.widthAnchor).isActive = true
    }
}
