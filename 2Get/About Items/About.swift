//
//  About.swift
//  toget-test
//
//  Created by Michael Hamm on 3/21/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit

class AboutView: UIViewController {
    
    @IBOutlet weak var aboutInfo1: UILabel!
    @IBOutlet weak var aboutInfo2: UILabel!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var endUserButton: UIButton!
    @IBOutlet weak var openSourceButton: UIButton!
    @IBOutlet weak var versionNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutInfo1.text = "Here at 2Get, we are helping to create an easy experience for keeping track of the most common items that you might need throughout your week."
        aboutInfo1.numberOfLines = 0
        
        aboutInfo2.text = "Whether you are going to the store to just pick up some milk, or need to make a list of your entire food shopping before you leave the house, 2Get is here to help you prepare."
        aboutInfo2.numberOfLines = 0
        
        versionNumber.text = "1.0.0"
        
        feedbackButton.layer.cornerRadius = 5
        helpButton.layer.cornerRadius = 5
        privacyButton.layer.cornerRadius = 5
        termsButton.layer.cornerRadius = 5
        endUserButton.layer.cornerRadius = 5
        
        openSourceButton.isHidden = true
        openSourceButton.layer.cornerRadius = 5
        
    }
}
