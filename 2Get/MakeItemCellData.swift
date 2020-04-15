//
//  MakeItemCellData.swift
//  toget-test
//
//  Created by Michael Hamm on 3/22/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit

class MakeItemCell {
    
    var opened: Bool
    var title: String
    var items: [MakeItem]
    
    init(opened: Bool, title: String, items: [MakeItem]) {
        self.opened = opened
        self.title = title
        self.items = items
    }
    
}
