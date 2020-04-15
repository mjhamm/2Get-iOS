//
//  FirstViewController.swift
//  toget-test
//
//  Created by Michael Hamm on 3/17/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit
import CoreData

class MakeItemViewCell: UITableViewCell {
    @IBOutlet weak var makeItemCheckbox: UIButton!
    @IBOutlet weak var makeItemName: UILabel!
}

class MakeItemSectionCell: UITableViewCell {
    @IBOutlet weak var makeSectionTitle: UILabel!
    @IBOutlet weak var makeSectionImage: UIImageView!
}

var tableViewData = [MakeItemCell]()

class MakeList: UITableViewController, UIGestureRecognizerDelegate {
    
    var itemName = ""
    var strikeThrough = false
    var hasDetail = false
    var itemDetail = ""
    
    @IBOutlet var makeListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MakeItemEntity")
        let result = try? managedContext.fetch(fetchRequest)
        
        if result!.isEmpty {
            populateData()
        }
    }    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let makeSectionFetch = NSFetchRequest<NSManagedObject>(entityName: "MakeSectionEntity")
        var returnResult = 1
        
        do {
            if let result = try managedContext?.fetch(makeSectionFetch) {
                for i in result {
                    if i.value(forKey: "sectionname") as! String == tableViewData[section].title {
                        if i.value(forKey: "expanded") as! Bool == true {
                            returnResult = tableViewData[section].items.count + 1
                        } else {
                            returnResult = 1
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
        return returnResult
    }
    
    // Did Select Row
// ----------------------------------------------------------------------------------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ViewItemEntity")
        let makeItemFetch = NSFetchRequest<NSManagedObject>(entityName: "MakeItemEntity")
        let makeSectionFetch = NSFetchRequest<NSManagedObject>(entityName: "MakeSectionEntity")
        
        if indexPath.row == 0 {
            let makeSectionName = tableViewData[indexPath.section].title
            let sections = IndexSet.init(integer: indexPath.section)
            
            if let result = try? managedContext.fetch(makeSectionFetch) {
                for i in result {
                    if i.value(forKey: "sectionname") as! String == makeSectionName {
                        if i.value(forKey: "expanded") as! Bool == true {
                            i.setValue(false, forKey: "expanded")
                            tableView.reloadSections(sections, with: .none)
                            do {
                                try managedContext.save()
                            } catch {
                                print(error)
                            }
                        } else {
                            i.setValue(true, forKey: "expanded")
                            tableView.reloadSections(sections, with: .none)
                            do {
                                try managedContext.save()
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
            
        } else {
            itemName = tableViewData[indexPath.section].items[indexPath.item - 1].makeItemName
            
            if let result = try? managedContext.fetch(makeItemFetch) {
                for i in result {
                    if i.value(forKey: "item") as! String == itemName {
                        if i.value(forKey: "checked") as! Bool == true {
                            itemList.removeAll()
                            for (index, i) in itemList.enumerated() {
                                if (i.value(forKey: "name") as! String == itemName) {
                                    itemList.remove(at: index)
                                }
                            }
                            mainViewList.removeViewItem(name: itemName)
                            var tempItemList: [NSManagedObject] = try! managedContext.fetch(fetchRequest)
                            for (index, i) in tempItemList.enumerated() {
                                tempName = i.value(forKey: "name") as! String
                                tempStrikethrough = i.value(forKey: "strikethrough") as! Bool
                                tempDetail = i.value(forKey: "detail") as! String
                                tempHasDetail = i.value(forKey: "hasDetail") as! Bool
                                managedContext.delete(i)
                                mainViewList.saveViewItem(id: index, name: tempName, strikethrough: tempStrikethrough, detail: tempDetail, hasDetail: tempHasDetail)
                            }
                            i.setValue(false, forKey: "checked")
                            try? managedContext.save()
                            tempItemList.removeAll()
                            self.tableView.reloadRows(at: [indexPath], with: .none)
                        } else {
                            mainViewList.saveViewItem(id: itemList.count, name: itemName, strikethrough: false, detail: "", hasDetail: false)
                            i.setValue(true, forKey: "checked")
                            try? managedContext.save()
                            self.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }
            }
        }
    }
    
// ----------------------------------------------------------------------------------------------------------------------------------------------
    

    // Cell For Row At
// ----------------------------------------------------------------------------------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupCell = tableView.dequeueReusableCell(withIdentifier: "makeCell") as! MakeItemSectionCell
        let dataIndex = indexPath.row - 1
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let makeItemFetch = NSFetchRequest<NSManagedObject>(entityName: "MakeItemEntity")
        let makeSectionFetch = NSFetchRequest<NSManagedObject>(entityName: "MakeSectionEntity")
        
        if indexPath.row == 0 {
            let makeSectionName = tableViewData[indexPath.section].title
            groupCell.makeSectionTitle.text = tableViewData[indexPath.section].title
            
            if let result = try? managedContext?.fetch(makeSectionFetch) {
                for i in result {
                    if i.value(forKey: "sectionname") as! String == makeSectionName {
                        if i.value(forKey: "expanded") as! Bool == true {
                            groupCell.makeSectionImage.image = UIImage(systemName: "chevron.up")
                        } else {
                            groupCell.makeSectionImage.image = UIImage(systemName: "chevron.down")
                        }
                    }
                }
            }

            return groupCell
            
        } else {
            let makeCell = tableView.dequeueReusableCell(withIdentifier: "makeItemCell", for: indexPath) as! MakeItemViewCell
            let makeItemName = tableViewData[indexPath.section].items[dataIndex].makeItemName
            makeCell.makeItemName?.text = makeItemName
            makeCell.makeItemCheckbox.tag = indexPath.section
            
            if let result = try? managedContext?.fetch(makeItemFetch) {
                for i in result {
                    if i.value(forKey: "item") as! String == makeItemName {
                        if i.value(forKey: "checked") as! Bool == true {
                            makeCell.makeItemCheckbox.setImage(UIImage(named: "cross"), for: .normal)
                        } else {
                            makeCell.makeItemCheckbox.setImage(UIImage(named: "checkbox"), for: .normal)
                        }
                    }
                }
            }

            // Click on checkbox button
            makeCell.makeItemCheckbox.addTarget(self, action: #selector(checkboxPressed(_:)), for: .touchUpInside)

            // returns the cell inside of the makeList Viewcontroller Tableview
            return makeCell
        }
    }

// ----------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // Function to perform when a checkbox is selected on an item in the row of the tableview
// ----------------------------------------------------------------------------------------------------------------------------------------------
    @objc func checkboxPressed(_ sender: UIButton) {
        let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ViewItemEntity")
        let makeItemFetch = NSFetchRequest<NSManagedObject>(entityName: "MakeItemEntity")
        
        itemName = tableViewData[sender.tag].items[indexPath!.row - 1].makeItemName
        
        if let result = try? managedContext.fetch(makeItemFetch) {
            for i in result {
                if i.value(forKey: "item") as! String == itemName {
                    if i.value(forKey: "checked") as! Bool == true {
                        itemList.removeAll()
                        for (index, i) in itemList.enumerated() {
                            if (i.value(forKey: "name") as! String == itemName) {
                                itemList.remove(at: index)
                            }
                        }
                        mainViewList.removeViewItem(name: itemName)
                        var tempItemList: [NSManagedObject] = try! managedContext.fetch(fetchRequest)
                        for (index, i) in tempItemList.enumerated() {
                            tempName = i.value(forKey: "name") as! String
                            tempStrikethrough = i.value(forKey: "strikethrough") as! Bool
                            tempDetail = i.value(forKey: "detail") as! String
                            tempHasDetail = i.value(forKey: "hasDetail") as! Bool
                            managedContext.delete(i)
                            mainViewList.saveViewItem(id: index, name: tempName, strikethrough: tempStrikethrough, detail: tempDetail, hasDetail: tempHasDetail)
                        }
                        i.setValue(false, forKey: "checked")
                        try? managedContext.save()
                        tempItemList.removeAll()
                        self.tableView.reloadRows(at: [indexPath!], with: .none)
                    } else {
                        mainViewList.saveViewItem(id: itemList.count, name: itemName, strikethrough: false, detail: "", hasDetail: false)
                        i.setValue(true, forKey: "checked")
                        try? managedContext.save()
                        self.tableView.reloadRows(at: [indexPath!], with: .none)
                    }
                }
            }
        }
    }
    
// ----------------------------------------------------------------------------------------------------------------------------------------------
    
    func uncheckRemovedItems() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let makeItemFetch = NSFetchRequest<NSManagedObject>(entityName: "MakeItemEntity")
        let makeSectionFetch = NSFetchRequest<NSManagedObject>(entityName: "MakeSectionEntity")
        
        if let result = try? managedContext.fetch(makeSectionFetch) {
            for i in result {
                i.setValue(false, forKey: "expanded")
            }
        }
        if let result = try? managedContext.fetch(makeItemFetch) {
            for i in result {
                i.setValue(false, forKey: "checked")
            }
        }
        try? managedContext.save()
        makeListTableView.reloadData()
    }
    
    func refreshedItems() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let makeItemFetch = NSFetchRequest<NSManagedObject>(entityName: "MakeItemEntity")
        let viewItemFetch = NSFetchRequest<NSManagedObject>(entityName: "ViewItemEntity")
        
        if let makeResult = try? managedContext.fetch(makeItemFetch) {
            if let viewResult = try? managedContext.fetch(viewItemFetch) {
                for i in viewResult {
                    if i.value(forKey: "strikethrough") as! Bool == true {
                        let tempViewName = i.value(forKey: "name") as! String
                        for j in makeResult {
                                if j.value(forKey: "item") as! String == tempViewName {
                                    j.setValue(false, forKey: "checked")
                                }
                            }
                        }
                    }
                }
            }
        try? managedContext.save()
        makeListTableView.reloadData()
    }
    
    func populateData() {
        for s in tableViewData {
            saveMakeSection(sectionnname: s.title, expanded: s.opened)
            for i in s.items {
                saveMakeItem(name: i.makeItemName, checked: i.makeItemChecked)
            }
        }
    }
    
    func saveMakeItem(name: String, checked: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MakeItemEntity", in: managedContext)!
        let makeItem = NSManagedObject(entity: entity, insertInto: managedContext)
        makeItem.setValue(name, forKey: "item")
        makeItem.setValue(checked, forKey: "checked")
        
        do {
            try managedContext.save()
            makeItemList.append(makeItem)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveMakeSection(sectionnname: String, expanded: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MakeSectionEntity", in: managedContext)!
        let makeSection = NSManagedObject(entity: entity, insertInto: managedContext)
        
        makeSection.setValue(sectionnname, forKey: "sectionname")
        makeSection.setValue(expanded, forKey: "expanded")
        
        do {
            try managedContext.save()
            makeSectionList.append(makeSection)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getData() {
        tableViewData = [
        MakeItemCell(opened: false, title: "Baby & Childcare", items: [MakeItem(item: "Baby Food", checked: false), MakeItem(item: "Diapers", checked: false), MakeItem(item: "Formula", checked: false), MakeItem(item: "Wipes", checked: false)]),
        MakeItemCell(opened: false, title: "Baking", items: [MakeItem(item: "Baking Powder", checked: false), MakeItem(item: "Baking Soda", checked: false), MakeItem(item: "Brown Sugar", checked: false), MakeItem(item: "Flour", checked: false), MakeItem(item: "Pancake Mix", checked: false), MakeItem(item: "Sugar", checked: false), MakeItem(item: "Syrup", checked: false), MakeItem(item: "Vanilla", checked: false), MakeItem(item: "Yeast", checked: false)]),
        MakeItemCell(opened: false, title: "Beverages", items: [MakeItem(item: "Coffee", checked: false), MakeItem(item: "Juice", checked: false), MakeItem(item: "Soda", checked: false), MakeItem(item: "Tea", checked: false), MakeItem(item: "Water", checked: false)]),
        MakeItemCell(opened: false, title: "Bread", items: [MakeItem(item: "Bagels", checked: false), MakeItem(item: "English Muffins", checked: false), MakeItem(item: "Hamburger/Hot dogs Rolls", checked: false), MakeItem(item: "Pitas", checked: false), MakeItem(item: "Rolls", checked: false), MakeItem(item: "Sandwich", checked: false),MakeItem(item: "Tortilla", checked: false)]),
        MakeItemCell(opened: false, title: "Breakfast & Cereal", items: [MakeItem(item: "Cereal", checked: false), MakeItem(item: "Granola", checked: false), MakeItem(item: "Granola Bars", checked: false), MakeItem(item: "Oatmeal", checked: false)]),
        MakeItemCell(opened: false, title: "Canned Goods", items: [MakeItem(item: "Fruit", checked: false), MakeItem(item: "Pumpkin", checked: false), MakeItem(item: "Soup", checked: false), MakeItem(item: "Tomato Sauce", checked: false), MakeItem(item: "Tuna", checked: false), MakeItem(item: "Vegetables", checked: false)]),
        MakeItemCell(opened: false, title: "Condiments", items: [MakeItem(item: "Jelly", checked: false), MakeItem(item: "Ketchup", checked: false), MakeItem(item: "Mayonnaise", checked: false), MakeItem(item: "Mustard", checked: false), MakeItem(item: "Peanut Butter", checked: false), MakeItem(item: "Pickles", checked: false),MakeItem(item: "Relish", checked: false)]),
        MakeItemCell(opened: false, title: "Dairy", items: [MakeItem(item: "Butter", checked: false), MakeItem(item: "Cheese", checked: false), MakeItem(item: "Cream", checked: false), MakeItem(item: "Cream Cheese", checked: false), MakeItem(item: "Milk", checked: false), MakeItem(item: "Sour Cream", checked: false),MakeItem(item: "Yogurt", checked: false)]),
        MakeItemCell(opened: false, title: "Deli", items: [MakeItem(item: "Deli Cheese", checked: false), MakeItem(item: "Deli Meats", checked: false), MakeItem(item: "Deli Salads", checked: false)]),
        MakeItemCell(opened: false, title: "Frozen Foods", items: [MakeItem(item: "Ice Cream", checked: false), MakeItem(item: "Frozen Meals", checked: false), MakeItem(item: "Frozen Pizza", checked: false), MakeItem(item: "Frozen Potatoes", checked: false), MakeItem(item: "Frozen Vegetables", checked: false), MakeItem(item: "Frozen Waffles", checked: false)]),
        MakeItemCell(opened: false, title: "Health & Beauty", items: [MakeItem(item: "Bandages", checked: false), MakeItem(item: "Cold Medicine", checked: false), MakeItem(item: "Conditioner", checked: false), MakeItem(item: "Deodorant", checked: false), MakeItem(item: "Floss", checked: false), MakeItem(item: "Lotion", checked: false),MakeItem(item: "Pain Relievers", checked: false),MakeItem(item: "Razors", checked: false),MakeItem(item: "Shampoo", checked: false),MakeItem(item: "Shaving Cream", checked: false),MakeItem(item: "Soap", checked: false),MakeItem(item: "Toothpaste", checked: false),MakeItem(item: "Vitamins", checked: false)]),
        MakeItemCell(opened: false, title: "Household", items: [MakeItem(item: "Batteries", checked: false), MakeItem(item: "Glue", checked: false), MakeItem(item: "Light Bulbs", checked: false), MakeItem(item: "Tape", checked: false)]),
        MakeItemCell(opened: false, title: "Laundry, Paper & Cleaning", items: [MakeItem(item: "Aluminum Foil", checked: false), MakeItem(item: "Bleach", checked: false), MakeItem(item: "Dishwashing Fluid", checked: false), MakeItem(item: "Disinfectant Wipes", checked: false),MakeItem(item: "Garbage Bags", checked: false), MakeItem(item: "Glass Cleaner", checked: false), MakeItem(item: "Hand Soap", checked: false), MakeItem(item: "Household Cleaner", checked: false),MakeItem(item: "Laundry Detergent", checked: false), MakeItem(item: "Laundry Softener", checked: false), MakeItem(item: "Paper Towels", checked: false), MakeItem(item: "Plastic Bags", checked: false),MakeItem(item: "Plastic Wrap", checked: false), MakeItem(item: "Sponges", checked: false), MakeItem(item: "Tissues", checked: false), MakeItem(item: "Toilet Paper", checked: false),MakeItem(item: "Trash Bags", checked: false)]),
        MakeItemCell(opened: false, title: "Meat & Seafood", items: [MakeItem(item: "Bacon", checked: false), MakeItem(item: "Beef", checked: false), MakeItem(item: "Burgers", checked: false), MakeItem(item: "Hot Dogs", checked: false), MakeItem(item: "Pork", checked: false), MakeItem(item: "Poultry", checked: false),MakeItem(item: "Sausage", checked: false),MakeItem(item: "Seafood", checked: false)]),
        MakeItemCell(opened: false, title: "Pet Items", items: [MakeItem(item: "Cat Food", checked: false), MakeItem(item: "Cat Litter", checked: false), MakeItem(item: "Dog Food", checked: false)]),
        MakeItemCell(opened: false, title: "Pre-Baked Goods", items: [MakeItem(item: "Brownies", checked: false), MakeItem(item: "Cake", checked: false), MakeItem(item: "Cookies", checked: false), MakeItem(item: "Muffins", checked: false), MakeItem(item: "Pie", checked: false)]),
        MakeItemCell(opened: false, title: "Produce", items: [MakeItem(item: "Apples", checked: false), MakeItem(item: "Avocados", checked: false), MakeItem(item: "Bananas", checked: false), MakeItem(item: "Berries", checked: false), MakeItem(item: "Broccoli", checked: false), MakeItem(item: "Carrots", checked: false),MakeItem(item: "Celery", checked: false),MakeItem(item: "Cucumber", checked: false),MakeItem(item: "Garlic", checked: false),MakeItem(item: "Grapes", checked: false),MakeItem(item: "Oranges", checked: false),MakeItem(item: "Lettuce", checked: false),MakeItem(item: "Melons", checked: false),MakeItem(item: "Mushrooms", checked: false),MakeItem(item: "Onions", checked: false),MakeItem(item: "Peppers", checked: false),MakeItem(item: "Potatoes", checked: false),MakeItem(item: "Tomatoes", checked: false),MakeItem(item: "Zucchini", checked: false)]),
        MakeItemCell(opened: false, title: "Rice & Pasta", items: [MakeItem(item: "Brown Rice", checked: false), MakeItem(item: "Pasta", checked: false), MakeItem(item: "White Rice", checked: false)]),
        MakeItemCell(opened: false, title: "Sauces & Oils", items: [MakeItem(item: "BBQ Sauce", checked: false), MakeItem(item: "Oil", checked: false), MakeItem(item: "Salad Dressing", checked: false), MakeItem(item: "Soy Sauce", checked: false), MakeItem(item: "Spaghetti Sauce", checked: false),MakeItem(item: "Vinegar", checked: false)]),
        MakeItemCell(opened: false, title: "Snacks", items: [MakeItem(item: "Candy", checked: false), MakeItem(item: "Chips", checked: false), MakeItem(item: "Cookies", checked: false), MakeItem(item: "Crackers", checked: false), MakeItem(item: "Dip/Salsa", checked: false),MakeItem(item: "Nuts", checked: false),MakeItem(item: "Popcorn", checked: false),MakeItem(item: "Pretzels", checked: false),MakeItem(item: "Raisins", checked: false),MakeItem(item: "Snack Bars", checked: false)]),
        MakeItemCell(opened: false, title: "Spices", items: [MakeItem(item: "Allspice", checked: false), MakeItem(item: "Basil", checked: false), MakeItem(item: "Bay Leaf", checked: false), MakeItem(item: "Cayenne Pepper", checked: false), MakeItem(item: "Chili Powder", checked: false),MakeItem(item: "Cinnamon", checked: false),MakeItem(item: "Cloves", checked: false),MakeItem(item: "Crushed Red Pepper", checked: false),MakeItem(item: "Cumin", checked: false),MakeItem(item: "Curry", checked: false),MakeItem(item: "Garlic Powder/Salt", checked: false), MakeItem(item: "Oregano", checked: false), MakeItem(item: "Nutmeg", checked: false), MakeItem(item: "Paprika", checked: false), MakeItem(item: "Pepper", checked: false),MakeItem(item: "Rosemary", checked: false),MakeItem(item: "Salt", checked: false),MakeItem(item: "Thyme", checked: false),MakeItem(item: "Turmeric", checked: false)])
        ]
    }
}

