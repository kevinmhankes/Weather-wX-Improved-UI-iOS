// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation
import CoreFoundation
import CoreGraphics

// https://developer.apple.com/reference/corefoundation/1667080-byte_order_utilities#//apple_ref/c/tdef/CFByteOrder
// reads assume bigendian format and then convert to little endian
// writes specifically convert back to big endian for float and int

final class MemoryBuffer {

    private var backingArray = [UInt8]()
    private var posn = 0
    var capacity = 0
    private var markPosition = 0

    init() {}

    init(_ size: Int) {
        backingArray = [UInt8](repeating: 0, count: size)
        capacity = size
    }

    init(_ array: [UInt8]) {
        backingArray = array
        capacity = array.count
        posn = 0
    }

    var array: [UInt8] { backingArray }

    var eof: Bool {
        if posn < (capacity - 1) {
            return false
        } else {
            return true
        }
    }

    var filePointer: Int { posn }

    var length: Int { capacity }

    func seek(_ position: Int) {
        posn = position
    }

//    var address: UnsafeMutablePointer<UInt8> {
//        let iBuffPtr = UnsafeMutablePointer(mutating: backingArray)
//        let iBuffPtr2 = iBuffPtr.advanced(by: posn)
//        return iBuffPtr2
//    }

    init(_ data: Data) {
        // backingArray = data.withUnsafeBytes {
        //    Array(UnsafeBufferPointer<UInt8>(start: $0, count: data.count/MemoryLayout<UInt8>.size))
        // }
        backingArray = [UInt8](data)
        capacity = data.count
    }

    func skipBytes(_ count: Int) {
        posn += count
    }

//    func mark() {
//        markPosition = posn
//    }

    func mark(_ index: Int) {
        markPosition = posn
        posn = index
    }

    func reset() {
        posn = markPosition
    }

    func get(_ index: Int) -> UInt8 {
        backingArray[index]
    }

    func get() -> UInt8 {
        posn += 1
        return backingArray[posn-1]
    }

    func put(_ byte: UInt8) {
        backingArray[posn] = byte
        posn += 1
    }

    func put(_ index: Int, _ newValue: UInt8) {
        backingArray[index] = newValue
    }

    func putFloat(_ newValue: Float) {
        var float = newValue
        memcpy(&backingArray[posn], &float, 4)
        posn += 4
    }

//    func putFloat(_ newValue: Double) {
//        var float = Float(newValue)
//        memcpy(&backingArray[posn], &float, 4)
//        posn += 4
//    }

    func getFloat() -> Float {
        let bytes: [UInt8] = [backingArray[posn + 3], backingArray[posn + 2], backingArray[posn + 1], backingArray[posn]]
        var float: Float = 0.0
        posn += 4
        memcpy(&float, bytes, 4)
        return float
    }

//    func getCGFloat() -> CGFloat {
//        let bytes: [UInt8] = [backingArray[posn + 3], backingArray[posn + 2], backingArray[posn + 1], backingArray[posn]]
//        var float: Float = 0.0
//        posn += 4
//        memcpy(&float, bytes, 4)
//        return CGFloat(float)
//    }

    func getInt() -> Int {
        let bytes: [UInt8] = [backingArray[posn + 3], backingArray[posn + 2], backingArray[posn + 1], backingArray[posn]]
        var integer = 0
        posn += 4
        memcpy(&integer, bytes, 4)
        return integer
    }

    func getFloatNative(_ index: Int) -> Double {
        let bytes: [UInt8] = [backingArray[index], backingArray[index + 1], backingArray[index + 2], backingArray[index + 3]]
        var float: Float = 0.0
        memcpy(&float, bytes, 4)
        return Double(float)
    }

//    func getCGFloatNative() -> CGFloat {
//        let bytes: [UInt8] = [backingArray[posn], backingArray[posn + 1], backingArray[posn + 2], backingArray[posn + 3]]
//        var float: Float = 0.0
//        posn += 4
//        memcpy(&float, bytes, 4)
//        return CGFloat(float)
//    }
    
    func getCGFloatNative() -> Float {
        let bytes: [UInt8] = [backingArray[posn], backingArray[posn + 1], backingArray[posn + 2], backingArray[posn + 3]]
        var float: Float = 0.0
        posn += 4
        memcpy(&float, bytes, 4)
        return float
    }

    func copy(_ newArray: [UInt8]) {
        backingArray = newArray
    }

    func appendArray(_ newArray: [UInt8]) {
        backingArray += newArray
        capacity = backingArray.count
    }

    var position: Int {
        get { posn }
        set { posn = newValue }
    }

//    func putShort(_ newValue: UInt16) {
//        var unsignedShort: UInt16 = newValue
//        memcpy(&backingArray[posn], &unsignedShort, 2)
//        posn += 2
//    }

    func putSignedShort(_ newValue: Int16) {
        var short = newValue
        memcpy(&backingArray[posn], &short, 2)
        posn += 2
    }

   func getShortNative() -> Int16 {
        let bytes: [UInt8] = [backingArray[posn], backingArray[posn + 1]]
        var short: Int16 = 0
        posn += 2
        memcpy(&short, bytes, 2)
        return short
    }

    func getShort() -> Int16 {
        let bytes: [UInt8] = [backingArray[posn + 1], backingArray[posn]]
        var short: Int16 = 0
        posn += 2
        memcpy(&short, bytes, 2)
        return short
    }

    func getUnsignedShort() -> UInt16 {
        let bytes: [UInt8] = [backingArray[posn + 1], backingArray[posn]]
        var unsignedShort: UInt16 = 0
        posn += 2
        memcpy(&unsignedShort, bytes, 2)
        return unsignedShort
    }

    func putInt(_ newValue: Int32) {
        var unsignedInt: UInt32 = CFSwapInt32(UInt32(newValue))
        memcpy(&backingArray[posn], &unsignedInt, 4)
        posn += 4
    }

    static func getPointer(_ buffer: [UInt8]) -> UnsafeMutablePointer<Int8> {
        let oBuffPtr1 = UnsafeRawPointer(buffer)
        let oBuffPtr2 = OpaquePointer(oBuffPtr1)
        return UnsafeMutablePointer<Int8>(oBuffPtr2)
    }

//    static func getPointer(_ buffer: [Float]) -> UnsafeMutablePointer<Float> {
//        let oBuffPtr1 = UnsafeRawPointer(buffer)
//        let oBuffPtr2 = OpaquePointer(oBuffPtr1)
//        return UnsafeMutablePointer<Float>(oBuffPtr2)
//    }

    static func getPointerAndAdvance(_ buffer: [UInt8], by: Int) -> UnsafeMutablePointer<Int8> {
        let iBuffPtr1 = UnsafeRawPointer(buffer)
        let iBuffPtr2 = iBuffPtr1.advanced(by: by)
        let iBuffPtr3 = OpaquePointer(iBuffPtr2)
        return UnsafeMutablePointer<Int8>(iBuffPtr3)
    }
}
