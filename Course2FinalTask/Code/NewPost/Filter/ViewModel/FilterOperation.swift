//
//  FilterOperation.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 23/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class FilterOperation: Operation {
    private(set) var _inputImage: UIImage?
    private(set) var outputImage: UIImage?
    private var cont: CIContext?
    private(set) var nameFilter: String?
    
    init(_ image: UIImage, name filter: String, in context: CIContext) {
        _inputImage = image
        cont = context
        nameFilter = filter
    }
    
    override func main() {
        
        guard let ciImage = CIImage.init(image: _inputImage!) else {return}
        guard let filter = CIFilter(name: nameFilter!) else {return}
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        let inputKeys = filter.inputKeys
        //        if inputKeys.contains(kCIInputIntensityKey) { filter.setValue(2, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputRadiusKey) { filter.setValue(2, forKey: kCIInputRadiusKey) }
        if inputKeys.contains("inputMaxComponents") {
            let arrMax: [CGFloat] = [0.5,0.2,0.78,1]
            let vectorMax = CIVector.init(values: arrMax, count: arrMax.count)
            filter.setValue(vectorMax, forKey: "inputMaxComponents")
        }
        
        //        if inputKeys.contains("inputCubeData") {
        //            let size: UInt = 64
        ////
        ////            var cubeData = [Float](repeating: 0, count: Int(size * size * size * 4))
        ////            var offset = 0
        ////            var x : Float = 1, y : Float = 0.5, z : Float = 0, a :Float = 0.8
        ////
        ////            for b in 0..<size {
        ////                x = Float(b)/Float(size)
        ////                for g in 0..<size {
        ////                    y = Float(g)/Float(size)
        ////                    for r in 0..<size {
        ////                        z = Float(r)/Float(size)
        ////                        cubeData[offset] = z
        ////                        cubeData[offset+1] = y
        ////                        cubeData[offset+2] = x
        ////                        cubeData[offset+3] =  a
        ////                        offset += 4
        ////                    }
        ////                }
        ////            }
        ////            let b = cubeData.withUnsafeBufferPointer{ Data(buffer:$0) }
        ////            let data = b as NSData
        //
        //            let floatSize = MemoryLayout<Float>.size
        //            let cubeSize = Int(size) * Int(size) * Int(size) * floatSize * 4
        //            let colorCube:[Float] = [
        //                1,1,1,0,
        //                1,1,1,0,
        //                1,1,1,0,
        //                1,1,1,0,
        //                1,1,1,0,
        //                1,1,1,0,
        //                1,1,1,0,
        //                1,1,1,0
        //            ]
        //            //let cubeSize = colorCube.count * floatSize
        //            let cubeData = NSData.init(bytes: colorCube, length: cubeSize)
        //
        //            filter .setValuesForKeys(["inputCubeDimension": size, "inputCubeData" : cubeData])
        //        }
        
        
        guard let fImage = filter.outputImage else {return}
        guard let cgImage = cont!.createCGImage(fImage, from: fImage.extent) else {return}
        outputImage = UIImage(cgImage: cgImage)
    }
    
    
    
}

