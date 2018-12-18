import Foundation
import Alamofire

public class HelpscoutDocs {
    
    private let session = Alamofire.SessionManager.default
    private let adapter: HelpscoutHeadersAdapter
    
    public init(apiKey: String) {
        self.adapter = HelpscoutHeadersAdapter(apiKey: apiKey)
        self.session.adapter = self.adapter
    }
    
    private func makeRequest(route: Router, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        
        // we handle authentication using the adapter
        session.request(route).responseJSON(completionHandler: completionHandler)
        
    }
    
    private func makeRequest<T: Codable>(route: Router, rootKey: String, completionHandler: @escaping ([T]) -> Void) {
        makeRequest(route: route) { response in
            
            let result = response.map { $0 }
            guard let responseJSON = result.value as? [String: Any],
                let json = responseJSON[rootKey] as? [String: Any] else { return completionHandler([]) }
            do {
                completionHandler(try mapResultToCollectionsEnvelope(json).items)
            } catch {
                print(error)
                completionHandler([])
            }
            
        }
    }
    
    public func listCollections(siteId: String?, completionHandler:  @escaping ([HSCollection]) -> Void) {
        makeRequest(route: .listCollections(parameters: ["siteId": siteId ?? ""]), rootKey: "collections", completionHandler: completionHandler)
    }
    
    public func listArticles(collectionId: String, completionHandler:  @escaping ([HSArticleRef]) -> Void) {
        makeRequest(route: .listArticlesForCollection(collectionId: collectionId), rootKey: "articles", completionHandler: completionHandler)
    }
    
    public func listSites(completionHandler:  @escaping ([HSSite]) -> Void) {
        makeRequest(route: .listSites, rootKey: "sites", completionHandler: completionHandler)
    }
    
    public func saveDraft(articleId: String, text: String, completionHandler: @escaping (Bool) -> Void) {
        makeRequest(route: .saveDraft(articleId: articleId, text: text)) { result in
            
            guard let statusCode = result.response?.statusCode else {
                completionHandler(false)
                return
            }
            
            completionHandler(statusCode == 200)
        }
    }
    
    public func createArticle(collectionId: String, slug: String, name: String, htmlText: String, categoryIds: [String], completionHandler: @escaping (HSArticleRef?) -> Void) {
        
        let url = "https://docsapi.helpscout.net/v1/articles?reload=true"
        
        session.request(url, method: .post, parameters: ["collectionId": collectionId, "status": "unpublished", "slug": slug, "name": name, "text": htmlText], encoding: JSONEncoding.default, headers: nil).responseJSON { result in
            
            if let json = result.value as? [String: Any] {
                
                let decoder = JSONDecoder()
                if #available(OSX 10.12, *) {
                    decoder.dateDecodingStrategy = .iso8601
                }
                
                do {
                    guard let articleJSON = json["article"] else { return completionHandler(nil) }
                    let data = try JSONSerialization.data(withJSONObject: articleJSON, options: [])
                    let article = try decoder.decode(HSArticleRef.self, from: data)
                    completionHandler(article)
                } catch {
                    completionHandler(nil)
                }
                
                
            } else {
                print("NO DATA")
                completionHandler(nil)
            }
            
        }
        
    }
    
    public func updateArticle(articleId: String, slug: String, name: String, htmlText: String, categories: [String]? = nil, completionHandler: @escaping (HSArticleRef?) -> Void) {
        
        print("Starting update...")
        
        // JSON Body
        let body: [String : Any] = [
            "text": "\(htmlText)",
            "name": "\(name)",
            "slug": "\(slug)"
        ]
        
        // Fetch Request
        session.request("https://docsapi.helpscout.net/v1/articles/\(articleId)", method: .put, parameters: body, encoding: JSONEncoding.default)
            .responseJSON { response in
                if (response.result.error == nil) {
                    print(String(data: response.data!, encoding: .utf8)!)
                    completionHandler(nil)
                }
                else {
                    print(String(data: response.data!, encoding: .utf8)!)
                    completionHandler(nil)
                }
        }
    }
    
    
    public func searchArticles(query: String, completionHandler: @escaping ([HSArticleSearch]) -> Void) {
        session.request(Router.searchArticles(parameters: ["query": query])).responseJSON { response in
            
            let result = response.map { $0 }
            guard let responseJSON = result.value as? [String: Any],
                let json = responseJSON["articles"] as? [String: Any] else { return completionHandler([]) }
            do {
                completionHandler(try mapResultToCollectionsEnvelope(json).items)
            } catch {
                print(error)
                completionHandler([])
            }
        }
    }
    
}

func mapResultToCollectionsEnvelope<T: Codable>(_ json: Any) throws -> HSCollectionsEnvelope<T> {
    let data = try JSONSerialization.data(withJSONObject: json, options: [])
    let decoder = JSONDecoder()
    if #available(OSX 10.12, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return try decoder.decode(HSCollectionsEnvelope<T>.self, from: data)
}
