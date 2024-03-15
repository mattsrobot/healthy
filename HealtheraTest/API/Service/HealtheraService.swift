//
//  HealtheraService.swift
//  HealtheraTest
//
//  Created by Matthew Wilkinson on 15/03/2024.
//

import Foundation
import Combine


class HealtheraService: HealtheraServiceProtocol {
    
    func fetchAdherences() -> AnyPublisher<AdherenceResponse, Error> {
        return fetch(urlString: "https://34574e81-855b-4c10-8987-935950fdd23c.mock.pstmn.io/adherences")
    }
    
    func fetchRemedies() -> AnyPublisher<RemedyResponse, Error> {
        return fetch(urlString: "https://34574e81-855b-4c10-8987-935950fdd23c.mock.pstmn.io/remedies")
    }
    
    func fetchCombinedData() -> AnyPublisher<CombinedResponse, Error> {
        return Publishers.Zip(fetchRemedies(), fetchAdherences())
            .map({ remedyResponse, adherenceResponse in
                CombinedResponse(adherenceResponse: adherenceResponse, 
                                 remedyResponse: remedyResponse)
            })
            .eraseToAnyPublisher()
    }
    
    var urlSession: URLSession {
         return URLSession.shared
     }
    
    private func fetch<T: Decodable>(urlString: String) -> AnyPublisher<T, Error> {
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = urlSession.dataTaskPublisher(for: request)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map({ $0.data })
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        return task
    }
}



