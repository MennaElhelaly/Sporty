//
//  URLs.swift
//  SportsApp
//
//  Created by Amin on 21/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import Foundation

struct URLs {
    
    static let allSports =  "https://www.thesportsdb.com/api/v1/json/1/all_sports.php" // -> strSport
    
    static let allLeagues = "https://www.thesportsdb.com/api/v1/json/1/all_leagues.php" // filter with strSport , -> idLeague
    static let leagueDetailsById = "https://www.thesportsdb.com/api/v1/json/1/lookupleague.php?id=" // to get image -> strCurrentSeason

    static let allTeamsInLeague =  "https://www.thesportsdb.com/api/v1/json/1/lookup_all_teams.php?id="
    static let eventUrl       = "https://www.thesportsdb.com/api/v1/json/1/eventspastleague.php?id="
//    static let upcomingEvents = "https://www.thesportsdb.com/api/v1/json/1/eventsseason.php?id=" // leagueID & strCurrentSeason
    
    
}
