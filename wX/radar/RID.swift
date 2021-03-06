// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

struct RID {

    let name: String
    let location: LatLon
    var distance = 0

    init(_ name: String, _ location: LatLon) {
        self.name = name
        self.location = location
    }
}
