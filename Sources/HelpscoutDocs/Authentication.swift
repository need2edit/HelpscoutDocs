//
//  Authentication.swift
//  Alamofire
//
//  Created by Jake Young on 10/4/18.
//

import Foundation
import Alamofire

class HelpscoutHeadersAdapter: RequestAdapter {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        var headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        if let authorizationHeader = Request.authorizationHeader(user: apiKey, password: "X") {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
}
