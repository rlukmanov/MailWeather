//
//  DetailTableViewController.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.cell, for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
