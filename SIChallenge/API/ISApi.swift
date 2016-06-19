//
//  ISApi.swift
//  SIChallenge
//
//  Created by Juan Cruz Ghigliani on 15/6/16.
//  Copyright © 2016 Juan Cruz Ghigliani. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
// MARK: Imports
import Foundation

////////////////////////////////////////////////////////////////////////////////
// MARK: Types


/**
 *  ISApi
 */
class ISApi {

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Class default
    
    class var defaultInstance: ISApi {
        struct Static {
            static let instance = ISApi()
        }
        return Static.instance
    }

    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Properties
    
    let engine:NetworkEngine = NetworkEngine(url:NSURL(fileURLWithPath: "http://iscoresports.com/"))

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
     MAke a call to get a Team profile
     
     - parameter onCompletion: block with the Team Object, or an error instance
     */
    func getTeam(onCompletion: (Team?, NSError?) -> Void) {
        engine.GET("bcl/challenge/team.json", onCompletion: { dict, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    onCompletion(nil, error)
                })
            }else{
                var team:Team? = nil
                if dict != nil {
                    team = Team().hidrate(dict!)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    onCompletion(team,error)
                })
            }
        })
    }
    
    
    
}
