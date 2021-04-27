//
//  LeaguesViewModel.swift
//  SportsApp
//
//  Created by Amin on 27/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import Foundation

class LeaguesViewModel: NSObject {
    
    var leaguesService :WebService!
    
    var allLeaguesData :[LeaguesDataClass]! {
        didSet{
            self.bindinLeaguesData()
        }
    }
    
    var leagueDetails: [LeagueById]!{
        didSet{
            self.bindingLeagueDetails()
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
    
    
    var bindinLeaguesData: (()->()) = {}
    var bindingLeagueDetails: (()->()) = {}
    var bindingConnectionError : (()->()) = {}
    var bindingDataError : (()->()) = {}
    
    override init() {
        super .init()
        leaguesService = WebService()
    }
    
    func fetchAllLeagues() {
        leaguesService.allLeaguesAPI(compilation: { (sportsData,error) in
               
            if let err:Error = error {
                let msg = err.localizedDescription
                self.connectionError = msg
            }else{  // testing on details view controller
                guard let data = sportsData else{
                    print("error in data")
                    self.dataError = true
                    return
                }
                print("data is not null \(data)")
                self.allLeaguesData  = data
                
            }
        })
    }
    
    func getMatchedLeagues(strSport:String) -> [LeaguesDataClass] {
        var matchedArray = [LeaguesDataClass]()
        for iteam in allLeaguesData{
            if iteam.strSport.rawValue == strSport {
                matchedArray.append(iteam)
                print("if")
            }
        }
        return matchedArray
    }
    
    func fetchLeaguesUrlAndImages(matchedArray: [LeaguesDataClass] ){
        leagueDetails = [LeagueById]()
        
        for i in matchedArray{
            leaguesService.lookUpLeagueById(id: i.idLeague) { (LeagueById,error) in
             if let err:Error = error {
                 let msg = err.localizedDescription
                 self.connectionError = msg
             }else{  // testing on details view controller
                 guard let data = LeagueById else{
                     print("error in data")
                     self.dataError = true
                     return
                 }
                 print("data is not null \(data)")
                 self.leagueDetails.append(data[0])
             }
            }
        }
    }
}
