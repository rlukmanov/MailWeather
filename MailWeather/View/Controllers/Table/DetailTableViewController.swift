//
//  DetailTableViewController.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var viewModel: TableViewViewModelType?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.cell, for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
        
        guard let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableCell.viewModel = cellViewModel
        
        return tableCell
    }
}
