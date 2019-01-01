/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class ObjectMenuTitle {

    var title: String
    var count: Int

    init(_ title: String, _ count: Int) {
		self.title = title
        self.count = count
	}

    static func getStart(_ titles: [ObjectMenuTitle], _ index: Int) -> Int {
        if index == 0 {
            return 0
        }
        var sum = 0
        (0..<index).forEach {
            sum += titles[$0].count
        }
        return sum
    }
}
