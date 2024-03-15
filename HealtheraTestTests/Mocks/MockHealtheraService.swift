//
//  MockHealtheraService.swift
//  HealtheraTestTests
//
//  Created by Matthew Wilkinson on 15/03/2024.
//

@testable import HealtheraTest

import Foundation
import Combine

class MockHealtheraService : HealtheraServiceProtocol {
    
    private var fakeResponseRemedies: String!
    private var fakeResponseAdherences: String!

    var urlSession: URLSession {
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
    
    init(fakeResponseRemedies: String, fakeResponseAdherences: String) {
        self.fakeResponseRemedies = fakeResponseRemedies
        self.fakeResponseAdherences = fakeResponseAdherences
    }
    
    func fetchData<T: Decodable>(fakeData: String, urlString: String) -> AnyPublisher<T, Error> {
        let data = fakeData.data(using: .utf8)!
        
        MockURLProtocol.error = nil
        
        MockURLProtocol.requestHandlers[URL(string: urlString)!] = { request in
            let response = HTTPURLResponse(url: URL(string: urlString)!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }
        
        let url = URL(string: urlString)!
        
        return urlSession.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map({ $0.data })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchRemedies() -> AnyPublisher<RemedyResponse, Error> {
        return fetchData(fakeData: fakeResponseRemedies, 
                         urlString: "https://34574e81-855b-4c10-8987-935950fdd23c.mock.pstmn.io/remedies")
    }
    
    func fetchAdherences() -> AnyPublisher<AdherenceResponse, Error> {
        return fetchData(fakeData: fakeResponseAdherences, 
                         urlString: "https://34574e81-855b-4c10-8987-935950fdd23c.mock.pstmn.io/adherences")
    }
    
    func fetchCombinedData() -> AnyPublisher<CombinedResponse, Error> {
        return Publishers.Zip(fetchRemedies(), fetchAdherences())
            .map({ remedyResponse, adherenceResponse in
                CombinedResponse(adherenceResponse: adherenceResponse, 
                                 remedyResponse: remedyResponse)
            })
            .eraseToAnyPublisher()
    }
}
