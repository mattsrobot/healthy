//
//  CombinedResponse.swift
//  HealtheraTest
//
//  Created by Matthew Wilkinson on 15/03/2024.
//

import Foundation

struct CombinedResponse: Decodable {
    let data: [Alarm]
    
    init(adherenceResponse: AdherenceResponse, remedyResponse: RemedyResponse) {
                
        let remedies = Dictionary(uniqueKeysWithValues: Dictionary(grouping: remedyResponse.data, by: { $0.remedyId }).map { ($0, $1.first!) } )
        
        var alarms: [Alarm] = []
        
        for adherence in adherenceResponse.data {
            if let remedy = remedies[adherence.remedyId] {
                let alarm = Alarm(adherence: adherence,
                                  remedy: remedy)
                alarms.append(alarm)
            }
        }
        
        self.data = alarms
    }
}
