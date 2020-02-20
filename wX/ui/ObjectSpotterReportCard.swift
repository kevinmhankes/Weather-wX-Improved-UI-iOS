/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSpotterReportCard {

    init(_ scrollView: UIScrollView, _ stackView: UIStackView, _ spotterReport: SpotterReports, _ gesture: UITapGestureRecognizer) {
        let sV = ObjectStackView(.fill, .vertical, spacing: 0)
        var textViews = [ObjectTextView]()
        let topLine = spotterReport.type + " " + spotterReport.time
        let middleLine = spotterReport.city
        let bottomLine = spotterReport.lastName + ", " + spotterReport.firstName
        textViews.append(ObjectTextView(sV.view, topLine, isUserInteractionEnabled: false, isZeroSpacing: true))
        textViews.append(ObjectTextView(sV.view, middleLine, isUserInteractionEnabled: false, isZeroSpacing: true))
        textViews.append(ObjectTextView(sV.view, bottomLine, isUserInteractionEnabled: false, isZeroSpacing: true))
        textViews[0].font = FontSize.medium.size
        textViews[1].font = FontSize.small.size
        textViews[2].font = FontSize.small.size
        textViews[0].color = ColorCompatibility.highlightText
        textViews[1].color = ColorCompatibility.label
        textViews[2].color = ColorCompatibility.systemGray2
        stackView.addArrangedSubview(sV.view)
        textViews.forEach {
            $0.tv.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }
        sV.view.addGestureRecognizer(gesture)
    }
}
