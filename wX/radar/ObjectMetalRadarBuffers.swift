// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class ObjectMetalRadarBuffers: ObjectMetalBuffers {
    
    var bgColor = 0
    var fileName = "nids"
    var rd = WXMetalNexradLevelData()
    var fileStorage = FileStorage()
    // Feb 22 add 3
    var numberOfRadials = 0
    var numberOfRangeBins = 0
    var binSize = 0.0
    
    init(_ bgColor: Int) {
        self.bgColor = bgColor
    }
    
    var colorMap: ObjectColorPalette { ObjectColorPalette.colorMap[Int(rd.productCode)]! }
    
    func initialize() {
        if !RadarPreferences.showRadarWhenPan {
            honorDisplayHold = true
        }
        if rd.productCode == 37 || rd.productCode == 38 || rd.productCode == 41 || rd.productCode == 57 {
            if floatBuffer.capacity < (48 * 464 * 464) {
                floatBuffer = MemoryBuffer(48 * 464 * 464)
            }
        } else {
            if floatBuffer.capacity < (32 * rd.numberOfRadials * rd.numberOfRangeBins) {
                floatBuffer = MemoryBuffer(32 * rd.numberOfRadials * rd.numberOfRangeBins)
            }
        }
        setToPositionZero()
    }
    
    func putColorsByIndex(_ level: UInt8) {
        putColor(colorMap.redValues.get(Int(level)))
        putColor(colorMap.greenValues.get(Int(level)))
        putColor(colorMap.blueValues.get(Int(level)))
    }
    
    func generateRadials() -> Int {
        let totalBins: Int
        switch rd.productCode {
        case 37, 38:
            totalBins = UtilityWXMetalPerfRaster.generate(self)
        case 153, 154, 30, 56, 78, 80, 181:
            totalBins = UtilityWXMetalPerf.genRadials(self)
        case 0:
            totalBins = 0
        default:
            totalBins = UtilityWXMetalPerf.decode8BitAndGenRadials(self, fileStorage)
        }
        return totalBins
    }
    
    func setCount() {
        count = (metalBuffer.count / floatCountPerVertex) * 2
    }
}
