// https://noahgilmore.com/blog/dark-mode-uicolor-compatibility/
// Thanks to Noah Gilmore for the article and code found at the URL above
// Backwards compatibility for iOS 13 system colors
// In the distant future when iOS 12 support is dropped simply replace code ColorCompatibility with UIColor

import UIKit

enum ColorCompatibility {
    static var label: UIColor {
        if #available(iOS 13, *) {
            return .label
        }
        return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    static var secondaryLabel: UIColor {
        if #available(iOS 13, *) {
            return .secondaryLabel
        }
        return UIColor(red: 0.6215686274509803, green: 0.6215686274509803, blue: 0.6607843137254902, alpha: 1.0)
    }
    static var tertiaryLabel: UIColor {
        if #available(iOS 13, *) {
            return .tertiaryLabel
        }
        return UIColor(red: 0.9215686274509803, green: 0.9215686274509803, blue: 0.9607843137254902, alpha: 0.3)
    }
    static var quaternaryLabel: UIColor {
        if #available(iOS 13, *) {
            return .quaternaryLabel
        }
        return UIColor(red: 0.9215686274509803, green: 0.9215686274509803, blue: 0.9607843137254902, alpha: 0.18)
    }
    static var systemFill: UIColor {
        if #available(iOS 13, *) {
            return .systemFill
        }
        return UIColor(red: 0.47058823529411764, green: 0.47058823529411764, blue: 0.5019607843137255, alpha: 0.36)
    }
    static var secondarySystemFill: UIColor {
        if #available(iOS 13, *) {
            return .secondarySystemFill
        }
        return UIColor(red: 0.47058823529411764, green: 0.47058823529411764, blue: 0.5019607843137255, alpha: 0.32)
    }
    static var tertiarySystemFill: UIColor {
        if #available(iOS 13, *) {
            return .tertiarySystemFill
        }
        return UIColor(red: 0.4627450980392157, green: 0.4627450980392157, blue: 0.5019607843137255, alpha: 0.24)
    }
    static var quaternarySystemFill: UIColor {
        if #available(iOS 13, *) {
            return .quaternarySystemFill
        }
        return UIColor(red: 0.4627450980392157, green: 0.4627450980392157, blue: 0.5019607843137255, alpha: 0.18)
    }
    static var placeholderText: UIColor {
        if #available(iOS 13, *) {
            return .placeholderText
        }
        return UIColor(red: 0.9215686274509803, green: 0.9215686274509803, blue: 0.9607843137254902, alpha: 0.3)
    }
    static var systemBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        }
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    static var secondarySystemBackground: UIColor {
        if #available(iOS 13, *) {
            return .secondarySystemBackground
        }
        return UIColor(red: 0.10980392156862745, green: 0.10980392156862745, blue: 0.11764705882352941, alpha: 1.0)
    }
    static var tertiarySystemBackground: UIColor {
        if #available(iOS 13, *) {
            return .tertiarySystemBackground
        }
        return UIColor(red: 0.17254901960784313, green: 0.17254901960784313, blue: 0.1803921568627451, alpha: 1.0)
    }
    static var systemGroupedBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemGroupedBackground
        }
        return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    static var secondarySystemGroupedBackground: UIColor {
        if #available(iOS 13, *) {
            return .secondarySystemGroupedBackground
        }
        return UIColor(red: 0.10980392156862745, green: 0.10980392156862745, blue: 0.11764705882352941, alpha: 1.0)
    }
    static var tertiarySystemGroupedBackground: UIColor {
        if #available(iOS 13, *) {
            return .tertiarySystemGroupedBackground
        }
        return UIColor(red: 0.17254901960784313, green: 0.17254901960784313, blue: 0.1803921568627451, alpha: 1.0)
    }
    static var separator: UIColor {
        if #available(iOS 13, *) {
            return .separator
            // return .systemGray5
        }
        return UIColor(red: 0.32941176470588235, green: 0.32941176470588235, blue: 0.34509803921568627, alpha: 0.6)
    }
    static var opaqueSeparator: UIColor {
        if #available(iOS 13, *) {
            return .opaqueSeparator
        }
        return UIColor(red: 0.2196078431372549, green: 0.2196078431372549, blue: 0.22745098039215686, alpha: 1.0)
    }
    static var link: UIColor {
        if #available(iOS 13, *) {
            return .link
        }
        return UIColor(red: 0.03529411764705882, green: 0.5176470588235295, blue: 1.0, alpha: 1.0)
    }
    static var systemIndigo: UIColor {
        if #available(iOS 13, *) {
            return .systemIndigo
        }
        return UIColor(red: 0.3686274509803922, green: 0.3607843137254902, blue: 0.9019607843137255, alpha: 1.0)
    }
    static var systemGray2: UIColor {
        if #available(iOS 13, *) {
            return .systemGray2
        }
        return UIColor(red: 0.38823529411764707, green: 0.38823529411764707, blue: 0.4, alpha: 1.0)
    }
    static var systemGray3: UIColor {
        if #available(iOS 13, *) {
            return .systemGray3
        }
        return UIColor(red: 0.2823529411764706, green: 0.2823529411764706, blue: 0.2901960784313726, alpha: 1.0)
    }
    static var systemGray4: UIColor {
        if #available(iOS 13, *) {
            return .systemGray4
        }
        return UIColor(red: 0.22745098039215686, green: 0.22745098039215686, blue: 0.23529411764705882, alpha: 1.0)
    }
    static var systemGray5: UIColor {
        if #available(iOS 13, *) {
            return .systemGray5
        }
        return UIColor(red: 0.17254901960784313, green: 0.17254901960784313, blue: 0.1803921568627451, alpha: 1.0)
    }
    static var systemGray6: UIColor {
        if #available(iOS 13, *) {
            return .systemGray6
        }
        return UIColor(red: 0.10980392156862745, green: 0.10980392156862745, blue: 0.11764705882352941, alpha: 1.0)
    }
    static var highlightText: UIColor {
        if #available(iOS 13, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                return ColorCompatibility.link
            } else {
                return UIColor(red: 0.054901960784313725, green: 0.2784313725490196, blue: 0.6313725490196078, alpha: 1.0)
            }
        }
        return UIColor.blue
    }
}
