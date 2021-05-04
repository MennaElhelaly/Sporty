//
//  WebService.swift
//  SportsApp
//
//  Created by Amin on 20/04/2021.
//

import Foundation
import Alamofire 



class WebService {
    
    
    
    public func getUpcomingEvents(id:String,strSeason:String,round:String,completion: @escaping ([Event]?,Error?)->Void){
        let url = "\(URLs.upcomingUrl)\(id)&r=\(round)&s=\(strSeason)"
        AF.request(url)
            .validate()
            .responseDecodable(of: Response.self) { (response) in
                switch response.result {
                
                case .success( _):
                    completion(response.value?.events,nil)
                    
                case .failure(let error):
                   // print(error.localizedDescription)
                    completion(nil,error)
                }
            }
    }
    
    public func getAllTeamsInLeagueByLeagueId(id:String,completion: @escaping ([Team]?,Error?)->Void){
        let url = "\(URLs.allTeamsInLeague)\(id)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: AllTeams.self) { (response) in
                switch response.result {
                
                case .success( _):
                    guard let arrayOfTeams = response.value?.teams else { return }
                    completion(arrayOfTeams,nil)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil,error)
                }
            }
    }
    public func getLatestInLeagueById(id:String,compilation: @escaping ([Event]?,Error?)->Void) {
        let url = "\(URLs.eventUrl)\(id)"
        AF.request(url)
            .validate()
            .responseDecodable(of: Response.self) { (response) in
                switch response.result {
                
                case .success( _):
                    guard let arrayOfEvents = response.value?.events else { return }
                    compilation(arrayOfEvents,nil)
                    
                case .failure(let error):
//                    print(error.localizedDescription)
                    compilation(nil,error)
                }
            }
    }
    public func callSportsAPI(compilation: @escaping ([Sport]? , Error?)->Void) {
        
        AF.request(URLs.allSports)
            .validate()
            .responseDecodable(of: AllSports.self) { (response) in
                switch response.result {
                
                case .success( _):
                    guard let arrayOfSports = response.value?.sports else { return }
                    compilation(arrayOfSports,nil)
                    
                case .failure(let error):
//                    print(error.localizedDescription)
                    compilation(nil,error)
                }
            }
    }
    
    
    
    public func allLeaguesAPI(completion: @escaping ([Leagues]? , Error?)->Void) {
        
        AF.request(URLs.allLeaguesurl)
            .validate()
            .responseDecodable(of: apiCallData.self) { (response) in
                switch response.result {
                
                case .success( _):
                    guard let arrayOfSports = response.value?.leagues else { return }
                    completion(arrayOfSports,nil)
                    
                case .failure(let error):
//                    print(error.localizedDescription)
                    completion(nil,error)
                }
            }
    }
    
    public func lookUpLeagueById(id:String,compilation: @escaping ([LeagueDetails]? , Error?)->Void) {
        let url = "\(URLs.leagueDetailsById)\(id)"
        AF.request(url)
            .validate()
            .responseDecodable(of: LookUpLeague.self) { (response) in
                switch response.result {
                
                case .success( _):
                    guard let arrayOfSports = response.value?.leagues else { return }
                    compilation(arrayOfSports,nil)
                    
                case .failure(let error):
//                    print(error.localizedDescription)
                    compilation(nil,error)
                }
            }
    }
}


