/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final public class StormReport {

    let text: String
    let lat: String
    let lon: String
    let time: String
    let magnitude: String
    let address: String
    let city: String
    let state: String
    let damageReport: String
    let damageHeader: String

    init(
        _ text: String,
        _ lat: String,
        _ lon: String,
        _ time: String,
        _ magnitude: String,
        _ address: String,
        _ city: String,
        _ state: String,
        _ damageReport: String,
        _ damageHeader: String
    ) {
        self.text = text
        self.lat = lat
        self.lon = lon
        self.time = time
        self.magnitude = magnitude
        self.address = address
        self.city = city
        self.state = state
        self.damageReport = damageReport
        self.damageHeader = damageHeader
	  }
}
