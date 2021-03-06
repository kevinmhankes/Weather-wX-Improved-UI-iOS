// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class wXColor {

    var uiLabel = ""
    var prefVar = ""
    var defaultRed = 0
    var defaultGreen = 0
    var defaultBlue = 0
    var uiColorDefault = UIColor()
    var uiColorCurrent = UIColor()
    var colorsCurrent = (red: 0, green: 0, blue: 0)

    convenience init(_ color: Int, _ alpha: CGFloat = 1.0) {
        self.init()
        let cArr = intToColors(color)
        uiColorCurrent = wXColor.uiColorInt(cArr.red, cArr.green, cArr.blue, alpha)
    }

    convenience init(_ uiLabel: String, _ prefVar: String, _ defaultRed: Int, _ defaultGreen: Int, _ defaultBlue: Int) {
        self.init()
        self.uiLabel = uiLabel
        self.prefVar = prefVar
        self.defaultRed = defaultRed
        self.defaultGreen = defaultGreen
        self.defaultBlue = defaultBlue
        uiColorDefault = wXColor.uiColorInt(defaultRed, defaultGreen, defaultBlue)
        colorsCurrent = intToColors(Utility.readPref(prefVar, colorToInt(defaultRed, defaultGreen, defaultBlue)))
        uiColorCurrent = wXColor.uiColorInt(colorsCurrent.red, colorsCurrent.green, colorsCurrent.blue)
    }

    convenience init(_ uiLabel: String, _ prefVar: String, _ defaultColor: Int) {
        self.init()
        self.uiLabel = uiLabel
        self.prefVar = prefVar
        let (red, green, blue) = intToColors(defaultColor)
        defaultRed = red
        defaultGreen = green
        defaultBlue = blue
        uiColorDefault = wXColor.uiColorInt(defaultRed, defaultGreen, defaultBlue)
        colorsCurrent = intToColors(Utility.readPref(prefVar, colorToInt(defaultRed, defaultGreen, defaultBlue)))
        uiColorCurrent = wXColor.uiColorInt(colorsCurrent.red, colorsCurrent.green, colorsCurrent.blue)
    }

    func colorToInt(_ red: Int, _ green: Int, _ blue: Int) -> Int {
        (0xFF << 24) | (red << 16) | (green << 8) | blue
    }

    static func colorsToInt(_ red: Int, _ green: Int, _ blue: Int) -> Int {
        (0xFF << 24) | (red << 16) | (green << 8) | blue
    }

    static func uiColorInt(_ newRed: Int, _ newGreen: Int, _ newBlue: Int) -> UIColor {
        UIColor(red: newRed.toColor(), green: newGreen.toColor(), blue: newBlue.toColor(), alpha: CGFloat(1.0))
    }

    static func uiColorInt(_ newRed: Int, _ newGreen: Int, _ newBlue: Int, _ alpha: CGFloat) -> UIColor {
        UIColor(red: newRed.toColor(), green: newGreen.toColor(), blue: newBlue.toColor(), alpha: alpha)
    }

    static func uiColorInt(_ newRed: UInt8, _ newGreen: UInt8, _ newBlue: UInt8) -> UIColor {
        UIColor(red: newRed.toColor(), green: newGreen.toColor(), blue: newBlue.toColor(), alpha: CGFloat(1.0))
    }

    func intToColors(_ colorInt: Int) -> (red: Int, green: Int, blue: Int) {
        let newRed: Int = (colorInt >> 16) & 0xFF
        let newGreen: Int = (colorInt >> 8) & 0xFF
        let newBlue: Int = colorInt & 0xFF
        return (newRed, newGreen, newBlue)
    }

    func regenCurrentColor() {
        colorsCurrent = intToColors(Utility.readPref(prefVar, colorToInt(defaultRed, defaultGreen, defaultBlue)))
        uiColorCurrent = wXColor.uiColorInt(colorsCurrent.red, colorsCurrent.green, colorsCurrent.blue)
    }
}
