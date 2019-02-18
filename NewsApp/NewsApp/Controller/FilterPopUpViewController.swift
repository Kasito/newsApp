//
//  PopUpController.swift
//  NewsApp
//
//  Created by user on 2/15/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class FilterPopUpViewController: UIViewController {
    
    weak var delegate: DataEnteredDelegate? 
    
    @IBOutlet weak var tableView: UITableView!
    
    var filterText = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
   private func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
   private func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished) {
                self.view.removeFromSuperview()
            }
        })
    }
}

//MARK: - DataSource, delegate tableView
extension FilterPopUpViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopUpCell", for: indexPath) as! FilterCell
        cell.filterLabel.text = filterText[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.userDidEnterFilter(info: filterText[indexPath.row])
        removeAnimate()
    }
}
