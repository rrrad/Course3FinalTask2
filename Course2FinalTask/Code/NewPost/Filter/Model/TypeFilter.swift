//
//  TypeFilter.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 24/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

enum typeFilter: String, CaseIterable{
    case noir = "CIPhotoEffectNoir"
    case sepia = "CISepiaTone"
    case comic = "CIComicEffect"
    case blur = "CIGaussianBlur"
    case clamp = "CIColorClamp"
    case transfer = "CIPhotoEffectTransfer"
    case chrome = "CIPhotoEffectChrome"
    case tonal = "CIPhotoEffectTonal"
    //case cube = "CIColorCube"
}
