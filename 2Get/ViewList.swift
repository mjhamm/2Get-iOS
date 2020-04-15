//
//  SecondViewController.swift
//  toget-test
//
//  Created by Michael Hamm on 3/17/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit
import CoreData

var tempName = String()
var tempStrikethrough = Bool()
var tempDetail = String()
var tempHasDetail = Bool()

class ViewItemSectionCell: UITableViewCell {
    
    @IBOutlet weak var viewItemName: UILabel!
    @IBOutlet weak var viewItemDetail: UILabel!
}

class ViewList: UITableViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var viewListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLongPressGesture()
        
        if viewListTableView != nil {
            viewListTableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewListTableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewItem = itemList[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewCell") as! ViewItemSectionCell
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: itemList[indexPath.item].value(forKey: "name") as! String)
        let attributedDetail: NSMutableAttributedString = NSMutableAttributedString(string: itemList[indexPath.item].value(forKey: "detail") as! String)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        attributedDetail.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedDetail.length))
        
        if itemList[indexPath.item].value(forKey: "strikethrough") as! Bool == true {
            cell.viewItemName.attributedText = attributeString
            cell.viewItemDetail.attributedText = attributedDetail
        } else {
            if itemList[indexPath.item].value(forKey: "strikethrough") as! Bool == false {
                cell.viewItemName.attributedText = .none
                cell.viewItemDetail.attributedText = .none
                cell.viewItemName.text = viewItem.value(forKeyPath: "name") as? String
                cell.viewItemDetail.text = viewItem.value(forKeyPath: "detail") as? String
            }
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ViewItemEntity")
        let idPredicate = NSPredicate(format: "id == %d", indexPath.row)
        let namePredicate = NSPredicate(format: "name == %@", itemList[indexPath.row].value(forKey: "name") as! String)
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [idPredicate, namePredicate])
        fetchRequest.predicate = andPredicate

        if itemList[indexPath.row].value(forKey: "strikethrough") as! Bool == true {
        
            do {
                if let result = try? managedContext.fetch(fetchRequest) {
                    for object in result {
                        object.setValue(false, forKey: "strikethrough")
                    }
                }
                try managedContext.save()
                tableView.reloadRows(at: [indexPath], with: .none)
            } catch {
                print("error: \(error)")
            }
        } else {
            do {
                if let result = try? managedContext.fetch(fetchRequest) {
                    for object in result {
                        object.setValue(true, forKey: "strikethrough")
                    }
                }
                try managedContext.save()
                tableView.reloadRows(at: [indexPath], with: .none)
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    // Clears all items from tableviewlist and viewtableentity
    func clearList() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ViewItemEntity")
        
        do {
            if let result = try? managedContext.fetch(fetchRequest) {
                for object in result {
                    managedContext.delete(object)
                }
            }
            try managedContext.save()
        } catch {
            print("error: \(error)")
        }
        itemList.removeAll()
        
        if viewListTableView != nil {
            viewListTableView.reloadData()
        }
    }
    
    func refreshViewList() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ViewItemEntity")
        
        // Adds clause for removing items where strikethrough = true
        fetchRequest.predicate = NSPredicate(format: "strikethrough == %@", NSNumber(value: true))
        
        do {
            itemList.removeAll()
            if let result = try? managedContext.fetch(fetchRequest) {
                for object in result {
                    managedContext.delete(object)
                }
            }
            try managedContext.save()
            let fullRequest = NSFetchRequest<NSManagedObject>(entityName: "ViewItemEntity")
            var tempItemList: [NSManagedObject] = try! managedContext.fetch(fullRequest)
            for (index, i) in tempItemList.enumerated() {
                tempName = i.value(forKey: "name") as! String
                tempStrikethrough = i.value(forKey: "strikethrough") as! Bool
                tempDetail = i.value(forKey: "detail") as! String
                tempHasDetail = i.value(forKey: "hasDetail") as! Bool
                managedContext.delete(i)
                saveViewItem(id: index, name: tempName, strikethrough: tempStrikethrough, detail: tempDetail, hasDetail: tempHasDetail)
            }
            try? managedContext.save()
            tempItemList.removeAll()
        } catch {
            print("error: \(error)")
        }
        
        if viewListTableView != nil {
            viewListTableView.reloadData()
        }
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        if viewListTableView != nil {
            self.viewListTableView.addGestureRecognizer(longPressGesture)
        }
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.viewListTableView)
            if viewListTableView.indexPathForRow(at: touchPoint) != nil {
                
                if let indexPath = viewListTableView.indexPathForRow(at: touchPoint) {
                    
                    tempItemName = itemList[indexPath.row].value(forKey: "name") as! String
                    viewItemId = indexPath.row
                    performSegue(withIdentifier: "itemDetail", sender: self)
                }
            }
        }
    }
    
    func exportList() -> String {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ViewItemEntity")
        
        var exportedList = "2Get Shopping List!\n\n"
        
        if (try? managedContext?.fetch(fetchRequest)) != nil {
            for (index, object) in itemList.enumerated() {
                if index != itemList.count - 1 {
                    if object.value(forKey: "hasDetail") as! Bool == true {
                        if object.value(forKey: "strikethrough") as! Bool == true {
                            exportedList.append("- \(object.value(forKey: "name") as! String)")
                            exportedList.append(" (\(object.value(forKey: "detail") as! String)) \u{2713}\n")
                        } else {
                            exportedList.append("- \(object.value(forKey: "name") as! String)")
                            exportedList.append(" (\(object.value(forKey: "detail") as! String))\n")
                        }
                    } else {
                        if object.value(forKey: "hasDetail") as! Bool == false {
                            if object.value(forKey: "strikethrough") as! Bool == true {
                                exportedList.append("- \(object.value(forKey: "name") as! String) \u{2713}\n")
                            } else {
                                exportedList.append("- \(object.value(forKey: "name")as! String)\n")
                            }
                        }
                    }
                } else {
                    if object.value(forKey: "hasDetail") as! Bool == true {
                        if object.value(forKey: "strikethrough") as! Bool == true {
                            exportedList.append("- \(object.value(forKey: "name") as! String)")
                            exportedList.append(" (\(object.value(forKey: "detail") as! String)) \u{2713}")
                        } else {
                            exportedList.append("- \(object.value(forKey: "name") as! String)")
                            exportedList.append(" (\(object.value(forKey: "detail") as! String))")
                        }
                    } else {
                        if object.value(forKey: "strikethrough") as! Bool == true {
                            exportedList.append("- \(object.value(forKey: "name") as! String) \u{2713}")
                        } else {
                            exportedList.append("- \(object.value(forKey: "name") as! String)")
                        }
                    }
                }
            }
        }
        return exportedList
    }
    
    func saveViewItem(id: Int, name: String, strikethrough: Bool, detail: String, hasDetail: Bool) {
      
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "ViewItemEntity", in: managedContext)!

        let viewItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        viewItem.setValue(id, forKey: "id")
        viewItem.setValue(name, forKeyPath: "name")
        viewItem.setValue(strikethrough, forKeyPath: "strikethrough")
        viewItem.setValue(detail, forKeyPath: "detail")
        viewItem.setValue(hasDetail, forKeyPath: "hasDetail")
        
        // 4
        do {
            try managedContext.save()
            itemList.append(viewItem)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        if viewListTableView != nil {
            viewListTableView.reloadData()
        }
    }
    
    func removeViewItem(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ViewItemEntity")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            if let result = try? managedContext.fetch(fetchRequest) {
                for object in result {
                    managedContext.delete(object)
                }
            }
            try managedContext.save()
        } catch {
            print("error: \(error)")
        }
    }
    
    func addItemDetail(id: Int, name: String, detail: String, hasDetail: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ViewItemEntity")
        let idPredicate = NSPredicate(format: "id == %d", id)
        let namePredicate = NSPredicate(format: "name == %@", name)
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [idPredicate, namePredicate])
        fetchRequest.predicate = andPredicate

        do {
            if let result = try? managedContext.fetch(fetchRequest) {
                for object in result {
                    object.setValue(detail, forKey: "detail")
                    object.setValue(hasDetail, forKey: "hasDetail")
                }
            }
            try managedContext.save()
        } catch {
            print("error: \(error)")
        }
    }
}

