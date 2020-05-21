/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectColorPalette {
    
    var redValues = MemoryBuffer(16)
    var greenValues = MemoryBuffer(16)
    var blueValues = MemoryBuffer(16)
    private let colorMapCode: Int
    
    init(_ colorMapCode: Int) {
        self.colorMapCode = colorMapCode
    }
    
    private func setupBuffers(_ size: Int) {
        redValues = MemoryBuffer(size)
        greenValues = MemoryBuffer(size)
        blueValues = MemoryBuffer(size)
    }
    
    func initialize() {
        switch colorMapCode {
        case 19, 30, 41, 56, 78:
            setupBuffers(16)
            UtilityColorPalette4bitGeneric.generate(colorMapCode)
        case 165:
            setupBuffers(256)
            UtilityColorPalette165.loadColorMap()
        default:
            setupBuffers(256)
            UtilityColorPaletteGeneric.loadColorMap(colorMapCode)
        }
    }
}
