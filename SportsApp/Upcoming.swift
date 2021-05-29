//
//  Upcoming.swift
//  SportsApp
//
//  Created by Amin on 22/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import Foundation
// MARK: - Upcoming
class Upcoming: Codable {
    let events: [NewEvent]

    init(events: [NewEvent]) {
        self.events = events
    }
}

// MARK: - Event
class NewEvent: Codable {
    let strEvent, strHomeTeam, strAwayTeam, dateEvent: String
    let dateEventLocal, strVenue, strCountry: String
    let idAwayTeam , idHomeTeam :String
}
