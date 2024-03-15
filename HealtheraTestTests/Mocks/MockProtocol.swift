//
//  MockProtocol.swift
//  HealtheraTestTests
//
//  Created by Matthew Wilkinson on 15/03/2024.
//

import Foundation

@testable import HealtheraTest

class MockURLProtocol: URLProtocol {
    static var error: Error?
    static var requestHandlers: [URL : ((URLRequest) throws -> (HTTPURLResponse, Data))] = [:]
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let url = request.url else {
            assertionFailure("must have an url")
            return
        }
        
        guard let handler = MockURLProtocol.requestHandlers[url] else {
            assertionFailure("Received unexpected request with no handler set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // Todo
    }
}
