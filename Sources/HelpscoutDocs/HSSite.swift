//
//  HSSite.swift
//  Alamofire
//
//  Created by Jake Young on 10/4/18.
//

import Foundation

public struct HSSite: Codable {
    public let id: String
    public let status: String?
    public let subDomain: String
    public let cname: String
    public let hasPublicSite: Bool
    public let companyName: String
    public let title: String
    public let logoUrl: String?
    public let logoWidth: Int?
    public let logoHeight: Int?
    public let favIconUrl: String?
    public let touchIconUrl: String?
    public let homeUrl: String
    public let homeLinkText: String
    public let bgColor: String?
    public let description: String
    public let hasContactForm: Bool
    public let mailboxId: Int?
    public let contactEmail: String?
    public let styleSheetUrl: String
    public let headerCode: String?
    public let createdBy: Int
    public let updatedBy: Int
    public let createdAt: Date
    public let updatedAt: Date
}
