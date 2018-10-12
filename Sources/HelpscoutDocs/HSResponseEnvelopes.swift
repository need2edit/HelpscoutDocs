//
//  HSResponseEnvelopes.swift
//  Alamofire
//
//  Created by Jake Young on 10/4/18.
//

import Foundation

public protocol HSSingleItemEnvelopeRepresentable {
    static func itemRoot() -> String
}

public protocol HSCollectionsEnvelopeRepresentable {
    static func collectionsRoot() -> String
}

public struct HSCollectionsEnvelope<T: Codable>: Codable {
    let items: [T]
    let page: Int
    let pages: Int
    let count: Int
}
