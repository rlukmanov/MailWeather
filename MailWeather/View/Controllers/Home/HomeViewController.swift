//
//  ViewController.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 21.11.2020.
//

import UIKit
import Alamofire
import DropDown

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var internalRingView: RingView!
    @IBOutlet weak var externalRingView: RingView!
    @IBOutlet weak var internalDownloadRingView: DownloadRingView!
    @IBOutlet weak var externalDownloadRingView: DownloadRingView!
    @IBOutlet weak var mainInfoView: MainInfoView!
    @IBOutlet weak var leftGroundView: CircleView!
    @IBOutlet weak var rightGroundView: CircleView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var openDetailVCButton: UIButton!

    private var firstLoad = true
    private var blurEffectView: UIVisualEffectView?
    var viewModel = ViewModel()
    var dropButton = DropDown()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDropButton()
        
        bind()
        searchBar.delegate = self
        
        startDownloadAnimation()
        viewModel.loadData(city: "New York")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstLoad {
            appearAnimations()
            firstLoad = false
        }
    }
    
    // MARK: - bind
    
    private func bind() {
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
    }
    
    // MARK: - configureDropButton
    
    private func configureDropButton() {
        dropButton.anchorView = searchBar
        dropButton.bottomOffset = CGPoint(x: 6, y: (dropButton.anchorView?.plainView.bounds.height)!)
        dropButton.backgroundColor = .clear
        dropButton.dimmedBackgroundColor = .clear
        dropButton.selectionBackgroundColor = .clear
        dropButton.selectedTextColor = .lightGray
        dropButton.shadowColor = .clear
        
        dropButton.direction = .bottom
        dropButton.textColor = .white
        dropButton.dismissMode = .automatic
        
        dropButton.selectionAction = { [unowned self] (index: Int, item: String) in
            startDownloadAnimation()
            viewModel.loadData(city: item)
            searchBar.text = nil
            view.endEditing(true)
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
    
    func startSearchBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        backgroundView.addSubview(blurEffectView)
    }
    
    func endSearchBlur() {
        blurEffectView?.removeFromSuperview()
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dropButton.dataSource = viewModel.getFilterList(searchText: searchText)
        dropButton.show()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        openDetailVCButton.isEnabled = false
        startSearchBlur()
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        endSearchBlur()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        openDetailVCButton.isEnabled = true
        dropButton.hide()
    }
}
