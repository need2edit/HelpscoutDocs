//
//  Router.swift
//  Alamofire
//
//  Created by Jake Young on 10/4/18.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    case listSites
    case listCollections(parameters: Parameters)
    case listArticlesForCollection(collectionId: String)
    case listArticlesForCategory(categoryId: String)
    
    case createArticle(parameters: Parameters)
    case updateArticle(articleId: String, parameters: Parameters)
    
    case searchArticles(parameters: Parameters)
    
    case saveDraft(articleId: String, text: String)
    
    static let baseURLString = "https://docsapi.helpscout.net/v1/"
    
    var method: HTTPMethod {
        switch self {
        case .updateArticle, .saveDraft:
            return .put
        case .createArticle:
            return .post
        case .listArticlesForCollection, .listArticlesForCategory, .listCollections, .listSites, .searchArticles:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .listCollections:
            return "collections"
        case .listArticlesForCollection(collectionId: let collectionId):
            return "collections/\(collectionId)/articles"
        case .listArticlesForCategory(categoryId: let categoryId):
            return "categories/\(categoryId)/articles"
        case .createArticle:
            return "articles"
        case .updateArticle(articleId: let articleId, parameters: _):
            return "articles/\(articleId)"
        case .listSites:
            return "sites"
        case .searchArticles:
            return "search/articles"
        case .saveDraft(let articleId, _):
            return "articles/\(articleId)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .createArticle(parameters: let parameters), .updateArticle(articleId: _, parameters: let parameters):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        case .saveDraft(articleId:_, text: let text):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: ["text": text])
        case .listCollections(parameters: let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .searchArticles(parameters: let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}
