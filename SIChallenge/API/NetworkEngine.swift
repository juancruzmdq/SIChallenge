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
        
        let components:NSURLComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)!
        components.queryItems = qItems
        
        return components.URL
        
    }
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: public Methods
    
    /**
     Make a GET HTTP request to the specified path in the baseURL host. This call spect a JSON in the response body
     
     - parameter type:         ResponseType value
     - parameter path:         Path to the endpoint inside the baseURL
     - parameter onCompletion: Block to be executed after finish the request. send the json response as a dictionary, and the posible error
     */
    func GET(type:ResponseType, path: String, onCompletion: (AnyObject?, NSError?) -> Void) {
        self.GET(type, path:path, params: nil, onCompletion: onCompletion)
    }
    
    func GET(type:ResponseType, path: String, params:[String:AnyObject]?, onCompletion: (AnyObject?, NSError?) -> Void) {
        
        guard var endpointURL = baseURL?.URLByAppendingPathComponent(path) else {
            onCompletion(nil, NSError(domain: String(reflecting: self.dynamicType), code: 404, Description: "Invalid URL"))
            return
        }
        
        if params != nil {
            endpointURL = self.createUrlAddingQuery(endpointURL, params: params!)!
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
