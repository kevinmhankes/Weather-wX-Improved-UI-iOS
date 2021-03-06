// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class TextUtils {

    static func join(_ delimiter: String, _ data: Set<String>) -> String {
        var s = ""
        data.forEach {
            s += $0 + delimiter
        }
	    return s
	}

    static func join(_ delimiter: String, _ data: [String]) -> String {
        var s = ""
        data.forEach {
            s += $0 + delimiter
        }
        return s
    }

    static func split(_ data: String, _ delimiter: String) -> [String] {
        var stringList = data.split(delimiter)
        stringList.removeLast()
        return stringList
    }
}
