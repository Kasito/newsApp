//
//  ViewController.swift
//  NewsApp
//
//  Created by user on 2/14/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SafariServices

final class NewsViewController: UIViewController, DataEnteredDelegate {
    
    @IBOutlet weak var tabelView: UITableView!
    
    @IBOutlet weak var newsSearchBar: UISearchBar!
    
    var searchResults = [JSON]() {
        didSet {
            tabelView.reloadData()
        }
    }
    
    private (set) lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    
//MARK: - validated Text
    var validatedText: String {
        return self.newsSearchBar.text!.replacingOccurrences(of: " ", with: "")
    }

//MARK: - refreshControl
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    private var country = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
    
    private var category = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabelView.delegate = self
        tabelView.dataSource = self
        
        newsSearchBar.delegate = self
        
        tabelView.addSubview(self.refreshControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsViewController.updateSearchResults), name: NSNotification.Name(rawValue: "searchResultsUpdated"), object: nil)
        
        ManagerURL.shared.managerUrl(searchText: "", typeURL: .startURL)
    }
    
    @IBAction private func categoryButton(_ sender: UIButton) {
        showPopUpVC (with: category)
    }
    
    @IBAction private func countryButton(_ sender: UIButton) {
        showPopUpVC (with: country)
    }
    
    @IBAction private func sourcesButton(_ sender: UIButton) {
        var source = [""]
        for i in searchResults {
            if [i["source"]["id"].stringValue] != [""] {
                source += [i["source"]["id"].stringValue]
            }
        }
        showPopUpVC (with: source)
    }
    
    @objc func updateSearchResults() {
        searchResults = Request.searchResults
    }
    
    @objc private func dismissKeyboard() {
        newsSearchBar.resignFirstResponder()
    }
    
//MARK: - open Safari
    private func openSafari(with url: String) {
        let downloadURL = URL(string: url)
        let svc = SFSafariViewController(url: downloadURL!)
        present(svc, animated: true, completion: nil)
    }
    
//MARK: - Refresh resault
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        if Request.status == "ok" {
            ManagerURL.shared.getNextPage(searchText: validatedText)
        } else {
            refreshControl.endRefreshing()
        }
        refreshControl.endRefreshing()
    }
    
    func userDidEnterFilter(info: String) {
        switch true {
        case country.contains(info):
            ManagerURL.shared.shooseFilter = "country=\(info)&"
            ManagerURL.shared.resetSearch()
            ManagerURL.shared.managerUrl(searchText: info, typeURL: .startURL)
            updateSearchResults()
        case category.contains(info):
            ManagerURL.shared.shooseFilter = "category=\(info)&"
            ManagerURL.shared.resetSearch()
            ManagerURL.shared.managerUrl(searchText: info, typeURL: .startURL)
             updateSearchResults()
        default:
            ManagerURL.shared.shooseFilter = "sources=\(info)&"
            ManagerURL.shared.resetSearch()
            ManagerURL.shared.managerUrl(searchText: info, typeURL: .startURL)
             updateSearchResults()
        }
    }

//MARK: - popUpVC
    private func showPopUpVC (with filterText: [String]) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! FilterPopUpViewController
        popOverVC.delegate = self
        popOverVC.filterText = filterText
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    

//MARK: - deinit notification
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - TableViewDataSource, Delegate
extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsCell
        
        cell.authorLabel.text = searchResults[indexPath.row]["author"].stringValue
        cell.descriptionLabel.text = searchResults[indexPath.row]["description"].stringValue
        cell.titleLabel.text = searchResults[indexPath.row]["title"].stringValue
        cell.sourceLabel.text = searchResults[indexPath.row]["source"]["name"].stringValue
        
        let url = searchResults[indexPath.row]["urlToImage"].stringValue
        if  let downloadURL = URL(string: url) {
            let resource = ImageResource(downloadURL: downloadURL, cacheKey: url)
            cell.newsImage.kf.setImage(with: resource)
        }
        
        if indexPath.row == searchResults.count {
            if Request.status == "ok" {
                ManagerURL.shared.getNextPage(searchText: validatedText)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = searchResults[indexPath.row]["url"].stringValue
        openSafari(with: link)
    }
}
