//
//  Mapper.swift
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
 *  Mapper: This mapper class only have some fixed methods to build the objects related to this project. The best solution could be build a ORM that dinamically parse the dictionary to objects of the model. but this is a overwork for this challenge
 */
class Mapper {

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Properties

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: Public Properties

    ////////////////////////////////////////////////////////////////////////////////
    // MARK: IBOutlets

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
    
    func buildTeam(fromDict:NSDictionary) -> Team {
        let team = Team()
        if let id = fromDict["Id"] as? Int {
            team.id = id
        }
        if let name = fromDict["Name"] as? String {
            team.name = name
        }
        if let settings = fromDict["Settings"] as? NSDictionary {
            team.settings = self.buildSetting(settings)
        }
        if let players = fromDict["Players"] as? [NSDictionary] {
            team.players.removeAll()
            for playerDic in players {
                team.players.insert(self.buildPlayer(playerDic), atIndex: team.players.count)
            }
        }
        return team
    }
    
    func buildSetting(fromDict:NSDictionary) -> Setting {
        let setting = Setting()
        if let highlightColor = fromDict["HighlightColor"] as? String {
            setting.highlightColor = highlightColor
        }
        return setting
    }
    
    func buildPlayer(fromDict:NSDictionary) -> Player {
        let player = Player()
        if let id = fromDict["Id"] as? Int {
            player.id = id
        }
        if let jerseyNumber = fromDict["JerseyNumber"] as? String {
            player.jerseyNumber = jerseyNumber
        }
        if let person = fromDict["Person"] as? NSDictionary {
            player.person = self.buildPerson(person)
        }
        return player
    }

    func buildPerson(fromDict:NSDictionary) -> Person {
        let person = Person()
        if let firstName = fromDict["FirstName"] as? String {
            person.firstName = firstName
        }
        if let lastName = fromDict["LastName"] as? String {
            person.lastName = lastName
        }
        if let imageUrl = fromDict["ImageUrl"] as? String {
            person.imageUrl = imageUrl
        }
        return person
    }

}
