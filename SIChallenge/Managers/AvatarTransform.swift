//
//  AvatarTransform.swift
//  SIChallenge
//
//  Created by Juan Cruz Ghigliani on 18/6/16.
//  Copyright © 2016 Juan Cruz Ghigliani. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
// MARK: Imports
import Foundation
import UIKit

////////////////////////////////////////////////////////////////////////////////
// MARK: Types


/**
 *  AvatarTransform
 */
class AvatarTransform:ImageTransform {

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Properties
    var size:CGSize
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Public Properties

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: IBOutlets

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Setup & Teardown
    internal init(size:CGSize){
        self.size = size
    }

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Class Methods

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Override Methods
    
    func formated(origin:UIImage) -> UIImage{
        // First create an scaleed image to fill the final frame, keepeng the aspect ratio
        let resizedImage = origin.scaledToSize(self.size)
        
        
        // Crop the image with the format used for the avatar
        UIGraphicsBeginImageContextWithOptions(resizedImage.size, false, 0.0);
        
        let p = UIBezierPath()
        p.moveToPoint(CGPoint(x: 0, y: 0))
        p.addLineToPoint(CGPoint(x: resizedImage.size.width, y: 0))
        p.addLineToPoint(CGPoint(x: resizedImage.size.width, y: resizedImage.size.height))
        p.addLineToPoint(CGPoint(x: 0, y: resizedImage.size.height * 0.9)) // in the left side of the image, reduce the height a 10%
        p.addLineToPoint(CGPoint(x: 0, y: 0))
        
        p.addClip()
        
        resizedImage.drawAtPoint(CGPointZero)
        
        let avatar = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return avatar;
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Methods

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: public Methods


}
