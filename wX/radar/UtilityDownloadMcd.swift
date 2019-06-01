/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilityDownloadMcd {

    static var initialized = false
    static var currentTime: CLong = 0
    static var currentTimeSeconds: CLong = 0
    static var refreshIntervalSeconds: CLong = 0
    static var lastRefresh: CLong = 0
    static var refreshDataInMinutes = RadarPreferences.radarDataRefreshInterval

    static func getData() {
        currentTime = UtilityTime.currentTimeMillis()
        currentTimeSeconds = currentTime / 1000
        refreshIntervalSeconds = refreshDataInMinutes * 60
        if !PolygonType.TST.display {
            UtilityDownloadRadar.clearPolygonVtec()
        }
        if !PolygonType.MPD.display {
            UtilityDownloadRadar.clearMpd()
        }
        if !PolygonType.MCD.display {
            UtilityDownloadRadar.clearMcd()
            UtilityDownloadRadar.clearWatch()
        }
        if (currentTimeSeconds > (lastRefresh + refreshIntervalSeconds)) || !initialized {
            if PolygonType.TST.display {
                UtilityDownloadRadar.getPolygonVtec()
            } else {
                UtilityDownloadRadar.clearPolygonVtec()
            }
            ObjectPolygonWarning.polygonList.forEach {
                let polygonType = ObjectPolygonWarning.polygonDataByType[$0]!
                if polygonType.isEnabled {
                    UtilityDownloadRadar.getPolygonVtecByType(polygonType)
                } else {
                    UtilityDownloadRadar.getPolygonVtecByTypeClear(polygonType)
                }
            }
            if PolygonType.MPD.display {
                UtilityDownloadRadar.getMpd()
            } else {
                UtilityDownloadRadar.clearMpd()
            }
            if PolygonType.MCD.display {
                UtilityDownloadRadar.getMcd()
                UtilityDownloadRadar.getWatch()
            } else {
                UtilityDownloadRadar.clearMcd()
                UtilityDownloadRadar.clearWatch()
            }
            initialized = true
            let currentTime: CLong = UtilityTime.currentTimeMillis()
            lastRefresh = currentTime / 1000
        }
    }
}
