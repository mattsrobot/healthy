//
//  HealtheraTestTests.swift
//  HealtheraTestTests
//
//  Created by Matthew Wilkinson on 15/03/2024.
//

import XCTest
import Combine
@testable import HealtheraTest

final class HealtheraServiceTests: XCTestCase {
    
    func testParsingGoodRemedyData() throws {
        let service = MockHealtheraService(fakeResponseRemedies: goodRemediesData,
                                           fakeResponseAdherences: goodAdherenceData)
        
        let response = try awaitPublisher(service.fetchRemedies())
        
        XCTAssert(response.data.count == 3)
    }
    
    func testParsingGoodAdherenceData() throws {
        let service = MockHealtheraService(fakeResponseRemedies: goodRemediesData, 
                                           fakeResponseAdherences: goodAdherenceData)
        
        let response = try awaitPublisher(service.fetchAdherences())
        
        XCTAssert(response.data.count == 9)
    }
    
    func testCombiningGoodAdherenceData() throws {
        let service = MockHealtheraService(fakeResponseRemedies: goodRemediesData,
                                           fakeResponseAdherences: goodAdherenceData)
        
        let response = try awaitPublisher(service.fetchCombinedData())
    
        XCTAssert(response.data.count == 9)
        
        let alarm1 = response.data[0]
        
        XCTAssert(alarm1.formattedAlarmTime == "8:15 am")
        
        XCTAssert(alarm1.description.contains("Nex foam collar filter"))
                
        let alarm2 = response.data[1]
        
        XCTAssert(alarm2.formattedAlarmTime == "2:00 pm")
        
        XCTAssert(alarm1.description.contains("Nex foam collar filter"))
    }
}
