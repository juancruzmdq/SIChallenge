//
//  ImageManager.swift
//  SIChallenge
//
//  Created by Juan Cruz Ghigliani on 16/6/16.
//  Copyright © 2016 Juan Cruz Ghigliani. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
// MARK: Imports
import Foundation
import UIKit

////////////////////////////////////////////////////////////////////////////////
// MARK: Types
public enum CacheType {
    case None
    case Cache
}

protocol ImageTransform {
    func formated(origin:UIImage) -> UIImage
}

/**
 *  Class in charge of handle Image transformation and Image cache for the proyect SIChallenge
 */
class ImageManager {

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Class default
    
    class var defaultManager: ImageManager {
        struct Static {
            static let instance = ImageManager()
        }
        return Static.instance
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Properties

    /// in memory cache of images
    private let cache: NSCache = NSCache()
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Public Properties

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Setup & Teardown

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Class Methods

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Override Methods

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Methods

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: public Methods
    
    /**
     Remove all cached images from memory
     */
    func cleanCache(){
        self.cache.removeAllObjects()
    }
    
    /**
     Download the image from a URL, apply the avatar format, store it in cache, and call the complete block with the final image. If the image exist in cache, call the complete block with the cached UIImage. In the case that need download the image, this method return a reference to the Download task
     
     - parameter url:        URL source of the image
     - parameter size:       Final size of the image
     - parameter onComplete: block to be calles when when finish all image recovery process
     
     - returns: Download task reference
     */
    func getAvatarFrom(url:NSURL, transform:ImageTransform?, onComplete:((CacheType,UIImage?,NSError?) -> Void)?) -> NSURLSessionDataTask? {

        var task:NSURLSessionDataTask? = nil
        if self.cache.objectForKey(url.absoluteString) != nil {
            onComplete!(.Cache, self.cache.objectForKey(url.absoluteString) as? UIImage, nil)
        }else{
            
            task = NSURLSession.sharedSession().dataTaskWithURL(url){[weak self] (data, response, error) in
                var image:UIImage? = nil
                if error == nil {
                    image = UIImage(data: data!)
                    if image != nil {
                        if transform != nil {
                            image = transform!.formated(image!)
                        }
                        self?.cache.setObject(image!, forKey: url.absoluteString)
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    onComplete!(.None,image,error)
                })
                }
            task?.resume()
        }
        return task
    }
}
