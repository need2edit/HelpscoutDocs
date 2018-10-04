import Alamofire


public class HelpscoutDocs {
    
    let api_password: String
    
    public init(api_password: String) {
        self.api_password = api_password
    }
    
    public func listArticles(completionHandler: ([HSArticleRef]) -> Void) {
        
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            print(response)
        }
        
    }
    
    
}
