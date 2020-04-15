//
//  Feedback.swift
//  toget-test
//
//  Created by Michael Hamm on 3/22/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit
import MessageUI

class Feedback: UIViewController {
    
    @IBOutlet weak var feedbackInfo1: UILabel!
    @IBOutlet weak var feedbackInfo2: UILabel!
    @IBOutlet weak var feedbackInfo3: UILabel!
    @IBOutlet weak var emailSupport: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackInfo1.text = "We want you to love our product! That's why we want you to let us know of anything that can be improved."
        feedbackInfo1.numberOfLines = 0
        
        feedbackInfo2.text = "If you have a new idea to make your life easier while using our app, let us know! We also hate to see something that may be making your life more difficult. This is why if you let us know of any bugs or problems, we will begin to work on them right away!"
        feedbackInfo2.numberOfLines = 0
        
        feedbackInfo3.text = "Please email us with any improvements, bugs or just to tell us that you love the app! We would love to hear from you!"
        feedbackInfo3.numberOfLines = 0
        
        emailSupport.layer.cornerRadius = 5
        
        
    }
    @IBAction func sendFeedback(_ sender: Any) {
        sendMailFeedback()
    }
    
    func sendMailFeedback() {
        
        guard MFMailComposeViewController.canSendMail() else {
            // show error to user
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setSubject("2Get Support Question")
        composer.setToRecipients(["2GetCustomerService@gmail.com"])
        
        present(composer, animated: true, completion: nil)
    }
}

extension Feedback: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            // show error alert
            controller.dismiss(animated: true)
        }
        
        switch result {
        case .cancelled:
            controller.dismiss(animated: true)
        case .failed:
            print("Failed to Send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        default:
            print("result: \(result)")
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
