//
//  NetworkEngine.swift
//  SIChallenge
//
//  Created by Juan Cruz Ghigliani on 18/6/16.
//  Copyright © 2016 Juan Cruz Ghigliani. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
// MARK: Imports
import Foundation

////////////////////////////////////////////////////////////////////////////////
// MARK: Types


/**
 *  NetworkEngine
 */
class NetworkEngine {

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Properties

    var baseURL:NSURL?
    let session = NSURLSession.sharedSession()

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Public Properties

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Setup & Teardown
    internal init(url:NSURL){
        baseURL = url
    }
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Class Methods

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Override Methods

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Methods

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: public Methods
    
    /**
     Make a GET HTTP request to the specified path in the baseURL host. This call spect a JSON in the response body
     
     - parameter path:         Path to the endpoint inside the baseURL
     - parameter onCompletion: Block to be executed after finish the request. send the json response as a dictionary, and the posibli error
     */
     func GET(path: String, onCompletion: (NSDictionary?, NSError?) -> Void) {
        
        guard let endpointURL = baseURL?.URLByAppendingPathComponent(path) else {
            onCompletion(nil, NSError(domain: String(reflecting: self.dynamicType), code: 404, Description: "Invalid URL"))
            return
        }
        
        let task = self.session.dataTaskWithURL(endpointURL, completionHandler: {data, response, error -> Void in
            
            if error != nil{
                onCompletion(nil, error)
            }else{
                do{
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    onCompletion(jsonResult, nil)
                }catch let e as NSError{
                    onCompletion(nil, e)
                }
            }
        })
        task.resume()
    }
}
