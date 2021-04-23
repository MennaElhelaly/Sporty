//
//  AllTeams.swift
//  SportsApp
//
//  Created by Amin on 21/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct AllTeams: Codable {
    let teams: [Team]

//    init(teams: [Team]) {
//        self.teams = teams
//    }
}

// MARK: - Team
struct Team: Codable {
    let idTeam, strTeam, strTeamBadge: String
//    let intFormedYear, strSport, strLeague, idLeague: String
//    let strStadium, strKeywords: String
//    let strRSS: String
//    let strStadiumThumb: String
//    let strStadiumLocation, intStadiumCapacity, strWebsite, strFacebook: String
//    let strTwitter, strInstagram, strDescriptionEN, strCountry: String
//    let strTeamBadge, strTeamJersey, strTeamLogo: String
//    let strTeamFanart1, strTeamFanart2, strTeamFanart3, strTeamFanart4: String
//    let strTeamBanner: String
    let strYoutube: String

}
