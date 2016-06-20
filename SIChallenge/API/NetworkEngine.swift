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

/// signature used by the block that notify the end of the request
typealias onRequestCompleteHandler = (AnyObject?, NSError?) -> Void

/**
 Enumeration used to indicate the result kind of a request
 
 - HTML: Plain HTML text
 - JSON: JSON dictionary
 */
enum ResponseType {
    case HTML
    case JSON
}

/**
 *  NetworkEngine
 */
class NetworkEngine {

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Properties

    var baseURL:NSURL?
    lazy var session:NSURLSession = { NSURLSession.sharedSession() }()

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
    
    /**
     Create a new NSURL instance coping the source url, and addinf he list of parameters of the dictionary as query string
     
     - parameter url:    source url
     - parameter params: dictionary of parametters
     
     - returns: instance of NSURL
     */
    func createUrlAddingQuery(url:NSURL, params:[String:AnyObject]) -> NSURL?{
        var qItems:[NSURLQueryItem] = []
        
        for (k, value) in params {
            if let encodedValue = String(value).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
                qItems.append(NSURLQueryItem(name: k,value: encodedValue))
            }
        }
        
        if let components:NSURLComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false) {
            components.queryItems = qItems
            return components.URL
        }else{
            return nil
        }
        
    }
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: public Methods
    
    /**
     Convenience method to call GET without parameters
     */
    func GET(type:ResponseType, path: String, onCompletion: onRequestCompleteHandler) {
        self.GET(type, path:path, params: nil, onCompletion: onCompletion)
    }
    
    /**
     Make a GET HTTP request to the specified path in the baseURL host. The parameter type spect the type of the response body
     
     - parameter type:         ResponseType value
     - parameter path:         Path to the endpoint inside the baseURL
     - parameter params:       Dictionary with a set of parameters for the call
     - parameter onCompletion: Block to be executed after finish the request. send the json response as a dictionary, and the posible error
     */
    func GET(type:ResponseType, path: String, params:[String:AnyObject]?, onCompletion: onRequestCompleteHandler) {
        
        guard var endpointURL = baseURL?.URLByAppendingPathComponent(path) else {
            onCompletion(nil, NSError(domain: String(reflecting: self.dynamicType), code: 404, Description: "Invalid URL"))
            return
        }
        
        if params != nil {
            if let url =  self.createUrlAddingQuery(endpointURL, params: params!){
                endpointURL = url
            }
        }
        
        let task = self.session.dataTaskWithURL(endpointURL, completionHandler: {data, response, error -> Void in
            
            if error != nil{
                onCompletion(nil, error)
            }else{
                if type == .HTML {
                    onCompletion(String(data: data!, encoding: NSUTF8StringEncoding), nil)
                }else{
                    do{
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        onCompletion(jsonResult, nil)
                    }catch let e as NSError{
                        onCompletion(nil, e)
                    }
                }
            }
        })
        task.resume()
    }
}
