//
//  AdhereancesResponse.swift
//  HealtheraTest
//
//  Created by Matthew Wilkinson on 15/03/2024.
//

import Foundation

struct Adhereance: Decodable {
    let id: String
    let alarmTime: Int
    let action: String
    let remedyId: String
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id", alarmTime = "alarm_time", action, remedyId = "remedy_id"
    }
}
