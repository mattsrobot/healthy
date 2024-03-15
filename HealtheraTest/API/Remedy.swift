//
//  RemediesResponse.swift
//  HealtheraTest
//
//  Created by Matthew Wilkinson on 15/03/2024.
//

import Foundation

struct Remedy: Decodable {
    let id: String
    let remedyId: String
    let instruction: String
    let medicineName: String
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id", remedyId = "remedy_id", instruction, medicineName = "medicine_name"
    }
}
