//
//  MainContainer.swift
//  2Get
//
//  Created by Michael Hamm on 4/3/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit

var banner = UIView()
var bannerStack = UIStackView()

class MainContainer: UIViewController {
    
    @IBOutlet weak var bannerStackView: UIStackView!
    @IBOutlet weak var bannerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerStack = bannerStackView
        banner = bannerView
    }
}
