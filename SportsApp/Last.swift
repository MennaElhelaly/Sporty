////
////  Events.swift
////  SportsApp
////
////  Created by Amin on 21/04/2021.
////  Copyright © 2021 Menna Elhelaly. All rights reserved.
////
//
import Foundation


// MARK: - Welcome
struct Response: Codable {
    let events: [Event]
}

// MARK: - Event
struct Event: Codable {
    let idEvent: String
    let idLeague: String
    let strHomeTeam, strAwayTeam: String
    let intHomeScore:String?
    let intAwayScore:String?
    let dateEvent: String
    let idHomeTeam, idAwayTeam: String
    let strSeason:String
    let intRound:String
}
