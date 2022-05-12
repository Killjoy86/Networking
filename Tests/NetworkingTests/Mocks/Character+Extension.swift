//
//  File.swift
//  
//
//  Created by Roman Syrota on 12.05.2022.
//

import Foundation
import Domain

extension Character {
    static var stub: Character {
        return .init(
            id: 1,
            name: "Walter White",
            birthday: "09-07-1958",
            occupation: [
                "High School Chemistry Teacher",
                "Meth King Pin"
            ],
            img: "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg",
            status: "Presumed dead",
            nickname: "Heisenberg",
            appearance: [1, 2, 3, 4, 5],
            portrayed: "Bryan Cranston",
            category: "Breaking Bad",
            betterCallSaulAppearance: []
        )
    }
}
