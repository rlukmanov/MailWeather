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
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var openDetailVCButton: UIButton!
    
    var viewModel = ViewModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func startDownloadAnimation(_ sender: Any) {
        viewModel.loadData()
    }

    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        viewModel.temperatuture.bind { [unowned self] in
            self.temperatureLabel.text = $0
        }
        
        viewModel.city.bind { [unowned self] in
            self.cityLabel.text = $0
        }
        
        viewModel.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        appearAnimations()
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
}

// MARK: - StartStopDownloadAnimation

extension HomeViewController: StartStopDownloadAnimation {
    
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
