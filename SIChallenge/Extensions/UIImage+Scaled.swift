//
//  UIImage+Scaled.swift
//  SIChallenge
//
//  Created by Juan Cruz Ghigliani on 17/6/16.
//  Copyright © 2016 Juan Cruz Ghigliani. All rights reserved.
//

import Foundation
import UIKit
/** Scaled Extends UIImage

*/
extension UIImage {
    
    /**
     Create a new UIImage of the specified size, of the same aspect ratio of the original image. if the final image have a diferent ratio of the original image, crop the image in the center
     
     - parameter size: final image size
     
     - returns: UIImage of the specified size
     */
    func scaledToSize(size: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero;
        
        let aspectWidth:CGFloat = size.width / self.size.width;
        let aspectHeight:CGFloat = size.height / self.size.height;
        let aspectRatio:CGFloat = max(aspectWidth, aspectHeight);
        
        scaledImageRect.size.width = self.size.width * aspectRatio;
        scaledImageRect.size.height = self.size.height * aspectRatio;
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        
        self.drawInRect(scaledImageRect);
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return scaledImage
    }

}
