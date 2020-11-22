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
    
    func fetchRequest() {
//        let url = "dasd"
//        AF.request(url).responseDecodable(of: Response.self) { (response) in
//            guard let listWeather = response.value else { return }
//            print(listWeather)
//        }
    }
    
    override func viewDidLoad() {
        let net = NetworkManager<ForeCastProvider>()

        net.load(service: .showWeather(city: "Moscow"), decodeType: Response.self, completion: { (result) in
            print()
            
        })
    }
}
