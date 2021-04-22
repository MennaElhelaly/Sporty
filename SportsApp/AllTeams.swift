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
    let idTeam, strTeam, strTeamShort, strAlternate: String
    let intFormedYear, strSport, strLeague, idLeague: String
    let strStadium, strKeywords: String
    let strRSS: String
    let strStadiumThumb: String
    let strStadiumLocation, intStadiumCapacity, strWebsite, strFacebook: String
    let strTwitter, strInstagram, strDescriptionEN, strCountry: String
    let strTeamBadge, strTeamJersey, strTeamLogo: String
    let strTeamFanart1, strTeamFanart2, strTeamFanart3, strTeamFanart4: String
    let strTeamBanner: String
    let strYoutube: String

//    init(idTeam: String, strTeam: String, strTeamShort: String, strAlternate: String, intFormedYear: String, strSport: String, strLeague: String, idLeague: String, strStadium: String, strKeywords: String, strRSS: String, strStadiumThumb: String, strStadiumLocation: String, intStadiumCapacity: String, strWebsite: String, strFacebook: String, strTwitter: String, strInstagram: String, strDescriptionEN: String, strCountry: String, strTeamBadge: String, strTeamJersey: String, strTeamLogo: String, strTeamFanart1: String, strTeamFanart2: String, strTeamFanart3: String, strTeamFanart4: String, strTeamBanner: String, strYoutube: String) {
//        self.idTeam = idTeam
//        self.strTeam = strTeam
//        self.strTeamShort = strTeamShort
//        self.strAlternate = strAlternate
//        self.intFormedYear = intFormedYear
//        self.strSport = strSport
//        self.strLeague = strLeague
//        self.idLeague = idLeague
//        self.strStadium = strStadium
//        self.strKeywords = strKeywords
//        self.strRSS = strRSS
//        self.strStadiumThumb = strStadiumThumb
//        self.strStadiumLocation = strStadiumLocation
//        self.intStadiumCapacity = intStadiumCapacity
//        self.strWebsite = strWebsite
//        self.strFacebook = strFacebook
//        self.strTwitter = strTwitter
//        self.strInstagram = strInstagram
//        self.strDescriptionEN = strDescriptionEN
//        self.strCountry = strCountry
//        self.strTeamBadge = strTeamBadge
//        self.strTeamJersey = strTeamJersey
//        self.strTeamLogo = strTeamLogo
//        self.strTeamFanart1 = strTeamFanart1
//        self.strTeamFanart2 = strTeamFanart2
//        self.strTeamFanart3 = strTeamFanart3
//        self.strTeamFanart4 = strTeamFanart4
//        self.strTeamBanner = strTeamBanner
//        self.strYoutube = strYoutube
//    }
}
