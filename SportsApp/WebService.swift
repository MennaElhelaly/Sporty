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
       
    
    func getEventInLeagueById(leagueId:String,compilation: @escaping ([Event])->Void) {
        apiCall(id: leagueId,compilation: compilation)
    }
    
    func getTeamDetailsById(teamId:String,compilation: @escaping ([Event]) -> Void) {
//        apiCall(id: teamId, url: URLs.teamsUrl, compilation: compilation)
    }
    
//    func getAllTeamsByLeagueID(leagueId:String,compilation: @escaping []) -> <#return type#> {
//        <#function body#>
//    }
    
    
    
    
    
    private func apiCall(id:String,compilation: @escaping ([Event])->Void) {
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
                    compilation([])
                }
            }
    }


//    private func apiCall(id:String,url:String,compilation: @escaping (JSON)->Void) {
//        let url = "\(url)\(id)"
//        print(url)
//        AF.request(url).responseJSON { (response) in
//            switch response.result{
//
//            case .failure(let error):
//                    print(error)
//                    // alert
//            case .success(let value):
//                let json = JSON(value)
//                print(json)
//                compilation(json)
//            }
//        }
//
//    }
}


