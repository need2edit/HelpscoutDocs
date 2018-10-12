//
//  HSCollection.swift
//  Alamofire
//
//  Created by Jake Young on 10/4/18.
//

import Foundation

public struct HSCollection: Codable {
    
    public let id: String
    public let number: Int
    public let siteId: String
    public let slug: String
    public let visibility: String
    public let order: Int
    public let name: String
    
    public let createdBy: Int
    public let updatedBy: Int
    
    public let createdAt: Date
    public let updatedAt: Date
    
}

extension HSCollection: CustomStringConvertible {
    public var description: String {
        return name
    }
}
