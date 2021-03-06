// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Metal

class ObjectMetalBuffers {
    
    var metalBuffer = [Float]()
    var floatBuffer = MemoryBuffer()
    var colorIntArray = [Int]()
    var red: UInt8 = 0
    var green: UInt8 = 0
    var blue: UInt8 = 0
    var count = 0
    var lenInit = 7.5
    var latList = [Double]()
    var lonList = [Double]()
    var triangleCount = 0
    var scaleCutOff: Float = 0.0
    var type: PolygonType = .NONE
    var typeEnum: PolygonEnum = .NONE
    var geoType: GeographyType = .NONE
    let floatCountPerVertex = 5 // x y r g b a ( last 4 bytes )
    var vertexCount = 0
    var mtlBuffer: MTLBuffer?
    var shape: MTLPrimitiveType = .triangle
    var honorDisplayHold = false
    
    init() {}
    
    convenience init (_ type: PolygonType) {
        self.init()
        self.type = type
        setTypeEnum()
        switch typeEnum {
        case .LOCDOT, .WIND_BARB_CIRCLE, .SPOTTER, .HI, .TVS:
            shape = .triangle
        default:
            shape = .line
        }
    }
    
    convenience init (_ geoType: GeographyType, _ scaleCutOff: Float) {
        self.init()
        self.geoType = geoType
        self.scaleCutOff = scaleCutOff
        shape = .line
    }
    
    convenience init (_ type: PolygonType, _ scaleCutOff: Float) {
        self.init()
        self.type = type
        setTypeEnum()
        self.scaleCutOff = scaleCutOff
        honorDisplayHold = true
        switch typeEnum {
        case .LOCDOT, .WIND_BARB_CIRCLE, .SPOTTER, .HI, .TVS:
            shape = .triangle
        default:
            shape = .line
        }
        
        if typeEnum == .LOCDOT_CIRCLE || typeEnum == .LOCDOT {
            honorDisplayHold = false
        }
    }
    
    func setTypeEnum() {
        switch type.string {
        case "MCD":
            typeEnum = .SPCMCD
        case "MPD":
            typeEnum = .WPCMPD
        case "WATCH":
            typeEnum = .SPCWAT
        case "WATCH_TORNADO":
            typeEnum = .SPCWAT_TORNADO
        case "TOR":
            typeEnum = .TOR
        case "TST":
            typeEnum = .TST
        case "FFW":
            typeEnum = .FFW
        case "SMW":
            typeEnum = .SMW
        case "SQW":
            typeEnum = .SQW
        case "DSW":
            typeEnum = .DSW
        case "SPS":
            typeEnum = .SPS
        case "STI":
            typeEnum = .STI
        case "LOCDOT":
            typeEnum = .LOCDOT
        case "LOCDOT_CIRCLE":
            typeEnum = .LOCDOT_CIRCLE
        case "SPOTTER":
            typeEnum = .SPOTTER
        case "HI":
            typeEnum = .HI
        case "TVS":
            typeEnum = .TVS
        case "WIND_BARB_CIRCLE":
            typeEnum = .WIND_BARB_CIRCLE
        default:
            typeEnum = .NONE
        }
    }
    
    func generateMtlBuffer(_ device: MTLDevice) {
        if count > 0 {
            let dataSize = metalBuffer.count * MemoryLayout.size(ofValue: metalBuffer[0])
            mtlBuffer = device.makeBuffer(bytes: metalBuffer, length: dataSize, options: [])!
            switch typeEnum {
            case .LOCDOT, .WIND_BARB_CIRCLE, .SPOTTER, .HI, .TVS:
                vertexCount = triangleCount * 3 * count
            default:
                vertexCount = count / 2
            }
        } else {
            // if type.string != "" {
                vertexCount = 0
            // }
        }
    }
    
    func initialize(_ floatCount: Int) {
        floatBuffer = MemoryBuffer(floatCount)
        metalBuffer = Array(repeating: 0.0, count: floatCountPerVertex * (count * 2)) // x y r g b
        setToPositionZero()
    }
    
    func initialize(_ floatCount: Int, _ solidColor: Int) {
        self.initialize(floatCount)
        red = solidColor.red()
        green = solidColor.green()
        blue = solidColor.blue()
    }
    
    func setToPositionZero() {
        floatBuffer.position = 0
    }
    
    func putFloat(_ newValue: Float) {
        metalBuffer.append(newValue)
    }
    
    func putFloat(_ newValue: Double) {
        metalBuffer.append(Float(newValue))
    }
    
    func putColor(_ byte: UInt8) {
        metalBuffer.append(Float(Float(byte)/Float(255.0)))
    }
    
    func getColorArrayInFloat() -> [Float] {
        [red.toColor(), green.toColor(), blue.toColor()]
    }
    
    func putColors() {
        putColor(red)
        putColor(green)
        putColor(blue)
    }
    
    func setCount(_ count: Int) {
        self.count = count
    }
    
    func setXYList(_ combinedLatLonList: [Double]) {
        latList = [Double](repeating: 0, count: combinedLatLonList.count / 2)
        lonList = [Double](repeating: 0, count: combinedLatLonList.count / 2)
        stride(from: 0, to: combinedLatLonList.count, by: 2).forEach { index in
            latList[index / 2] = combinedLatLonList[index]
            lonList[index / 2] = combinedLatLonList[index + 1]
        }
    }
    
    func draw(_ pn: ProjectionNumbers) {
        switch typeEnum {
        case .HI:
            ObjectMetalBuffers.redrawTriangleUp(self, pn)
        case .SPOTTER:
            ObjectMetalBuffers.redrawCircle(self, pn)
        case .TVS:
            ObjectMetalBuffers.redrawTriangleUp(self, pn)
        case .LOCDOT:
            ObjectMetalBuffers.redrawCircle(self, pn)
        case .WIND_BARB_CIRCLE:
            ObjectMetalBuffers.redrawCircleWithColor(self, pn)
        default:
            ObjectMetalBuffers.redrawTriangle(self, pn)
        }
    }
    
    static func redrawTriangle(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers) {
        UtilityWXMetalPerf.genTriangle(buffers, pn)
    }
    
    static func redrawTriangleUp(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers) {
        UtilityWXMetalPerf.genTriangleUp(buffers, pn)
    }
    
    static func redrawCircle(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers) {
        UtilityWXMetalPerf.genCircle(buffers, pn)
    }
    
    static func redrawCircleWithColor(_ buffers: ObjectMetalBuffers, _ pn: ProjectionNumbers) {
        UtilityWXMetalPerf.genCircleWithColor(buffers, pn)
    }
}
