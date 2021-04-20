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
}
