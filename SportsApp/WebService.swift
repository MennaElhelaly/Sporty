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
    
    private let eventUrl = "https://www.thesportsdb.com/api/v1/json/1/eventspastleague.php?id="
    private let teamsUrl = "https://www.thesportsdb.com/api/v1/json/1/lookupteam.php?id="
    private let allLeaguesurl = "https://www.thesportsdb.com/api/v1/json/1/all_leagues.php"
    private let leagueDetailsById = "https://www.thesportsdb.com/api/v1/json/1/lookupleague.php?id="
    
    
    
    
    func getEventInLeagueById(leagueId:String,compilation: @escaping (JSON)->Void) {
        apiCall(id: leagueId, url: eventUrl,compilation: compilation)
    }
    
    func getTeamDetailsById(teamId:String,compilation: @escaping (JSON) -> Void) {
        apiCall(id: teamId, url: teamsUrl, compilation: compilation)
    }
    
    

    private func apiCall(id:String,url:String,compilation: @escaping (JSON)->Void) {
        let url = "\(url)\(id)"
        print(url)
        AF.request(url).responseJSON { (response) in
            switch response.result{

            case .failure(let error):
                    print(error)
                    // alert
            case .success(let value):
                let json = JSON(value)
                print(json["events"])
                compilation(json)
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
