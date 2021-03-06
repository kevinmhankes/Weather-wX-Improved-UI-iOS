// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class UtilityIO {

    static func uncompress(_ disFirst: MemoryBuffer) -> MemoryBuffer {
        // was 1 not 2, Feb 22
        var retSize: UInt32 = 2000000
        let oBuff = [UInt8](repeating: 1, count: Int(retSize))
        let compressedFileSize: CLong = disFirst.capacity - disFirst.position
        BZ2_bzBuffToBuffDecompress(
            MemoryBuffer.getPointer(oBuff),
            &retSize,
            MemoryBuffer.getPointerAndAdvance(disFirst.array, by: disFirst.position),
            UInt32(compressedFileSize),
            1,
            0
        )
        return MemoryBuffer(oBuff)
    }
    
    static func readTextFile(_ file: String) -> String {
        let fnParts = file.split(".")
        let path = Bundle.main.path(forResource: fnParts[0], ofType: fnParts[1])
        return (try? String(contentsOfFile: path!, encoding: .utf8)) ?? ""
    }

    static func saveInputStream(_ data: Data, _ filename: String) {
        do {
            let documentDirUrl = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let fileUrl = documentDirUrl.appendingPathComponent(filename)
            try data.write(to: fileUrl, options: .atomic)
        } catch let error as NSError {
            print(error.description)
        }
    }

    static func readFileToByteBuffer(_ filename: String) -> MemoryBuffer {
        do {
            let documentDirUrl = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let fileUrl = documentDirUrl.appendingPathComponent(filename)
            let data = (try? Data(contentsOf: fileUrl)) ?? Data()
            return MemoryBuffer(data)
        } catch {
            print("error in readFiletoByteBuffer")
            return MemoryBuffer()
        }
    }

//    static func readFileToData(_ filename: String) -> Data {
//        do {
//            let documentDirUrl = try FileManager.default.url(
//                for: .documentDirectory,
//                in: .userDomainMask,
//                appropriateFor: nil,
//                create: true
//            )
//            let fileUrl = documentDirUrl.appendingPathComponent(filename)
//            return try Data(contentsOf: fileUrl)
//        } catch {
//            print("error in readFileToData")
//            return Data()
//        }
//    }

    static func readBitmapResourceFromFile(_ file: String) -> Bitmap {
        Bitmap(UIImage(named: file) ?? UIImage())
    }

    static func rawFileToStringArray(_ rawFile: String) -> [String] {
        UtilityIO.readTextFile(rawFile).split("\n")
    }
    
    static func getHtml(_ url: String) -> String {
        UtilityNetworkIO.getStringFromUrl(url)
    }
}
