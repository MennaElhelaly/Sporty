//
//  LeaguesDataClass.swift
//  SportsApp
//
//  Created by Ayman Omara on 21/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import Foundation
//struct Response: Codable {
//    let leaguesDataClassArray:[LeaguesDataClass];
//}

//struct LeaguesDataClass: Codable {
//
//    //var strBadge:String?
//    let idLeague:String
//    let strLeague:String
//    let strSport:String
//    //var strLeagueAlternate:String
//
//}
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct apiCallData: Codable {
    let leagues: [LeaguesDataClass]
}

// MARK: - League
struct LeaguesDataClass: Codable {
    
    let idLeague, strLeague: String
    let strSport: StrSport
//    let strLeagueAlternate: String?
}

enum StrSport: String, Codable {
    case americanFootball = "American Football"
    case australianFootball = "Australian Football"
    case baseball = "Baseball"
    case basketball = "Basketball"
    case cricket = "Cricket"
    case cycling = "Cycling"
    case darts = "Darts"
    case eSports = "ESports"
    case esports = "Esports"
    case fieldHockey = "Field Hockey"
    case fighting = "Fighting"
    case golf = "Golf"
    case handball = "Handball"
    case iceHockey = "Ice Hockey"
    case motorsport = "Motorsport"
    case motorsports = "Motorsports"
    case netball = "Netball"
    case rugby = "Rugby"
    case snooker = "Snooker"
    case soccer = "Soccer"
    case tennis = "Tennis"
    case volleyball = "Volleyball"
}
