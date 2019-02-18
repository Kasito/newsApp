//
//  NetworkManager.swift
//  NewsApp
//
//  Created by user on 2/14/19.
//  Copyright © 2019 user. All rights reserved.
//

//import SwiftyJSON
//import Alamofire
//
//enum TypeURL {
//    case startURL
//    case searchURL
//}
//
//final class RequestManager {
//
//    var searchResults = [JSON]()
//
//    private var pageString: String {
//        if pageNumber == 1 {
//            return ""
//        } else {
//            return "page=\(pageNumber)&"
//        }
//    }
//
//    var pageNumber = 1
//    var status = "error"
//
//    func doRequestTo(searchText: String, typeURL: TypeURL) {
//        if Reachability.isConnectedToNetwork() == false {
//            let alert = UIAlertView(title: "Attention",
//                                    message: "Internet connection not available!",
//                                    delegate: self,
//                                    cancelButtonTitle: "Ok")
//            alert.show()
//        }
//        var url = ""
//        switch typeURL {
//        case .startURL:
//            url = "https://newsapi.org/v2/top-headlines?country=us&\(pageString)apiKey=a0fdd152dcb14f65a55bfd01b26d0872"
//        case .searchURL:
//            url = "https://newsapi.org/v2/everything?q=\(searchText)&sortBy=publishedAt&\(pageString)apiKey=a0fdd152dcb14f65a55bfd01b26d0872"
//        }
//
//        Alamofire.request(url).responseJSON { response in
//            if let results = response.result.value as? [String:AnyObject] {
//                let items = JSON(results["articles"] as Any).arrayValue
//                self.status = JSON(results["status"] as Any).stringValue
//                self.searchResults += items
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchResultsUpdated"), object: nil)
//            }
//        }
//    }
//
//    func getNextPage(searchText: String) {
//        pageNumber += 1
//        doRequestTo(searchText: searchText, typeURL: .searchURL)
//    }
//
//    func resetSearch() {
//        searchResults = []
//    }
//}


import SwiftyJSON
import Alamofire


final class Request {
    
    static var searchResults = [JSON]()
    
    static var status = "error"

//MARK: - request
    static func doRequestTo(url: String) {
        Alamofire.request(url).responseJSON { response in
            if let results = response.result.value as? [String:AnyObject] {
                let items = JSON(results["articles"] as Any).arrayValue
                self.status = JSON(results["status"] as Any).stringValue
                self.searchResults += items
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchResultsUpdated"), object: nil)
            }
        }
    }
}
