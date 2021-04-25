//
//  WebService.swift
//  SportsApp
//
//  Created by Amin on 20/04/2021.
//

import Foundation
import Alamofire 


class WebService {
    
    
    
    public func getUpcomingEvents(id:String,strSeason:String,round:String,completion: @escaping ([Event]?)->Void){
//        4328&r=34&s=2020-2021
        let url = "\(URLs.upcomingUrl)\(id)&r=\(round)&s=\(strSeason)"
        print("+++++++++++++++++++++++++++++++++++++\(url)")
        AF.request(url)
            .validate()
            .responseDecodable(of: Response.self) { (response) in
                switch response.result {
                
                case .success( _):
                    print("sucess")
                    guard let arrayOfUpcomings = response.value?.events else { return }
                    completion(arrayOfUpcomings)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
    }
    
    public func getAllTeamsInLeagueByLeagueId(id:String,completion: @escaping ([Team]?)->Void){
        let url = "\(URLs.allTeamsInLeague)\(id)"
        AF.request(url)
            .validate()
            .responseDecodable(of: AllTeams.self) { (response) in
                switch response.result {
                
                case .success( _):
                    print("sucess")
                    guard let arrayOfTeams = response.value?.teams else { return }
                    completion(arrayOfTeams)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
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
        AF.request(URLs.allLeaguesurl)
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
        
        let url = "\(URLs.leagueDetailsById)\(id)"
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


