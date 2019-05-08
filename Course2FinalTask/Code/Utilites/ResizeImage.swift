//
//  ResizeImage.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 23/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import Accelerate

extension UIImage {
    func resize(_ size: CGSize) -> UIImage {
        let sizeSelf = self.size
        
        let widthRatio = size.width / sizeSelf.width
        let heightRatio = size.height / sizeSelf.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

extension UIImage{
    //https://medium.com/ios-expert-series-or-interview-series/resize-image-with-swift-4-ca17d65bbc85
    func resizeImageUsingVImage(size:CGSize) -> UIImage? {
        let cgImage = self.cgImage!
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer {
            free(sourceBuffer.data)
        }
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        // create a destination buffer
        let scale = self.scale
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bytesPerPixel = self.cgImage!.bitsPerPixel/8
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer {
            destData.deallocate()
            //destData.deallocate(capacity: destHeight * destBytesPerRow)
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }
        // create a CGImage from vImage_Buffer
        var destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        guard error == kvImageNoError else { return nil }
        // create a UIImage
        let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
        destCGImage = nil
        return resizedImage
    }
}

