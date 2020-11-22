//
//  ViewController.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 21.11.2020.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    @IBOutlet weak var internalRingView: RingView!
    @IBOutlet weak var externalRingView: RingView!
    @IBOutlet weak var internalDownloadRingView: DownloadRingView!
    @IBOutlet weak var externalDownloadRingView: DownloadRingView!
    @IBOutlet weak var mainInfoView: MainInfoView!
    @IBOutlet weak var leftGroundView: CircleView!
    @IBOutlet weak var rightGroundView: CircleView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    let net = NetworkManager<ForeCastProvider>()
    
    var viewModel: ViewModel! {
        didSet {
            temperatureLabel.text = viewModel.temperatuture
            cityLabel.text = viewModel.city
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func doAnimate(_ sender: Any) {
        internalRingView.animateRing(duration: 1.5)
        externalRingView.animateRing(duration: 1.5, delay: 0.25)
        leftGroundView.animateScale(duration: 1.5, scaleFactor: 1.1)
        rightGroundView.animateScale(duration: 1.5, scaleFactor: 1.1)
    }
    
    @IBAction func startDownloadAnimation(_ sender: Any) {
        internalDownloadRingView.startDownloadAnimation()
        externalDownloadRingView.startDownloadAnimation()
        mainInfoView.startDownloadAnimation()
    }
    
    @IBAction func stopDownloadAnimation(_ sender: Any) {
        internalDownloadRingView.stopDownloadAnimation()
        externalDownloadRingView.stopDownloadAnimation()
        mainInfoView.stopDownloadAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel()
        fetchRequest()
    }
    
    func fetchRequest() {
        var weatherList: Response?
        
        net.load(service: .showWeather(city: "Moscow"), decodeType: Response.self, completion: { (result) in
            switch result {
            case .success(let response):
                weatherList = response
            case .failure(let error):
                print(error)
            }
            print(weatherList?.list.first)
        })
    }
}

// -------------------------------

extension UIImageView {
    func load(url: URL?) {
        guard let url = url else { return }
        
        DispatchQueue.global().async { [weak self] in
            
            guard let data = try? Data(contentsOf: url) else { return }
            guard let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
