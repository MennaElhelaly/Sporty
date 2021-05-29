//
//  LeaguesViewModel.swift
//  SportsApp
//
//  Created by Amin on 27/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import Foundation
import UIKit

class LeaguesViewModel: NSObject {
    
    var leaguesService :WebService!
    
    var allLeaguesData :[Leagues]! {
        didSet{
            self.bindinLeaguesData()
        }
    }
    
    var matchedLeagues: [Leagues]!{
        didSet{
            self.bindingMatchedLeagues()
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
    var bindingMatchedLeagues: (()->()) = {}
    
    override init() {
        super .init()
        leaguesService = WebService()
        matchedLeagues = []
    }
    
    func fetchAllLeagues() {
        leaguesService.allLeaguesAPI(completion: { (sportsData,error) in
               
            if let err:Error = error {
                let msg = err.localizedDescription
                self.connectionError = msg
            }else{  // testing on details view controller
                guard let data = sportsData else{
                    self.dataError = true
                    return
                }
                self.allLeaguesData  = data
                
            }
        })
    }
    
    func getMatchedLeagues(strSport:String){
        var matchedArray = [Leagues]()
        for iteam in allLeaguesData{
            if iteam.strSport == strSport {
                matchedArray.append(iteam)
            }
        }
        matchedLeagues = matchedArray
    }
    
    func fetchLeagueDetails(matchedArray: [Leagues] ){
        leagueDetails = [LeagueDetails]()
        
        for i in matchedArray{
            leaguesService.lookUpLeagueById(id: i.idLeague) { (LeagueById,error) in
             if let err:Error = error {
                 let msg = err.localizedDescription
                 self.connectionError = msg
             }else{  // testing on details view controller
                     guard let data = LeagueById else{
                         self.dataError = true
                         return
                     }
                     self.leagueDetails.append(data[0])
                }
            }
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        return (Network.shared.isConnected) ? true : false
    }
    
    func isSearchTextEmpty(text:String) -> Bool {
        if text.isEmpty{
            return true
        }else{
            return false
        }
    }
    
    func searchForLeagueDetails(withId id: String,onFound: (LeagueDetails)->Void ){
        for item in leagueDetails {
            if item.idLeague == id{
                onFound(item)
                break
            }
        }
    }
    func openYoutube(url:String){
        let application = UIApplication.shared
        if application.canOpenURL(URL(string: url)!) {
            application.open(URL(string: url)!)
        }else {
            // if Youtube app is not installed, open URL inside Safari
            application.open(URL(string: "https://\(url)")!)
        }
    }
}
