//
//  InitialViewController.swift
//  2Get
//
//  Created by Michael Hamm on 4/3/20.
//  Copyright © 2020 Michael Hamm. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

var mainViewList = ViewList()
var mainMakeList = MakeList()
var itemList: [NSManagedObject] = []
var makeItemList: [NSManagedObject] = []
var makeSectionList: [NSManagedObject] = []
var viewItemId = -1
var tempItemName = ""
var itemDetail = ""

var MakeListController = MakeList()
var ViewListController = ViewList()

class InitialViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    var moreButton = UIBarButtonItem()
    var tabbarController = TabbarController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var moreButton: UIBarButtonItem!
        
        tabbarController = TabbarController()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchViewRequest = NSFetchRequest<NSManagedObject>(entityName: "ViewItemEntity")
        let fetchMakeRequest = NSFetchRequest<NSManagedObject>(entityName: "MakeItemEntity")
        let fetchSections = NSFetchRequest<NSManagedObject>(entityName: "MakeSectionEntity")
        fetchMakeRequest.returnsObjectsAsFaults = false
        fetchSections.returnsObjectsAsFaults = false
        
        do {
            itemList = try managedContext.fetch(fetchViewRequest)
            makeItemList = try managedContext.fetch(fetchMakeRequest)
            makeSectionList = try managedContext.fetch(fetchSections)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshList))
        refreshButton.tintColor = #colorLiteral(red: 0, green: 0.740378538, blue: 0, alpha: 1)
        self.navigationItem.leftBarButtonItem = refreshButton
        
        var moreButtonImg = UIImage(named: "more_horiz")
        moreButtonImg = moreButtonImg?.withRenderingMode(.alwaysOriginal)
        moreButton = UIBarButtonItem(image: moreButtonImg, style: .done, target: self, action: #selector(moreOptions))
        moreButton.tintColor = #colorLiteral(red: 0, green: 0.740378538, blue: 0, alpha: 1)
        self.navigationItem.rightBarButtonItem = moreButton
        
        let logo = UIImage(named: "total")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
        let addImage = UIImage(named: "plus")
        let addButton = UIButton(frame: CGRect(x: view.bounds.maxX - 75, y: view.bounds.maxY - 150, width: 50, height: 50))
        addButton.setImage(addImage, for: .normal)
        addButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.view.addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
    }
    
    @objc func addItem() {
        performSegue(withIdentifier: "customItem", sender: tabbarController)
    }
    
    // Function to open the Refresh List alert
    @objc func refreshList() {
        if !itemList.isEmpty {
            let refreshMessage = NSLocalizedString("Are you sure you want to refresh your list?", comment: "")
            let refreshAlert = UIAlertController(title: nil, message: refreshMessage, preferredStyle: .alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                refreshAlert.dismiss(animated: true)
            })
            refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default) { _ in
                //self.MakeListController.refreshedItems()
                //self.ViewListController.refreshViewList()
                refreshAlert.dismiss(animated: true)
            })
            self.present(refreshAlert, animated: true)
        } else {
            let refreshMessage = NSLocalizedString("There is nothing to refresh on your list.", comment: "")
            let refreshAlert = UIAlertController(title: nil, message: refreshMessage, preferredStyle: .alert)
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                refreshAlert.dismiss(animated: true)
            })
            self.present(refreshAlert, animated: true)
        }
    }
    
    // Function to open the More Options alert
    @objc func moreOptions() {
        
        let message = NSLocalizedString("More Options", comment: "")
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        // Clears the View List and Unchecks/Collapses all views in Make List
        alert.addAction(UIAlertAction(title: "Clear List", style: .default) { [unowned self] _ in
            if !itemList.isEmpty {
                let clearMessage = NSLocalizedString("Are you sure you want to clear your list?", comment: "")
                let clearAlert = UIAlertController(title: nil, message: clearMessage, preferredStyle: .alert)
                clearAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    clearAlert.dismiss(animated: true)
                })
                clearAlert.addAction(UIAlertAction(title: "Confirm", style: .default) { _ in
                    //self.ViewListController.clearList()
                    //self.MakeListController.uncheckRemovedItems()
                    clearAlert.dismiss(animated: true)
                })
                self.present(clearAlert, animated: true)
            } else {
                let clearMessage = NSLocalizedString("There is nothing to clear from your list.", comment: "")
                let clearAlert = UIAlertController(title: nil, message: clearMessage, preferredStyle: .alert)
                clearAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    clearAlert.dismiss(animated: true)
                })
                self.present(clearAlert, animated: true)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Share List...", style: .default) { _ in
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                //controller.body = self.ViewListController.exportList()
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        })
        
        alert.addAction(UIAlertAction(title: "About 2Get", style: .default) { [unowned self] _ in
            self.performSegue(withIdentifier: "aboutSegue", sender: self)
        })
        
        alert.view.superview?.isUserInteractionEnabled = true

        alert.popoverPresentationController?.barButtonItem = moreButton
        
        present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(gesture:))))
        })
    }
    
    // Function to close the alert dialog
    @objc func alertClose(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}
