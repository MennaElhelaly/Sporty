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
    
    var allLeaguesData :[Leagues]! {
        didSet{
            self.bindinLeaguesData()
        }
    }
    
    var leagueDetails: [LeagueDetails]!{
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
        leaguesService.allLeaguesAPI(completion: { (sportsData,error) in
               
            if let err:Error = error {
                let msg = err.localizedDescription
                self.connectionError = msg
            }else{  // testing on details view controller
                guard let data = sportsData else{
                    print("error in data")
                    self.dataError = true
                    return
                }
                self.allLeaguesData  = data
                
            }
        })
    }
    
    func getMatchedLeagues(strSport:String) -> [Leagues] {
        var matchedArray = [Leagues]()
        for iteam in allLeaguesData{
            if iteam.strSport.rawValue == strSport {
                matchedArray.append(iteam)
            }
        }
        return matchedArray
    }
    
    func fetchLeaguesUrlAndImages(matchedArray: [Leagues] ){
        leagueDetails = [LeagueDetails]()
        
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
                     self.leagueDetails.append(data[0])
                }
            }
        }
    }
}
