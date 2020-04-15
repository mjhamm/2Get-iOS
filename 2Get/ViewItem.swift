//
//  ViewItem.swift
//  toget-test
//
//  Created by Michael Hamm on 3/21/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit

class ViewItem: NSObject, NSCoding {
    
    var viewItemName: String
    var viewItemStrikethrough: Bool
    var viewItemDetail: String
    var viewItemHasDetail: Bool
    
    init(item: String, strikeThrough: Bool, detail: String, hasDetail: Bool) {
        self.viewItemName = item
        self.viewItemStrikethrough = strikeThrough
        self.viewItemDetail = detail
        self.viewItemHasDetail = hasDetail
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(viewItemName, forKey: "viewItem")
        coder.encode(viewItemStrikethrough, forKey: "viewChecked")
        coder.encode(viewItemDetail, forKey: "viewDetail")
        coder.encode(viewItemHasDetail, forKey: "hasDetail")
    }
    
    required convenience init?(coder: NSCoder) {
        let item = coder.decodeObject(forKey: "viewItem") as! String
        let checked = coder.decodeBool(forKey: "viewChecked")
        let detail = coder.decodeObject(forKey: "viewDetail")
        let hasDetail = coder.decodeBool(forKey: "hasDetail")
        self.init(item: item, strikeThrough: checked, detail: detail as! String, hasDetail: hasDetail)
    }
    
}
