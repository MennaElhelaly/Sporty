//
//  LeaguesDataClass.swift
//  SportsApp
//
//  Created by Ayman Omara on 21/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct apiCallData: Codable {
    let leagues: [Leagues]?
}

// MARK: - League
struct Leagues: Codable {
    
    let idLeague, strLeague: String?
    let strSport: String?
//    let strLeagueAlternate: String?
}
