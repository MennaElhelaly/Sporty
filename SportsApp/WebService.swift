//
//  WebService.swift
//  SportsApp
//
//  Created by Amin on 20/04/2021.
//

import Foundation
import Alamofire
import SwiftyJSON



class WebService {
    
    private let allLeaguesurl = "https://www.thesportsdb.com/api/v1/json/1/all_leagues.php"
    private let leagueDetailsById = "https://www.thesportsdb.com/api/v1/json/1/lookupleague.php?id="
    
    
//
//    public func getUpcoming(bySeason:String,id:String,compilation: @escaping ([NewEvent])->Void){
//        let url = "\(URLs.upcomingEvents)\(id)&s=\(bySeason)"
//        AF.request(url)
//        .validate()
//        .responseDecodable(of: Upcoming.self) { (response) in
//            switch response.result {
//            
//            case .success( _):
//                print("sucess")
//                guard let arrayOfTeams = response.value?.events else { return }
//                compilation(arrayOfTeams)
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//                compilation([])
//            }
//        }
//    }
    
    public func getAllTeamsInLeagueByLeagueId(id:String,compilation: @escaping ([Team]?)->Void){
        let url = "\(URLs.allTeamsInLeague)\(id)"
        AF.request(url)
        .validate()
        .responseDecodable(of: AllTeams.self) { (response) in
            switch response.result {
            
            case .success( _):
                print("sucess")
                guard let arrayOfTeams = response.value?.teams else { return }
                compilation(arrayOfTeams)
                
            case .failure(let error):
                print(error.localizedDescription)
                compilation(nil)
            }
        }
    }
    public func getLatestInLeagueById(id:String,compilation: @escaping ([Event]?)->Void) {
        let url = "\(URLs.eventUrl)\(id)"
        AF.request(url)
        .validate()
        .responseDecodable(of: Response.self) { (response) in
            switch response.result {
            
            case .success( _):
                print("sucess")
                guard let arrayOfEvents = response.value?.events else { return }
                compilation(arrayOfEvents)
                
            case .failure(let error):
                print(error.localizedDescription)
                compilation(nil)
            }
        }
    }
    public func callSportsAPI(compilation: @escaping ([Sport]?)->Void) {
        AF.request(URLs.allSports)
        .validate()
        .responseDecodable(of: AllSports.self) { (response) in
            switch response.result {
            
            case .success( _):
                print("sucess")
                guard let arrayOfSports = response.value?.sports else { return }
                compilation(arrayOfSports)
                
            case .failure(let error):
                print(error.localizedDescription)
                compilation(nil)
            }
        }
    }
    
    
    
    public func allLeaguesAPI(compilation: @escaping ([LeaguesDataClass])->Void) {
            AF.request(allLeaguesurl)
                .validate()
                .responseDecodable(of: apiCallData.self) { (response) in
                    switch response.result {
                    
                    case .success( _):
                        print("sucess")
                        guard let arrayOfSports = response.value?.leagues else { return }
                        compilation(arrayOfSports)
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        compilation([])
                    }
                }
        }
    
    
    public func lookUpLeagueById(id:String,compilation: @escaping ([LeagueById])->Void) {
            
        let url = "\(leagueDetailsById)\(id)"
        AF.request(url)
                .validate()
                .responseDecodable(of: LookUpLeague.self) { (response) in
                    switch response.result {
                    
                    case .success( _):
                        print("sucess")
                        guard let arrayOfSports = response.value?.leagues else { return }
                        compilation(arrayOfSports)
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        compilation([])
                    }
                }
        }
}


