//
//  ExtensionColor.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 07/03/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var _red: CGFloat = 131.0
        var _green: CGFloat = 131.0
        var _blue: CGFloat = 131.0
        
        if ((cString.count) == 6) {
            
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            _red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            _green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            _blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        }
        
        self.init(red: _red, green: _green, blue: _blue, alpha: 1.0)
    }
}


extension UIColor {
    func randomColor() -> UIColor {
        let Red:CGFloat = CGFloat(arc4random_uniform(256))
        let Green:CGFloat = CGFloat(arc4random_uniform(256))
        let Blue:CGFloat = CGFloat(arc4random_uniform(256))
        let myColor = UIColor(red: Red/255, green: Green/255, blue: Blue/255, alpha: 1.0)
        return myColor
    }
}
