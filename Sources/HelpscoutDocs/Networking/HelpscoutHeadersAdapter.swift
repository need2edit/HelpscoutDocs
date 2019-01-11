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
    
    func adapt(_ urlRequest: URLRequest, completion: @escaping (Result<URLRequest>) -> Void) {
        
        var urlRequest = urlRequest
        
        let authorizationHeader = HTTPHeader.authorization(username: apiKey, password: "X")
        
        let result: Result<URLRequest> = Result<URLRequest>.init { () -> URLRequest in
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.setValue(authorizationHeader.value, forHTTPHeaderField: authorizationHeader.name)
            return urlRequest
        }
        
        completion(result)
    }
    
}
