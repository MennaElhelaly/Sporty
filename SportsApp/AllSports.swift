////
////  AllSports.swift
////  SportsApp
////
////  Created by Amin on 21/04/2021.
////  Copyright © 2021 Menna Elhelaly. All rights reserved.
////
//
//import Foundation
//
// MARK: - Welcome
struct AllSports: Codable {
    let sports: [Sport]
}

// MARK: - Sport
struct Sport: Codable {
    let idSport, strSport: String?
    let strFormat: StrFormat?
    let strSportThumb, strSportThumbGreen: String?
    let strSportDescription: String?
}

enum StrFormat: String, Codable {
    case eventSport = "EventSport"
    case teamvsTeam = "TeamvsTeam"
}
