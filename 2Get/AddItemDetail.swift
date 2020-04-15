//
//  AddItemDetail.swift
//  toget-test
//
//  Created by Michael Hamm on 3/25/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit

class AddItemDetail: UIViewController {
    
    @IBOutlet weak var itemDetailText: UITextField!
    @IBOutlet weak var addDetailButton: UIButton!
    
    var inputText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendDetailToView(_ sender: Any) {
        inputText = itemDetailText.text!
        mainViewList.addItemDetail(id: viewItemId, name: tempItemName, detail: inputText, hasDetail: true)
        
        tempItemName = ""
        navigationController?.popViewController(animated: true)
    }
}
