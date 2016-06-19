//
//  UIColor+hex.swift
//  SIChallenge
//
//  Created by Juan Cruz Ghigliani on 16/6/16.
//  Copyright © 2016 Juan Cruz Ghigliani. All rights reserved.
//

import Foundation
import UIKit

/** hex Extends UIColor

*/
extension UIColor {
    /**
     Create UIColor instance with a string that represent the Hexadecimal values of Red, Green, Blue, Alpha values of the color
     Example of posibles hexString values:
     UIColor(hexString:"#00FF00FF") => Green color with out transparence
     UIColor(hexString:"00FF00FF") => Simbol '#' is not required
     UIColor(hexString:"00FF00") => Green color , since there are no alpha value, by default the color result don't have transparence

     - parameter hexString: String that represent the hexadecimal value of the color
     
     - returns: UIColor instance
     */
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        var start:String.CharacterView.Index
        var finalHexColor = hexString
        
        if hexString.hasPrefix("#") {
            start = hexString.startIndex.advancedBy(1)
        }else{
            start = hexString.startIndex
        }
        
        let hexColor = hexString.substringFromIndex(start)
        
        if hexColor.characters.count == 6 {
            finalHexColor = hexColor+"FF"
        }
        
        let scanner = NSScanner(string: finalHexColor)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexLongLong(&hexNumber) {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
            
            self.init(red: r, green: g, blue: b, alpha: a)
            return
        }
        
        
        return nil
    }
}
