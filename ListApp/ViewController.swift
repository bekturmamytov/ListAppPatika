//
//  ViewController.swift
//  ListApp
//
//  Created by Bektur Mamytov on 21/10/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var alertController = UIAlertController()
    
    var data = [NSManagedObject]() //Type changed from [String] to [NSManagedObject] to store the data in CoreData.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetch()
        
    }
    
    
    
    @IBAction func removeBarButtonTapped(_ sender: UIBarButtonItem) {
        presentAlert(title: "Alert!",
                     message: "Are you sure remove all items?",
                     cancelButtonTitle: "Cancel",
                     defaultButtonTitle: "Remove") { _ in
            
            //self.deleteAllData(entity: "ListItem")

            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            
            for item in self.data {
                managedObjectContext?.delete(item)
            }
            try? managedObjectContext?.save()
            
            self.fetch()
        }
        
        
    }
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        presentAddAlert()
    }
    
    func presentAddAlert() {
        presentAlert(title: "Add new element",
                     message: nil,
                     cancelButtonTitle: "Canccel",
                     isTextFieldAvailable: true,
                     defaultButtonTitle: "Add",
                     defaultButtonHandler: {_ in
            let text = self.alertController.textFields?.first?.text
            if text != "" {
                //self.data.append((text)!)
                
                //How to add data to CoreData
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                let managedObjectContext = appDelegate?.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: managedObjectContext!)
                let listItem = NSManagedObject(entity: entity!, insertInto: managedObjectContext!)
                
                listItem.setValue(text, forKey: "title")
                
                try? managedObjectContext?.save()
                
                self.fetch()
            } else {
                self.presentWarningAlert()
            }
        }
        )
    }
    
    func presentWarningAlert() {
        presentAlert(title: "Alert",
                     message: "You can't add an empty element",
                     cancelButtonTitle: "OK")
    }
    
    func presentAlert(title: String?,
                      message: String?,
                      preferedStyle: UIAlertController.Style = .alert,
                      cancelButtonTitle: String?,
                      isTextFieldAvailable: Bool = false,
                      defaultButtonTitle: String? = nil,
                      defaultButtonHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: preferedStyle)
        if defaultButtonTitle != nil {
            let defaultButton = UIAlertAction(title: defaultButtonTitle,
                                              style: .default,
                                              handler: defaultButtonHandler)
            alertController.addAction(defaultButton)
        }
        
        
        let cancelButton = UIAlertAction(title: cancelButtonTitle,
                                         style: .cancel)
        
        if isTextFieldAvailable {
            alertController.addTextField()
        }
        
        
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
    }
    
    func fetch() {
        //how to fetch data from CoreData to UI
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        
        data = try! managedObjectContext!.fetch(fetchRequest)
        
        tableView.reloadData()
    }
    //this method delete all item in the entity
    func deleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedObjectContext!.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedObjectContext!.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let listItem = data[indexPath.row]
        cell.textLabel?.text = listItem.value(forKey: "title") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "Delete") { _, _, _ in
            
            
            //self.data.remove(at: indexPath.row)
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            managedObjectContext?.delete(self.data[indexPath.row])
            try? managedObjectContext?.save()
            
            self.fetch()
        }
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .destructive,
                                              title: "Edit") { _, _, _ in
            self.presentAlert(title: "Reduct the element",
                              message: nil,
                              cancelButtonTitle: "Canccel",
                              isTextFieldAvailable: true,
                              defaultButtonTitle: "Edit",
                              defaultButtonHandler: {_ in
                let text = self.alertController.textFields?.first?.text
                if text != "" {
                    //self.data[indexPath.row] = text!
                    
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    let managedObjectContext = appDelegate?.persistentContainer.viewContext
                    
                    self.data[indexPath.row].setValue(text, forKey: "title")
                    
                    if managedObjectContext!.hasChanges {
                        try? managedObjectContext?.save()
                    }
                    
                    self.tableView.reloadData()
                } else {
                    self.presentWarningAlert()
                }
            }
            )
        }
        
        editAction.backgroundColor = .systemYellow
        
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return config
    }
}
