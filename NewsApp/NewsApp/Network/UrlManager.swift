//
//  UrlManager.swift
//  NewsApp
//
//  Created by user on 2/16/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

enum TypeURL {
    case startURL
    case searchURL
}

final class ManagerURL {
    
    static let shared = ManagerURL()
    
    private var pageString: String {
        if pageNumber == 1 {
            return ""
        } else {
            return "page=\(pageNumber)&"
        }
    }
    
    var shooseFilter = ""
    
   private var filterString: String {
        if shooseFilter == "" {
            return "category=business&"
        } else {
            return shooseFilter
        }
    }
    
    private var pageNumber = 1

//MARK: - maneger url
    func managerUrl(searchText: String, typeURL: TypeURL) {
        if Reachability.isConnectedToNetwork() == false {
            let alert = UIAlertView(title: "Attention",
                                    message: "Internet connection not available!",
                                    delegate: self,
                                    cancelButtonTitle: "Ok")
            alert.show()
        }
        var url = ""
        switch typeURL {
        case .startURL:
            url = "https://newsapi.org/v2/top-headlines?\(filterString)\(pageString)apiKey=a0fdd152dcb14f65a55bfd01b26d0872"
        case .searchURL:
            url = "https://newsapi.org/v2/everything?q=\(searchText)&sortBy=publishedAt&\(pageString)apiKey=a0fdd152dcb14f65a55bfd01b26d0872"
        }
        Request.doRequestTo(url: url)
    }
    
    func getNextPage(searchText: String) {
        pageNumber += 1
        if searchText == "" {
           managerUrl(searchText: searchText, typeURL: .startURL)
        } else {
        managerUrl(searchText: searchText, typeURL: .searchURL)
    }
}
    
    func resetSearch() {
        Request.searchResults = []
    }
}
