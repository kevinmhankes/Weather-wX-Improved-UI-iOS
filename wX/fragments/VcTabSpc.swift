// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcTabSpc: VcTabParent {

    private var tilesPerRow = UIPreferences.tilesPerRow

    override func viewDidLoad() {
        super.viewDidLoad()
        objTileMatrix = ObjectTileMatrix(self, stackView, .spc)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tilesPerRow != UIPreferences.tilesPerRow {
            stackView.removeArrangedViews()
            tilesPerRow = UIPreferences.tilesPerRow
            objTileMatrix = ObjectTileMatrix(self, stackView, .spc)
        }
        updateColors()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle && UIApplication.shared.applicationState == .inactive {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    AppColors.update()
                } else {
                    AppColors.update()
                }
                updateColors()
            } else {
            }
        }
    }

    override func updateColors() {
        objTileMatrix.toolbar.setColorToTheme()
        super.updateColors()
    }
}
