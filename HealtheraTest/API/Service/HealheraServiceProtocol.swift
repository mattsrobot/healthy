//
//  HealheraServiceProtocol.swift
//  HealtheraTest
//
//  Created by Matthew Wilkinson on 15/03/2024.
//

import Foundation

import Foundation
import Combine

protocol HealtheraServiceProtocol : APIClientProtocol {
    func fetchAdherences() -> AnyPublisher<AdherenceResponse, Error>
    func fetchRemedies() -> AnyPublisher<RemedyResponse, Error>
    func fetchCombinedData() -> AnyPublisher<CombinedResponse, Error>
}
