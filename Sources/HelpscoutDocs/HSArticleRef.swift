//
//  HSArticle.swift
//  HelpscoutDocs
//
//  Created by Jake Young on 10/4/18.
//

import Foundation

public struct HSArticleRef: Codable {
    
    public let id: String
    public let number: Int
    public let collectionId: String
    public let slug: String
    public let status: String
    public let hasDraft: Bool
    public let name: String
    public let publicUrl: String?
    public let popularity: Double
    
    public let viewCount: Int
    
    public let createdBy: Int
    public let updatedBy: Int
    
    public let createdAt: Date?
    public let updatedAt: Date?
    public let lastPublishedAt: Date?
    
}
