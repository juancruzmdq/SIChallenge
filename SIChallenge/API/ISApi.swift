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
    
    lazy var engine:NetworkEngine = { NetworkEngine(url:NSURL(fileURLWithPath: "http://iscoresports.com/")) }()

    lazy var mapper:Mapper = { Mapper() }()

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
     Make a call to get a Team profile
     
     - parameter onCompletion: block with the Team Object, or an error instance
     */
    func getTeam(onCompletion: (Team?, NSError?) -> Void) {
        engine.GET(.JSON,path:"bcl/challenge/team.json", onCompletion: { dict, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    onCompletion(nil, error)
                })
            }else{
                var team:Team? = nil
                if dict != nil {
                    team = self.mapper.buildTeam((dict! as! NSDictionary))
                }
                dispatch_async(dispatch_get_main_queue(), {
                    onCompletion(team,error)
                })
            }
        })
    }
    
    
    func tapped(teamid:Int?, playerid:Int?, playerFirstName:String?, playerLastName:String?, onCompletion: (NSError?) -> Void) {
        var params:[String:AnyObject] = [:]
        if teamid != nil {
            params["teamid"] = teamid!
        }
        if playerid != nil {
            params["playerid"] = playerid!
        }
        if playerFirstName != nil {
            params["playerFirstName"] = playerFirstName!
        }
        if playerLastName != nil {
            params["playerLastName"] = playerLastName!
        }
        
        engine.GET(.HTML,path:"bcl/challenge/tapped.php", params:params, onCompletion: { string, error in
            dispatch_async(dispatch_get_main_queue(), {
                if error != nil{
                    onCompletion(error)
                }else{
                    if let str = string as? String  {
                        if str == "OK" {
                            onCompletion(nil)
                        }else{
                            onCompletion(NSError(domain: String(reflecting: self.dynamicType), code: 1, Description: str))
                        }
                    }else{
                        onCompletion(NSError(domain: String(reflecting: self.dynamicType), code: 1, Description:  "Undefined Error" ))
                    }
                }
            })

        })

    }
    
    
}
