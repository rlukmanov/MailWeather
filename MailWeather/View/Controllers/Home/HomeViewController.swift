//
//  ViewController.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 21.11.2020.
//

import UIKit
import Alamofire
import DropDown
import CoreData

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var internalRingView: RingView!
    @IBOutlet weak var externalRingView: RingView!
    @IBOutlet weak var internalDownloadRingView: DownloadRingView!
    @IBOutlet weak var externalDownloadRingView: DownloadRingView!
    @IBOutlet weak var centerCircleView: CircleView!
    @IBOutlet weak var mainInfoView: MainInfoView!
    @IBOutlet weak var leftGroundView: CircleView!
    @IBOutlet weak var rightGroundView: CircleView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var openDetailVCButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    private var blurEffectView: UIVisualEffectView?
    private var isFirstAppear = true
    var viewModel = ViewModel()
    var dropButton = DropDown()
    
    var context: NSManagedObjectContext!
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.context = context
        viewModel.loadDataFromBase()
        viewModel.delegate = self
        searchBar.delegate = self
        configureDropButton()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isFirstAppear {
            appearAnimations()
            isFirstAppear = false
        }
    }
    
    // MARK: - bind
    
    private func bind() {
        viewModel.temperatuture.bind { [unowned self] in
            self.temperatureLabel.text = $0
        }
        
        viewModel.city.bind { [unowned self] in
            self.cityLabel.text = $0
        }
        
        viewModel.image.bind { [unowned self] in
            self.iconImageView.image = $0
            UIView.animate(withDuration: 1.0) { self.iconImageView.alpha = 1.0 }
        }
        
        viewModel.errorDescription.bind { [unowned self] in
            self.errorLabel.text = $0
        }
        
        viewModel.isHiddenRefreshButton.bind { [unowned self] in
            self.refreshButton.isHidden = $0
            self.refreshButton.isEnabled = !$0
            if !$0 { UIView.animate(withDuration: 1.0) { self.iconImageView.alpha = 1.0 } }
        }
        
        viewModel.colorTheme.bind { [unowned self] in
            self.setColorTheme(colorTheme: $0)
        }
        
        if !FirstLaunch.isFirstLaunch() {
            viewModel.previousCityFromBase.bind { [unowned self] in
                self.viewModel.loadData(city: $0)
            }
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
            viewModel.loadData(city: item)
            searchBar.text = nil
            view.endEditing(true)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func openDetailVC(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let newViewController = storyboard.instantiateViewController(identifier: Constants.Identifier.detailVC) as? DetailTableViewController else { return }

        newViewController.viewModel = viewModel
        newViewController.tableView.backgroundColor = view.backgroundColor
        
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func refresh(_ sender: Any) {
        viewModel.loadData(city: viewModel.previousDownloadCity)
    }
    
    // MARK: - setColorTheme
    
    private func setColorTheme(colorTheme: ColorTheme) {
        self.view.backgroundColor = UIColor(hex: colorTheme.backgroundColor)
        if let color = UIColor(hex: colorTheme.leftGroundViewColor) { self.leftGroundView.roundColor = color }
        if let color = UIColor(hex: colorTheme.rightGroundViewColor) { self.rightGroundView.roundColor = color }
        if let color = UIColor(hex: colorTheme.externalRingViewColor) { self.externalRingView.ringColor = color }
        if let color = UIColor(hex: colorTheme.internalRingViewColor) { self.internalRingView.ringColor = color }
        if let color = UIColor(hex: colorTheme.centerCircleViewColor) { self.centerCircleView.roundColor = color }
    }
    
    // MARK: - Animations
    
    private func appearAnimations() {
        internalRingView.animateRing(duration: 1.5)
        externalRingView.animateRing(duration: 1.5, delay: 0.25)
        leftGroundView.animateScale(duration: 1.5, scaleFactor: 1.2, scaleStart: 0.7)
        rightGroundView.animateScale(duration: 1.5, scaleFactor: 1.2, scaleStart: 0.7)
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

// MARK: - StopStartDownloadAnimation

extension HomeViewController: StopStartDownloadAnimation {
    
    func startDownloadAnimation() {
        UIView.animate(withDuration: 0.5) { self.iconImageView.alpha = 0.3 }
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
        viewModel.loadData(city: searchBar.text)
        searchBar.text = nil
        dropButton.hide()
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dropButton.dataSource = viewModel.cityHistoryList.getFilterList(searchText: searchText)
        dropButton.show()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        openDetailVCButton.isEnabled = false
        dropButton.dataSource = viewModel.cityHistoryList.getFilterList()
        dropButton.show()
        startSearchBlur()
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        endSearchBlur()
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        openDetailVCButton.isEnabled = true
        searchBar.resignFirstResponder()
        searchBar.text = ""
        dropButton.hide()
    }
}
