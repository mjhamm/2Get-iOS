//
//  MainController.swift
//  2Get
//
//  Created by Michael Hamm on 4/5/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MainController: UIViewController {
    
    @IBOutlet weak var mainViewContainer: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        bannerView.delegate = self
    }
}

extension MainController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Received Ad")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
}
