//
//  Team.swift
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
 *  Team Model
 */
class Team {

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Properties

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Public Properties
    
    var id : String?
    var name : String?
    var settings : Setting?
    var players : [Player] = []

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
    
    func hidrate(fromDict:NSDictionary) -> Team {
        
        if let id = fromDict["Id"] as? String {
            self.id = id
        }
        if let name = fromDict["Name"] as? String {
            self.name = name
        }
        if let settings = fromDict["Settings"] as? NSDictionary {
            self.settings = Setting()
            self.settings?.hidrate(settings)
        }
        if let players = fromDict["Players"] as? [NSDictionary] {
            self.players.removeAll()
            for playerDic in players {
                self.players.insert(Player().hidrate(playerDic), atIndex: self.players.count)
            }
        }
        return self
    }
}
