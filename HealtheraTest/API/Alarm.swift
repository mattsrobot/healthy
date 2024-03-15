//
//  Alarm.swift
//  HealtheraTest
//
//  Created by Matthew Wilkinson on 15/03/2024.
//

import Foundation

struct Alarm: Decodable {
    let adherence: Adhereance
    let remedy: Remedy
    
    var formattedAlarmTime: String {
        formatTimestamp(timestamp: adherence.alarmTime)
    }
    
    var description: String {
        """
            \(adherence.alarmTime) \(formattedAlarmTime)
            - medicine_name: \(remedy.medicineName)
            - instruction: \(remedy.instruction)
        """
    }
}


extension Alarm {
    
    fileprivate func formatTimestamp(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}
