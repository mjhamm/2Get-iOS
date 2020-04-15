//
//  MakeItem.swift
//  toget-test
//
//  Created by Michael Hamm on 3/21/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit

class MakeItem: NSObject, NSCoding {
    
    var makeItemName: String
    var makeItemChecked: Bool
    
    init(item: String, checked: Bool) {
        self.makeItemName = item
        self.makeItemChecked = checked
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(makeItemName, forKey: "makeItem")
        coder.encode(makeItemChecked, forKey: "makeChecked")
    }
    
    required convenience init?(coder: NSCoder) {
        let item = coder.decodeObject(forKey: "makeItem") as! String
        let checked = coder.decodeBool(forKey: "makeChecked")
        self.init(item: item, checked: checked)
    }
}
