//
//  ViewController.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 21.11.2020.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var internalRingView: RingView!
    @IBOutlet weak var externalRingView: RingView!
    @IBOutlet weak var internalDownloadRingView: DownloadRingView!
    @IBOutlet weak var externalDownloadRingView: DownloadRingView!
    @IBOutlet weak var mainInfoView: MainInfoView!
    @IBOutlet weak var leftGroundView: CircleView!
    @IBOutlet weak var rightGroundView: CircleView!
    
    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var openDetailVCButton: UIButton!
    
    private var firstLoad = true
    var viewModel = ViewModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func startDownloadAnimation(_ sender: Any) {
        startDownloadAnimation()
        viewModel.loadData(city: "Moscow")
    }

    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.temperatuture.bind { [unowned self] in
            self.temperatureLabel.text = $0
            stopDownloadAnimation()
        }
        
        viewModel.city.bind { [unowned self] in
            self.cityLabel.text = $0
        }
        
        viewModel.image.bind { [unowned self] in
            self.iconImageView.image = $0
        }
        
        searchBar.delegate = self
        
        startDownloadAnimation()
        viewModel.loadData(city: "Moscow")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstLoad {
            appearAnimations()
            firstLoad = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func openDetailVC(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(identifier: Constants.Identifier.detailVC) as! DetailTableViewController
        
        newViewController.viewModel = viewModel

        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    // MARK: - Animations
    
    private func appearAnimations() {
        internalRingView.animateRing(duration: 1.5)
        externalRingView.animateRing(duration: 1.5, delay: 0.25)
        leftGroundView.animateScale(duration: 1.5, scaleFactor: 1.1)
        rightGroundView.animateScale(duration: 1.5, scaleFactor: 1.1)
    }
    
    func startDownloadAnimation() {
        internalDownloadRingView.startDownloadAnimation()
        externalDownloadRingView.startDownloadAnimation()
        mainInfoView.startDownloadAnimation()
        openDetailVCButton.isEnabled = false
    }
    
    func stopDownloadAnimation() {
        internalDownloadRingView.stopDownloadAnimation()
        externalDownloadRingView.stopDownloadAnimation()
        mainInfoView.stopDownloadAnimation()
        openDetailVCButton.isEnabled = true
    }
}

// MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startDownloadAnimation()
        viewModel.loadData(city: searchBar.text ?? "")
        searchBar.text = nil
        view.endEditing(true)
    }
}
