//
//  LookUpLeague.swift
//  SportsApp
//
//  Created by Ayman Omara on 23/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import Foundation
struct LookUpLeague: Codable {
    let leagues: [LeagueById]
}
struct LeagueById: Codable {
    let idLeague:String
    let strSport:String
    let strLeague:String
    let strYoutube:String
    let strBadge: String?
}
