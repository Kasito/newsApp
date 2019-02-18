//
//  SearchNews.swift
//  NewsApp
//
//  Created by user on 2/14/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

extension NewsViewController: UISearchBarDelegate {
    
    
//MARK: - search 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            //requestManager.resetSearch()
        ManagerURL.shared.resetSearch()
            updateSearchResults()
           // requestManager.doRequestTo(searchText: validatedText, typeURL: .searchURL)
        ManagerURL.shared.managerUrl(searchText: validatedText, typeURL: .searchURL)
            view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
        searchBar.setShowsCancelButton(true, animated: true)
        let cancelButtonSearchButton = searchBar.value(forKeyPath: "cancelButton") as? UIButton
        cancelButtonSearchButton?.tintColor = UIColor.white
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
        searchBar.setShowsCancelButton(false, animated: true)
        newsSearchBar.showsScopeBar = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
}

