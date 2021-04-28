//
//  LeagueDetailsViewModel.swift
//  SportsApp
//
//  Created by Amin on 28/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import Foundation

class LeagueDetailsViewModel: NSObject {
    
    var leagueDetailsService: WebService!
    
    var allTeamsData:[Team]!{
        didSet{
            self.bindingAllTeams()
        }
    }
    
    var latestEvents:[Event]!{
        didSet{
            self.bindingLatestEvents()
        }
    }
    
    var upcomingEvents:[Event]?{
        didSet{
            self.bindingUpcomingEvents()
        }
    }
    
    var connectionError:String! {
        didSet{
            self.bindingConnectionError()
        }
    }
    
    var dataError:Bool!{
        didSet{
            self.bindingDataError()
        }
    }
    
    var upcomingState:Bool!{
        didSet{
            self.bindingUpcomingState()
        }
    }
    var upcomingConnection:String!{
        didSet{
            self.bindingUpcomingConnection()
        }
    }
    
    
    var bindingAllTeams: (()->()) = {}
    var bindingLatestEvents : (()->()) = {}
    var bindingUpcomingEvents: (()->()) = {}
    
    var bindingConnectionError : (()->()) = {}
    var bindingDataError : (()->()) = {}
    var bindingUpcomingState: (()->()) = {}
    var bindingUpcomingConnection: (()->()) = {}
    
    override init() {
        super.init()
        leagueDetailsService = WebService()
    }
    
    func getAllTeams(leagueId:String) {
        leagueDetailsService.getAllTeamsInLeagueByLeagueId(id: leagueId) { (arrayOfAllTeams,error) in
 
            if let err = error {
                let msg = err.localizedDescription
                self.connectionError = msg
            }else{
                guard let data = arrayOfAllTeams else {
                    print("error in data")
                    if Network.shared.isConnected{
                        self.dataError = true // marquee
                    }else{
                        self.dataError = false // connection error "no internet"
                    }
                    
                    return
                }
                self.allTeamsData = data
            }
        }
    }
    
    func getLatestEvents(leagueId: String) {
        leagueDetailsService.getLatestInLeagueById(id:leagueId) { (arrayOfEvents,error) in // load previous events (tableview)
            
            if let err = error {
                let msg = err.localizedDescription
                self.connectionError = msg
            }else{
                
            }
            guard let validArrayOfEvents = arrayOfEvents else {
                if Network.shared.isConnected{
                    print("response issue , but not inernet latest events")
                    self.dataError = true
                }else{
                    self.dataError = false
                }

                return
            }
            self.latestEvents = validArrayOfEvents
        }
    }
    
    func getUpcomingEvents(leagueId:String,strSeason:String,round:String)  {
        leagueDetailsService.getUpcomingEvents(id: leagueId, strSeason: strSeason, round: round) { (arrayOfEvents, error) in
            if let err = error{
                let msg = err.localizedDescription
                self.upcomingConnection = msg
                print("errrrr")
            }else{
                print("sssss")
                guard let validArrayOfEvents = arrayOfEvents else {
                    print("nil")
                    if Network.shared.isConnected{
                        print("response issue , but not inernet latest events")
//                        self.dataError = true
                        self.upcomingState = true
                    }else{
                        self.upcomingState = false
                    }

                    return
                }
                print(validArrayOfEvents.count)
                print("addddd")
                
                
                let arr = self.getValidEvents(array: validArrayOfEvents)
                
                guard let valid = arr else {
                    self.upcomingState = true
                    return
                }
                
                self.upcomingEvents = valid
//                self.upcomingEvents = validArrayOfEvents
            }
        }
        
    }
    private func getValidEvents(array:[Event])->[Event]? {
        var matchedArray:[Event]? = [Event]()
        for item in array {
            if let _ = item.intHomeScore{
                
            }else{
                matchedArray?.append(item)
            }
        }
        
        if matchedArray!.count > 0 {
            return matchedArray
        }else{
            return nil
        }
        
    }
}
