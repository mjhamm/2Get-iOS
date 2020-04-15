//
//  AddCustomItem.swift
//  toget-test
//
//  Created by Michael Hamm on 3/22/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit
import CoreData

class AddCustomItem: UIViewController {
    
    @IBOutlet weak var customItemEditText: UITextField!
    @IBOutlet weak var customItemButton: UIButton!
    @IBOutlet weak var customItemAddedLabel: UILabel!
    
    var inputText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customItemAddedLabel.isHidden = true
    }
    
    @IBAction func sendItemToList(_ sender: Any) {
        inputText = customItemEditText.text!
        
        if inputText != "" {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ViewItemEntity")
            
            if let result = try? managedContext.fetch(fetchRequest) {
                viewItemId = result.count
            }
            
            mainViewList.saveViewItem(id: viewItemId, name: inputText, strikethrough: false, detail: "", hasDetail: false)
            
            customItemEditText.text = ""
            customItemAddedLabel.isHidden = false
            customItemAddedLabel.text = "\(inputText): Added to List"
            
            print(itemList)
            
        } else {
            
            let message = NSLocalizedString("Please enter an item's name to add to your list.", comment: "")
            let alert = UIAlertController(title: "Item cannot be blank.", message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                alert.dismiss(animated: true)
            })
            
            customItemAddedLabel.isHidden = true
            
            present(alert, animated: true)
        }
    }
}
